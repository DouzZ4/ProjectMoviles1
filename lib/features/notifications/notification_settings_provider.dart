import 'package:flutter/material.dart';

class NotificationSettingsProvider with ChangeNotifier {
  // --- Estado Privado ---

  // Estado inicial de las notificaciones (ej: activadas por defecto)
  bool _notificationsEnabled = true;
  // Hora por defecto para recordatorio (ej: 9:00 AM)
  TimeOfDay? _dailyReminderTime = const TimeOfDay(hour: 9, minute: 0);
  // Horas de silencio desactivadas por defecto
  bool _quietHoursEnabled = false;
  // Horas de silencio por defecto (ej: 10 PM a 7 AM)
  TimeOfDay? _quietHoursStartTime = const TimeOfDay(hour: 22, minute: 0);
  TimeOfDay? _quietHoursEndTime = const TimeOfDay(hour: 7, minute: 0);
  // Vibración activada por defecto
  bool _vibrationEnabled = true;

  // --- Getters Públicos ---

  bool get notificationsEnabled => _notificationsEnabled;
  TimeOfDay? get dailyReminderTime => _dailyReminderTime;
  bool get quietHoursEnabled => _quietHoursEnabled;
  TimeOfDay? get quietHoursStartTime => _quietHoursStartTime;
  TimeOfDay? get quietHoursEndTime => _quietHoursEndTime;
  bool get vibrationEnabled => _vibrationEnabled;

  // --- Métodos Públicos para Actualizar Estado ---

  void updateNotificationsEnabled(bool value) {
    if (_notificationsEnabled != value) {
      _notificationsEnabled = value;
      notifyListeners();
    }
  }

  void updateDailyReminderTime(TimeOfDay? newTime) {
    // TimeOfDay es inmutable, así que la comparación directa funciona
    if (_dailyReminderTime != newTime) {
      _dailyReminderTime = newTime;
      notifyListeners();
    }
  }

  void updateQuietHoursEnabled(bool value) {
    if (_quietHoursEnabled != value) {
      _quietHoursEnabled = value;
      notifyListeners();
    }
  }

  void updateQuietHoursStartTime(TimeOfDay? newTime) {
    if (_quietHoursStartTime != newTime) {
      _quietHoursStartTime = newTime;
      // Podrías añadir lógica para asegurar que start sea antes que end
      notifyListeners();
    }
  }

  void updateQuietHoursEndTime(TimeOfDay? newTime) {
    if (_quietHoursEndTime != newTime) {
      _quietHoursEndTime = newTime;
      // Podrías añadir lógica para asegurar que end sea después que start
      notifyListeners();
    }
  }

  void updateVibrationEnabled(bool value) {
    if (_vibrationEnabled != value) {
      _vibrationEnabled = value;
      notifyListeners();
    }
  }

  // --- Método para Guardar (Placeholder) ---
  Future<void> saveSettings() async {
    // TODO: Implementar la lógica para guardar estas preferencias
    // usando SharedPreferences, una base de datos local, o un backend.
    print('Guardando configuración de notificaciones:');
    print('- Enabled: $_notificationsEnabled');
    print('- Reminder Time: $_dailyReminderTime');
    print('- Quiet Hours Enabled: $_quietHoursEnabled');
    print('- Quiet Hours Start: $_quietHoursStartTime');
    print('- Quiet Hours End: $_quietHoursEndTime');
    print('- Vibration Enabled: $_vibrationEnabled');
    // Simula un pequeño retraso como si se estuviera guardando
    await Future.delayed(const Duration(milliseconds: 300));
  }
}
