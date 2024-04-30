import 'package:flutter/material.dart';

abstract class Player {
  Player({
    required this.name,
    required this.start,
    required this.end,
    this.isActive = true,
  });
  final String name;
  final TimeOfDay start;
  final TimeOfDay end;
  final bool isActive;
}
