import 'package:flutter/material.dart';

class GlobalDeleteConfirmation extends StatelessWidget {
  final String title;
  final String content;
  final String confirmtxt;
  final VoidCallback onConfirm;

  GlobalDeleteConfirmation({
    required this.title,
    required this.content,
    required this.confirmtxt,  // Corrected the semicolon to a comma
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text('Annuler'),
        ),
        TextButton(
          onPressed: () {
            onConfirm();
            Navigator.pop(context, true);
          },
          child: Text(confirmtxt, style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }
}