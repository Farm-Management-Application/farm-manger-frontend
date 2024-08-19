import 'package:flutter/material.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_card_list_tile.dart';
import '../../services/illness_service.dart';
import '../../models/illness.dart';

class IllnessListScreen extends StatefulWidget {
  @override
  _IllnessListScreenState createState() => _IllnessListScreenState();
}

class _IllnessListScreenState extends State<IllnessListScreen> {
  late Future<List<Illness>> _illnessesFuture;

  @override
  void initState() {
    super.initState();
    _fetchIllnesses();
  }

  void _fetchIllnesses() {
    setState(() {
      _illnessesFuture = IllnessService().getAllIllnesses();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Maladies'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<Illness>>(
          future: _illnessesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Erreur lors du chargement des maladies'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('Aucune maladie trouvée'));
            }

            final illnesses = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                children: List.generate(illnesses.length, (index) {
                  final illness = illnesses[index];
                  return CustomCardListTile(
                    title: illness.illnessDescription,
                    subtitle: '${illness.livestockType} - ${illness.affectedCount} affectés',
                    onTap: () async {
                      final result = await Navigator.pushNamed(
                        context,
                        '/illnessDetail',
                        arguments: illness,
                      );

                      if (result == true) {
                        _fetchIllnesses(); // Refresh the list after status change
                      }
                    },
                    onEdit: () async {
                      final result = await Navigator.pushNamed(
                        context,
                        '/editIllness',
                        arguments: illness,
                      );
                      if (result == true) {
                        _fetchIllnesses(); // Refresh the list after editing
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
          final result = await Navigator.pushNamed(context, '/addIllness');
          if (result == true) {
            _fetchIllnesses(); // Refresh the list after adding a new illness
          }
        },
        child: Icon(Icons.add, color: Color(0xFFFAA625)),
        backgroundColor: Color(0xFF285429),
      ),
    );
  }
}