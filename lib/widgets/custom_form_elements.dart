import 'package:flutter/material.dart';

// Global TextField Decoration
final InputDecoration globalInputDecoration = InputDecoration(
  labelStyle: TextStyle(color: Color(0xFF285429)),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xFF285429)),
    borderRadius: BorderRadius.circular(10),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xFF285429)),
    borderRadius: BorderRadius.circular(10),
  ),
);

// Global ElevatedButton Style
final ButtonStyle globalButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: Color(0xFF285429),
  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
  textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
  foregroundColor: Colors.white,
);