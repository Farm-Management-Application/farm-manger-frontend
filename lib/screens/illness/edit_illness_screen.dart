import 'package:flutter/material.dart';
import '../../widgets/custom_form_elements.dart';
import '../../widgets/custom_app_bar.dart';
import '../../models/illness.dart';
import '../../services/illness_service.dart';
import '../../services/chicken_service.dart';
import '../../services/fish_service.dart';
import '../../services/pig_service.dart';

class EditIllnessScreen extends StatefulWidget {
  final Illness illness;

  EditIllnessScreen({required this.illness});

  @override
  _EditIllnessScreenState createState() => _EditIllnessScreenState();
}

class _EditIllnessScreenState extends State<EditIllnessScreen> {
  final _formKey = GlobalKey<FormState>();
  final IllnessService _illnessService = IllnessService();

  late String _livestockType;
  dynamic _selectedGroup;
  late String _illnessDescription;
  late double _treatmentCost;
  late int _affectedCount;
  DateTime? _startDate;
  DateTime? _endDate;

  List<String> _livestockTypes = ['Chicken', 'Fish', 'Pig'];
  List<dynamic> _livestockGroups = [];

  @override
  void initState() {
    super.initState();
    _livestockType = widget.illness.livestockType;
    _illnessDescription = widget.illness.illnessDescription;
    _treatmentCost = widget.illness.treatmentCost;
    _affectedCount = widget.illness.affectedCount;
    _startDate = widget.illness.startDate;
    _endDate = widget.illness.endDate;

    // Fetch the livestock groups and select the correct one
    _fetchLivestockGroups(_livestockType);
  }

  Future<void> _fetchLivestockGroups(String livestockType) async {
    List<dynamic> groups = [];
    if (livestockType == 'Chicken') {
      groups = await ChickenService().getAllChickenGroups();
    } else if (livestockType == 'Fish') {
      groups = await FishService().getAllFishGroups();
    } else if (livestockType == 'Pig') {
      groups = await PigService().getAllPigGroups();
    }

    setState(() {
      _livestockGroups = groups;

      // Manually find and set the selected group
      _selectedGroup = null;
      for (var group in _livestockGroups) {
        if (group.id == widget.illness.livestockId) {
          _selectedGroup = group;
          break;
        }
      }

      if (_selectedGroup == null && _livestockGroups.isNotEmpty) {
        _selectedGroup = _livestockGroups[0];
      }

      print('selected group: ' + (_selectedGroup != null ? _selectedGroup.name : 'None'));
    });
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
        _endDate = null; // Reset end date when start date changes
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    if (_startDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez d\'abord sélectionner la date de début')),
      );
      return;
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? _startDate!.add(Duration(days: 1)),
      firstDate: _startDate!,
      lastDate: DateTime(2100), // Allow future dates
    );

    if (picked != null && picked != _endDate) {
      setState(() {
        _endDate = picked;
      });
    }
  }

  Future<void> _updateIllness(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        Illness updatedIllness = Illness(
          id: widget.illness.id,
          livestockType: _livestockType,
          livestockId: _selectedGroup.id,
          illnessDescription: _illnessDescription,
          treatmentCost: _treatmentCost,
          affectedCount: _affectedCount,
          startDate: _startDate!,
          endDate: _endDate,
          isDeleted: widget.illness.isDeleted,
          createdAt: widget.illness.createdAt,
          updatedAt: DateTime.now(),
        );

        await _illnessService.updateIllness(widget.illness.id, updatedIllness);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Maladie mise à jour avec succès')),
        );

        Navigator.pop(context, true);
      } catch (e) {
        print('Error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de la mise à jour de la maladie: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Modifier la maladie'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<String>(
                decoration: globalInputDecoration.copyWith(labelText: 'Type de bétail'),
                value: _livestockType,
                items: _livestockTypes.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _livestockType = value!;
                    _selectedGroup = null; // Reset the selected group
                    _fetchLivestockGroups(_livestockType);
                  });
                },
                validator: (value) => value == null || value.isEmpty ? 'Veuillez choisir un type de bétail' : null,
                onSaved: (value) => _livestockType = value!,
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<dynamic>(
                decoration: globalInputDecoration.copyWith(labelText: 'Groupe de bétail'),
                value: _selectedGroup,
                items: _livestockGroups.map((group) {
                  return DropdownMenuItem<dynamic>(
                    value: group,
                    child: Text(
                      (group as dynamic).name,
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedGroup = value; // Store the selected group
                  });
                },
                validator: (value) => value == null ? 'Veuillez choisir un groupe de bétail' : null,
                onSaved: (value) => _selectedGroup = value,
              ),
              SizedBox(height: 16),
              TextFormField(
                initialValue: _illnessDescription,
                decoration: globalInputDecoration.copyWith(labelText: 'Description de la maladie'),
                validator: (value) => value == null || value.isEmpty ? 'Veuillez entrer une description' : null,
                onSaved: (value) => _illnessDescription = value!,
              ),
              SizedBox(height: 16),
              TextFormField(
                initialValue: _treatmentCost.toString(),
                decoration: globalInputDecoration.copyWith(labelText: 'Coût du traitement'),
                keyboardType: TextInputType.number,
                validator: (value) => value == null || value.isEmpty ? 'Veuillez entrer le coût du traitement' : null,
                onSaved: (value) => _treatmentCost = double.parse(value!),
              ),
              SizedBox(height: 16),
              TextFormField(
                initialValue: _affectedCount.toString(),
                decoration: globalInputDecoration.copyWith(labelText: 'Nombre affecté'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer le nombre affecté';
                  } else if (_selectedGroup != null && int.parse(value) > _selectedGroup.totalCount) {
                    return 'Le nombre affecté ne peut pas être supérieur au total ${_selectedGroup.totalCount}';
                  }
                  return null;
                },
                onSaved: (value) => _affectedCount = int.parse(value!),
              ),
              SizedBox(height: 16),
              ListTile(
                title: Text("Date de début: ${_startDate != null ? _startDate!.toLocal().toString().split(' ')[0] : ''}"),
                trailing: Icon(Icons.calendar_today),
                onTap: () => _selectStartDate(context),
              ),
              SizedBox(height: 16),
              ListTile(
                title: Text("Date de fin: ${_endDate != null ? _endDate!.toLocal().toString().split(' ')[0] : ''}"),
                trailing: Icon(Icons.calendar_today),
                onTap: () => _selectEndDate(context),
              ),
              SizedBox(height: 32),
              Center(
                child: ElevatedButton(
                  onPressed: () => _updateIllness(context),
                  child: Text('Mettre à jour la maladie'),
                  style: globalButtonStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}