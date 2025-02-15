// lib/screens/edit_group_screen.dart
import 'package:flutter/material.dart';
import '../models/chicken.dart' as chicken;
import '../models/fish.dart' as fish;
import '../models/pig.dart' as pig;
import '../services/chicken_service.dart';
import '../services/fish_service.dart';
import '../services/pig_service.dart';
import '../models/food_consumption.dart';

class EditGroupScreen extends StatefulWidget {
  final dynamic group;
  final String livestockType;

  EditGroupScreen({required this.group, required this.livestockType});

  @override
  _EditGroupScreenState createState() => _EditGroupScreenState();
}

class _EditGroupScreenState extends State<EditGroupScreen> {
  final _formKey = GlobalKey<FormState>();
  final ChickenService _chickenService = ChickenService();
  final FishService _fishService = FishService();
  final PigService _pigService = PigService();

  late String _name;
  late int _totalCount;
  late int _sacks;
  late double _pricePerSack;
  late DateTime _birthDate;
  String _fishType = 'Kanga';  // Default fish type

  @override
  void initState() {
    super.initState();
    _name = widget.livestockType == 'Poulets' ? widget.group.title : widget.group.name;
    _totalCount = widget.group.totalCount;
    _sacks = widget.group.foodConsumption.sacks;
    _pricePerSack = widget.group.foodConsumption.pricePerSack;
    _birthDate = widget.group.birthDate;
    if (widget.livestockType == 'Poissons') {
      _fishType = widget.group.type;
    }
  }
  Future<void> _updateGroup() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        if (widget.livestockType == 'Poulets') {
          chicken.Chicken updatedGroup = chicken.Chicken(
            id: widget.group.id,
            title: _name,
            totalCount: _totalCount,
            foodConsumption: FoodConsumption(sacks: _sacks, pricePerSack: _pricePerSack),
            birthDate: _birthDate,
            createdAt: widget.group.createdAt,
            modifiedAt: DateTime.now(),
          );
          await _chickenService.updateChickenGroup(widget.group.id, updatedGroup);
        } else if (widget.livestockType == 'Poissons') {
          fish.Fish updatedGroup = fish.Fish(
            id: widget.group.id,
            name: _name,
            totalCount: _totalCount,
            type: _fishType,
            foodConsumption: FoodConsumption(sacks: _sacks, pricePerSack: _pricePerSack),
            birthDate: _birthDate,
            createdAt: widget.group.createdAt,
            modifiedAt: DateTime.now(),
          );
          await _fishService.updateFishGroup(widget.group.id, updatedGroup);
        } else if (widget.livestockType == 'Porcs') {
          pig.Pig updatedGroup = pig.Pig(
            id: widget.group.id,
            name: _name,
            totalCount: _totalCount,
            type: '',  // Type will be determined on the backend
            foodConsumption: FoodConsumption(sacks: _sacks, pricePerSack: _pricePerSack),
            birthDate: _birthDate,
            createdAt: widget.group.createdAt,
            modifiedAt: DateTime.now(),
          );
          await _pigService.updatePigGroup(widget.group.id, updatedGroup);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Groupe mis à jour avec succès')),
        );

        Navigator.pop(context, true);
      } catch (e) {
        print('Erreur lors de la mise à jour du groupe: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de la mise à jour du groupe: $e')),
        );
      }
    }
  }
  Future<void> _selectBirthDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _birthDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _birthDate) {
      setState(() {
        _birthDate = picked;
        print('Date de naissance sélectionnée: $_birthDate'); // Debug statement
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Modifier le groupe de ${widget.livestockType}',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFF285429),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18.0),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.disabled,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInputField(
                initialValue: _name,
                label: 'Nom',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un nom';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value!;
                },
              ),
              SizedBox(height: 20),
              _buildInputField(
                initialValue: _totalCount.toString(),
                label: 'Nombre total',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un nombre total';
                  }
                  return null;
                },
                onSaved: (value) {
                  _totalCount = int.parse(value!);
                },
              ),
              SizedBox(height: 20),
              if (widget.livestockType == 'Poissons')
                _buildDropdownField(
                  label: 'Type de poisson',
                  value: _fishType,
                  items: ['Kanga', 'Cellule'],
                  onChanged: (String? newValue) {
                    setState(() {
                      _fishType = newValue!;
                    });
                  },
                ),
              SizedBox(height: 20),
              _buildInputField(
                initialValue: _sacks.toString(),
                label: 'Sacs',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer le nombre de sacs';
                  }
                  return null;
                },
                onSaved: (value) {
                  _sacks = int.parse(value!);
                },
              ),
              SizedBox(height: 20),
              _buildInputField(
                initialValue: _pricePerSack.toString(),
                label: 'Prix par sac',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer le prix par sac';
                  }
                  return null;
                },
                onSaved: (value) {
                  _pricePerSack = double.parse(value!);
                },
              ),
              SizedBox(height: 20),
              ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 0),
                title: Row(
                  children: [
                    Text(
                      "Date de naissance: ",
                      style: TextStyle(color: Color(0xFF285429)),
                    ),
                    Text(
                      "${_birthDate.toLocal()}".split(' ')[0],
                      style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF285429)),
                    ),
                  ],
                ),
                trailing: Icon(Icons.calendar_today, color: Color(0xFF285429)),
                onTap: () => _selectBirthDate(context),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _updateGroup,
                  child: Text('Mettre à jour le groupe'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF285429),
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String initialValue,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    required FormFieldValidator<String> validator,
    required FormFieldSetter<String> onSaved,
  }) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Color(0xFF285429)),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF285429)),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF285429)),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      keyboardType: keyboardType,
      validator: validator,
      onSaved: onSaved,
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Color(0xFF285429)),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF285429)),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF285429)),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      items: items.map((String type) {
        return DropdownMenuItem<String>(
          value: type,
          child: Text(type),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}