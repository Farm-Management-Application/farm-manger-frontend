import 'package:flutter/material.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_form_elements.dart';
import '../../models/worker.dart';
import '../../services/worker_service.dart';

class EditWorkerScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _role;
  late double _salaire;

  @override
  Widget build(BuildContext context) {
    final Map worker = ModalRoute.of(context)!.settings.arguments as Map;
    _name = worker['name'];
    _role = worker['role'];
    _salaire = worker['salary'].toDouble();

    void _saveWorker(BuildContext context) async {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();

        Worker updatedWorker = Worker(
          id: worker['id'],
          name: _name,
          role: _role,
          salary: _salaire,
          dateOfJoining: DateTime.parse(worker['date_of_joining']),
          status: worker['status'],
          updatedAt: DateTime.now(),
        );

        try {
          await WorkerService().updateWorker(updatedWorker.id, updatedWorker);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Les modifications ont été enregistrées avec succès.')),
          );
          Navigator.pop(context, true); // Close the popup and return to the previous screen
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erreur lors de l\'enregistrement des modifications: $e')),
          );
        }
      }
    }

    return Scaffold(
      appBar: CustomAppBar(title: 'Modifier le travailleur'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                initialValue: _name,
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
                initialValue: _role,
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
                initialValue: _salaire.toString(),
                decoration: globalInputDecoration.copyWith(labelText: 'Salaire'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un salaire';
                  }
                  return null;
                },
                onSaved: (value) {
                  _salaire = double.parse(value!);
                },
              ),
              SizedBox(height: 32),
              Center(
                child: ElevatedButton(
                  onPressed: () => _saveWorker(context),
                  child: Text('Enregistrer les modifications'),
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