import 'package:flutter/material.dart';

class CustomCardListTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final Widget? statusIndicator;

  CustomCardListTile({
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.onEdit,
    this.statusIndicator,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 5,
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF285429),
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: Color(0xFF285429),
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit, color: Color(0xFF285429), size: 20),
              onPressed: onEdit,
            ),
            if (statusIndicator != null)
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: statusIndicator,
              ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}