import 'package:flutter/material.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_form_elements.dart';
import '../../widgets/custom_delete_confirmation.dart';
import '../../services/illness_service.dart';
import '../../services/chicken_service.dart';
import '../../services/fish_service.dart';
import '../../services/pig_service.dart';
import '../../models/illness.dart';

class IllnessDetailScreen extends StatefulWidget {
  final Illness illness;

  IllnessDetailScreen({required this.illness});

  @override
  _IllnessDetailScreenState createState() => _IllnessDetailScreenState();
}

class _IllnessDetailScreenState extends State<IllnessDetailScreen> {
  late String _livestockType;
  dynamic _selectedGroup;
  List<dynamic> _livestockGroups = [];

  @override
  void initState() {
    super.initState();
    _livestockType = widget.illness.livestockType;

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


  void _deleteIllness(BuildContext context, String illnessId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return GlobalDeleteConfirmation(
          title: 'Supprimer la maladie',
          content: 'Êtes-vous sûr de vouloir supprimer cet élément?',
          confirmtxt: 'Supprimer',
          onConfirm: () async {
            try {
              await IllnessService().deleteIllness(illnessId);

              Navigator.pop(context, true); // Go back to the previous screen

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Maladie supprimée avec succès.')),
              );
            } catch (e) {
              Navigator.pop(context); // Close the confirmation dialog
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Erreur lors de la suppression de la maladie: $e')),
              );
            }
          },
        );
      },
    );
  }

  void _modifyIllness(BuildContext context, Illness illness) async {
    final result = await Navigator.pushNamed(
      context,
      '/editIllness',
      arguments: illness,
    );

    if (result == true) {
      Navigator.pop(context, true); // Go back and refresh the previous screen
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Detail de la maladie"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _selectedGroup == null
            ? Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Maladie: ${widget.illness.illnessDescription}',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF285429),
                    ),
                  ),
                  SizedBox(height: 20),
                  Divider(),
                  ListTile(
                    title: Text('Type de bétail', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF285429))),
                    subtitle: Text(widget.illness.livestockType, style: TextStyle(fontSize: 18)),
                  ),
                  Divider(),
                  ListTile(
                    title: Text('Groupe', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF285429))),
                    subtitle: Text(_selectedGroup.name, style: TextStyle(fontSize: 18)),
                  ),
                  Divider(),
                  ListTile(
                    title: Text('Coût du traitement', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF285429))),
                    subtitle: Text('${widget.illness.treatmentCost} FCFA', style: TextStyle(fontSize: 18)),
                  ),
                  Divider(),
                  ListTile(
                    title: Text('Nombre affecté', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF285429))),
                    subtitle: Text('${widget.illness.affectedCount} sur ${_selectedGroup.totalCount}', style: TextStyle(fontSize: 18)),
                  ),
                  Divider(),
                  ListTile(
                    title: Text('Date de début', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF285429))),
                    subtitle: Text('${widget.illness.startDate.toLocal().toIso8601String().split('T')[0]}', style: TextStyle(fontSize: 18)),
                  ),
                  Divider(),
                  ListTile(
                    title: Text('Date de fin', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF285429))),
                    subtitle: Text('${widget.illness.endDate?.toLocal().toIso8601String().split('T')[0] ?? 'N/A'}', style: TextStyle(fontSize: 18)),
                  ),
                  Spacer(), // Push buttons to the bottom
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () => _modifyIllness(context, widget.illness),
                        child: Text('Modifier'),
                        style: globalButtonStyle,
                      ),
                      ElevatedButton(
                        onPressed: () => _deleteIllness(context, widget.illness.id),
                        child: Text('Supprimer'),
                        style: globalButtonStyle,
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}