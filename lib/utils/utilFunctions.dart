// lib/utils.dart
import 'package:flutter/material.dart';

// lib/utils.dart
String calculateAge(DateTime birthDate) {
  final now = DateTime.now();
  final difference = now.difference(birthDate).inDays;

  if (difference < 7) {
    return '$difference jours';
  } else if (difference < 30) {
    final weeks = (difference / 7).floor();
    return '$weeks semaines';
  } else {
    final months = (difference / 30).floor();
    return '$months mois';
  }
}