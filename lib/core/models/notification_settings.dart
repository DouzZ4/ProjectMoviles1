// lib/core/models/notification_settings.dart
import 'package:flutter/material.dart'; // Necesario para TimeOfDay

class NotificationSettings {
  // Usaremos un ID fijo para la fila única de configuración en la tabla
  static const int fixedId = 1;

  final int id; // Aunque es fijo, lo incluimos por consistencia
  bool notificationsEnabled;
  TimeOfDay? dailyReminderTime;
  bool quietHoursEnabled;
  TimeOfDay? quietHoursStartTime;
  TimeOfDay? quietHoursEndTime;
  bool vibrationEnabled;

  // Constructor con valores por defecto
  NotificationSettings({
    this.id = fixedId, // Siempre será 1
    this.notificationsEnabled = true,
    this.dailyReminderTime = const TimeOfDay(hour: 9, minute: 0),
    this.quietHoursEnabled = false,
    this.quietHoursStartTime = const TimeOfDay(hour: 22, minute: 0),
    this.quietHoursEndTime = const TimeOfDay(hour: 7, minute: 0),
    this.vibrationEnabled = true,
  });

  // Helper para formatear TimeOfDay a "HH:MM" (24h) para guardar en DB
  String? _formatTimeOfDay(TimeOfDay? time) {
    if (time == null) return null;
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  // Helper para parsear "HH:MM" de la DB a TimeOfDay
  static TimeOfDay? _parseTimeOfDay(String? timeString) {
    if (timeString == null || !timeString.contains(':')) return null;
    try {
      final parts = timeString.split(':');
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);
      return TimeOfDay(hour: hour, minute: minute);
    } catch (e) {
      print("Error parseando TimeOfDay desde '$timeString': $e");
      return null;
    }
  }

  // Método para convertir el objeto a un Map para sqflite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      // Convertir booleanos a enteros (1 para true, 0 para false)
      'notificationsEnabled': notificationsEnabled ? 1 : 0,
      // Convertir TimeOfDay a String "HH:MM"
      'dailyReminderTime': _formatTimeOfDay(dailyReminderTime),
      'quietHoursEnabled': quietHoursEnabled ? 1 : 0,
      'quietHoursStartTime': _formatTimeOfDay(quietHoursStartTime),
      'quietHoursEndTime': _formatTimeOfDay(quietHoursEndTime),
      'vibrationEnabled': vibrationEnabled ? 1 : 0,
    };
  }

  // Factory constructor para crear un objeto desde un Map de sqflite
  factory NotificationSettings.fromMap(Map<String, dynamic> map) {
    return NotificationSettings(
      id: map['id'] ?? fixedId, // Usar ID del mapa o el fijo
      // Convertir enteros a booleanos (1 == true)
      notificationsEnabled: map['notificationsEnabled'] == 1,
      // Convertir String "HH:MM" a TimeOfDay
      dailyReminderTime: _parseTimeOfDay(map['dailyReminderTime']),
      quietHoursEnabled: map['quietHoursEnabled'] == 1,
      quietHoursStartTime: _parseTimeOfDay(map['quietHoursStartTime']),
      quietHoursEndTime: _parseTimeOfDay(map['quietHoursEndTime']),
      vibrationEnabled: map['vibrationEnabled'] == 1,
    );
  }
}
