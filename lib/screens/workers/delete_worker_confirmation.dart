// lib/screens/workers/worker_detail_screen.dart
import 'package:flutter/material.dart';

class WorkerDetailScreen extends StatelessWidget {
  final ButtonStyle globalButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: Color(0xFF285429),
    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
    textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
    foregroundColor: Colors.white,
  );

  void _deleteWorker(BuildContext context) async {
    final bool? result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return DeleteWorkerConfirmation();
      },
    );

    if (result == true) {
      // Implement deletion logic here
      Navigator.pop(context); // Navigate back after deletion
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map worker = ModalRoute.of(context)!.settings.arguments as Map;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          worker['name'],
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
            Spacer(), // Push buttons to the bottom
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/editWorker',
                      arguments: worker,
                    );
                  },
                  child: Text('Modifier'),
                  style: globalButtonStyle,
                ),
                ElevatedButton(
                  onPressed: () => _deleteWorker(context),
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

// lib/screens/workers/delete_worker_confirmation.dart
// import 'package:flutter/material.dart';

// class DeleteWorkerConfirmation extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final Map worker = ModalRoute.of(context)!.settings.arguments as Map;

//     return AlertDialog(
//       title: Text('Supprimer le travailleur'),
//       content: Text('Êtes-vous sûr de vouloir supprimer ${worker['name']}?'),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.pop(context, false),
//           child: Text('Annuler'),
//         ),
//         TextButton(
//           onPressed: () {
//             // Implement deletion logic here
//             Navigator.pop(context, true); // Return true to indicate deletion
//           },
//           child: Text('Supprimer', style: TextStyle(color: Colors.red)),
//         ),
//       ],
//     );
//   }
// }
