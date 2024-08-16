import 'package:flutter/material.dart';
import '../../widgets/custom_form_elements.dart';
import '../../widgets/custom_app_bar.dart';
import '../../models/worker.dart';
import '../../services/worker_service.dart';

class AddWorkerScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final WorkerService _workerService = WorkerService();
  String _name = '';
  String _role = '';
  double _salary = 0.0;

  Future<void> _saveWorker(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        Worker newWorker = Worker(
          id: '',
          name: _name,
          role: _role,
          salary: _salary,
          dateOfJoining: DateTime.now(),
          status: 'active',
          updatedAt: DateTime.now(),
        );

        await _workerService.createWorker(newWorker);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Travailleur ajouté avec succès')),
        );

        Navigator.pop(context, true); 
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de l\'ajout du travailleur: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Ajouter un travailleur'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: globalInputDecoration.copyWith(labelText: 'Nom'),
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
              SizedBox(height: 16),
              TextFormField(
                decoration: globalInputDecoration.copyWith(labelText: 'Rôle'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un rôle';
                  }
                  return null;
                },
                onSaved: (value) {
                  _role = value!;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: globalInputDecoration.copyWith(labelText: 'Salaire'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un salaire';
                  }
                  return null;
                },
                onSaved: (value) {
                  _salary = double.parse(value!);
                },
              ),
              SizedBox(height: 32),
              Center(
                child: ElevatedButton(
                  onPressed: () => _saveWorker(context),
                  child: Text('Enregistrer le travailleur'),
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