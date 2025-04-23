import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // Para kDebugMode
// Importa el NUEVO modelo y el servicio
import '../../core/models/notification_settings.dart';
import '../../core/services/database_service.dart';

class NotificationSettingsProvider with ChangeNotifier {
  // --- Dependencias ---
  // Usa el servicio de base de datos sqflite
  final DatabaseService _dbService = DatabaseService();

  // --- Estado Interno ---
  bool _isLoading = true; // Mantenemos estado de carga inicial
  NotificationSettings _currentSettings =
      NotificationSettings(); // Guarda el objeto completo

  // --- Getters Públicos (Ahora leen desde _currentSettings) ---
  bool get isLoading => _isLoading;
  bool get notificationsEnabled => _currentSettings.notificationsEnabled;
  TimeOfDay? get dailyReminderTime => _currentSettings.dailyReminderTime;
  bool get quietHoursEnabled => _currentSettings.quietHoursEnabled;
  TimeOfDay? get quietHoursStartTime => _currentSettings.quietHoursStartTime;
  TimeOfDay? get quietHoursEndTime => _currentSettings.quietHoursEndTime;
  bool get vibrationEnabled => _currentSettings.vibrationEnabled;

  // --- Inicialización ---
  NotificationSettingsProvider() {
    _loadSettings(); // Carga al iniciar
  }

  // Carga la configuración usando el servicio sqflite
  Future<void> _loadSettings() async {
    if (kDebugMode) print("Provider: Iniciando carga desde DatabaseService...");
    _isLoading = true;
    notifyListeners(); // Notifica que está cargando

    try {
      _currentSettings =
          await _dbService.getSettings(); // Llama al servicio sqflite
      if (kDebugMode)
        print(
          "Provider: Configuración cargada desde DB (ID: ${_currentSettings.id})",
        );
    } catch (e) {
      if (kDebugMode) print("Provider: Error cargando configuración: $e");
      // Mantiene los defaults si hay error
      _currentSettings = NotificationSettings();
    } finally {
      _isLoading = false;
      notifyListeners(); // Notifica que terminó la carga (con datos o defaults)
      if (kDebugMode) print("Provider: Carga finalizada, notificando UI.");
      // debugPrintState(); // Llama al debug si lo tienes
    }
  }

  // --- Métodos Update (Actualizan estado interno Y llaman a guardar) ---

  void updateNotificationsEnabled(bool value) {
    if (_currentSettings.notificationsEnabled != value) {
      _currentSettings.notificationsEnabled = value;
      notifyListeners();
      _saveCurrentSettings(); // Llama al guardado
    }
  }

  void updateDailyReminderTime(TimeOfDay? newTime) {
    if (_currentSettings.dailyReminderTime != newTime) {
      _currentSettings.dailyReminderTime = newTime;
      notifyListeners();
      _saveCurrentSettings();
    }
  }

  void updateQuietHoursEnabled(bool value) {
    if (_currentSettings.quietHoursEnabled != value) {
      _currentSettings.quietHoursEnabled = value;
      notifyListeners();
      _saveCurrentSettings();
    }
  }

  void updateQuietHoursStartTime(TimeOfDay? newTime) {
    if (_currentSettings.quietHoursStartTime != newTime) {
      _currentSettings.quietHoursStartTime = newTime;
      notifyListeners();
      _saveCurrentSettings();
    }
  }

  void updateQuietHoursEndTime(TimeOfDay? newTime) {
    if (_currentSettings.quietHoursEndTime != newTime) {
      _currentSettings.quietHoursEndTime = newTime;
      notifyListeners();
      _saveCurrentSettings();
    }
  }

  void updateVibrationEnabled(bool value) {
    if (_currentSettings.vibrationEnabled != value) {
      _currentSettings.vibrationEnabled = value;
      notifyListeners();
      _saveCurrentSettings();
    }
  }

  // Guarda el estado ACTUAL (_currentSettings) usando el servicio sqflite
  Future<void> _saveCurrentSettings() async {
    if (_isLoading) return; // Evita guardar si aún está cargando
    if (kDebugMode) print("Provider: Guardando configuración actual en DB...");
    try {
      // Pasa el objeto _currentSettings completo al servicio
      await _dbService.saveSettings(_currentSettings);
      if (kDebugMode) print("Provider: Guardado exitoso.");
    } catch (e) {
      if (kDebugMode) print("Provider: Error guardando configuración: $e");
    }
  }

  // Método público llamado por el botón "Finalizar"
  Future<void> saveSettings() async {
    // Asegura que el último estado se guarde
    await _saveCurrentSettings();
  }

  // (Opcional) Método de depuración actualizado
  void debugPrintState() {
    print("--- Estado actual del NotificationSettingsProvider (sqflite) ---");
    print("isLoading: $_isLoading");
    print("Datos actuales: ${_currentSettings.toMap()}"); // Muestra el mapa
    print("-----------------------------------------------");
  }
}
