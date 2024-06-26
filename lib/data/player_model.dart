import 'package:flutter/material.dart';
import 'package:playmax_app_1/domain/player.dart';

class PlayerModel extends Player {
  PlayerModel({
    super.idActiveUsers,
    super.createdAt,
    required super.name,
    required super.start,
    required super.end,
    super.isActive,
    required super.cantidad,
    super.colorPulsera,
  });

  factory PlayerModel.fromJson(Map<String, dynamic> json) {
    // Function to convert time string to TimeOfDay
    TimeOfDay parseTime(String time) {
      final hours = int.parse(time.split(":")[0]);
      final minutes = int.parse(time.split(":")[1]);
      return TimeOfDay(hour: hours, minute: minutes);
    }

    return PlayerModel(
      idActiveUsers: json["id_active_users"],
      createdAt: json["created_at"],
      name: json["name"],
      start: parseTime(json["inicio"]),
      end: parseTime(json["fin"]),
      isActive: json["is_active"],
      cantidad: json["cantidad"],
      colorPulsera: json["color_pulsera"],
    );
  }

  Map<String, dynamic> toJson() {
    // Function to convert TimeOfDay to a string format "HH:MM"
    String timeToString(TimeOfDay time) {
      final hours = time.hour.toString().padLeft(2, '0');
      final minutes = time.minute.toString().padLeft(2, '0');
      return "$hours:$minutes";
    }

    return {
      "created_at": createdAt,
      "name": name,
      "inicio": timeToString(start),
      "fin": timeToString(end),
      "is_active": isActive,
      "cantidad": cantidad,
      "color_pulsera": colorPulsera,
    };
  }

  PlayerModel copyWith({
    int? idActiveUsers,
    String? name,
    TimeOfDay? start,
    TimeOfDay? end,
    bool? isActive,
    int? cantidad,
    String? colorPulsera,
  }) {
    return PlayerModel(
      idActiveUsers: idActiveUsers ?? this.idActiveUsers,
      name: name ?? this.name,
      start: start ?? this.start,
      end: end ?? this.end,
      isActive: isActive ?? this.isActive,
      cantidad: cantidad ?? this.cantidad,
      colorPulsera: colorPulsera ?? this.colorPulsera,
    );
  }
}
