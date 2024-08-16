import 'package:flutter/material.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_form_elements.dart';
import '../../widgets/custom_delete_confirmation.dart';
import '../../services/worker_service.dart';
import '../../models/worker.dart';

class WorkerDetailScreen extends StatelessWidget {
  void _toggleWorkerStatus(BuildContext context, String workerId, String currentStatus) {
    String newStatus = currentStatus == 'active' ? 'inactive' : 'active';
    String action = currentStatus == 'active' ? 'Désactiver' : 'Activer';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return GlobalDeleteConfirmation(
          title: '$action le travailleur',
          content: 'Êtes-vous sûr de vouloir $action cet élément?',
          confirmtxt: action,
          onConfirm: () async {
            try {
              if (newStatus == 'inactive') {
                await WorkerService().deactivateWorker(workerId);
              } else {
                await WorkerService().activateWorker(workerId);
              }

              // Navigator.pop(context, true); // Return true to indicate success
              Navigator.pop(context, true); // Go back to the previous screen

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Travailleur ${newStatus == "active" ? "activé" : "désactivé"} avec succès.')),
              );
            } catch (e) {
              Navigator.pop(context); // Close the confirmation dialog
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Erreur lors de la modification du statut: $e')),
              );
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Map worker = ModalRoute.of(context)!.settings.arguments as Map;
    String status = worker['status'];

    return Scaffold(
      appBar: CustomAppBar(title: worker['name']),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nom: ${worker['name']}',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF285429),
              ),
            ),
            SizedBox(height: 20),
            Divider(),
            ListTile(
              title: Text('Rôle', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF285429))),
              subtitle: Text(worker['role'], style: TextStyle(fontSize: 18)),
            ),
            Divider(),
            ListTile(
              title: Text('Salaire', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF285429))),
              subtitle: Text('${worker['salary']} FCFA', style: TextStyle(fontSize: 18)),
            ),
            Divider(),
            ListTile(
              title: Text('Date d\'adhésion', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF285429))),
              subtitle: Text('${DateTime.parse(worker['date_of_joining']).toLocal().toIso8601String().split('T')[0]}', style: TextStyle(fontSize: 18)),
            ),
            Divider(),
            ListTile(
              title: Text('Statut', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF285429))),
              subtitle: Text(status, style: TextStyle(fontSize: 18)),
            ),
            Spacer(), // Push buttons to the bottom
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _toggleWorkerStatus(context, worker['id'], status),
                  child: Text(status == 'active' ? 'Désactiver' : 'Activer'),
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