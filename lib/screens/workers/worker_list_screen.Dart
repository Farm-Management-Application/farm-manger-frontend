import 'package:flutter/material.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_card_list_tile.dart';
import '../../services/worker_service.dart';
import '../../models/worker.dart';

class WorkerListScreen extends StatefulWidget {
  @override
  _WorkerListScreenState createState() => _WorkerListScreenState();
}

class _WorkerListScreenState extends State<WorkerListScreen> {
  late Future<List<Worker>> _workersFuture;

  @override
  void initState() {
    super.initState();
    _fetchWorkers();
  }

  void _fetchWorkers() {
    setState(() {
      _workersFuture = WorkerService().getAllWorkers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Travailleurs'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<Worker>>(
          future: _workersFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Erreur lors du chargement des travailleurs'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('Aucun travailleur trouvé'));
            }

            final workers = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                children: List.generate(workers.length, (index) {
                  final worker = workers[index];
                  return CustomCardListTile(
                    title: worker.name,
                    subtitle: worker.role,
                    statusIndicator: CircleAvatar(
                      backgroundColor: worker.status == 'active' ? Colors.green : Colors.red,
                      radius: 8,
                    ),
                    onTap: () async {
                      final result = await Navigator.pushNamed(
                        context,
                        '/workerDetail',
                        arguments: {
                          'id': worker.id,
                          'name': worker.name,
                          'role': worker.role,
                          'salary': worker.salary,
                          'date_of_joining': worker.dateOfJoining.toIso8601String(),
                          'status': worker.status,
                          'updatedAt': worker.updatedAt.toIso8601String(),
                        },
                      );

                      if (result == true) {
                        _fetchWorkers(); // Refresh the list after status change
                      }
                    },
                    onEdit: () async {
                      final result = await Navigator.pushNamed(
                        context,
                        '/editWorker',
                        arguments: {
                          'id': worker.id,
                          'name': worker.name,
                          'role': worker.role,
                          'salary': worker.salary,
                          'date_of_joining': worker.dateOfJoining.toIso8601String(),
                          'status': worker.status,
                          'updatedAt': worker.updatedAt.toIso8601String(),
                        },
                      );
                      if (result == true) {
                        _fetchWorkers(); // Refresh the list after editing
                      }
                    },
                  );
                }),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.pushNamed(context, '/addWorker');
          if (result == true) {
            _fetchWorkers(); // Refresh the list after adding a new worker
          }
        },
        child: Icon(Icons.add, color: Color(0xFFFAA625)),
        backgroundColor: Color(0xFF285429),
      ),
    );
  }
}