import 'dart:async';

import 'package:flutter/material.dart';

abstract class Player {
  Player({
    this.idActiveUsers,
    this.createdAt,
    required this.name,
    required this.start,
    required this.end,
    this.isActive = true,
    this.timer,
  });
  final int? idActiveUsers;
  final String? createdAt;
  final String name;
  final TimeOfDay start;
  final TimeOfDay end;
  final bool isActive;
  Timer? timer;

  void disposeTimer() {
    timer?.cancel();
  }
}
