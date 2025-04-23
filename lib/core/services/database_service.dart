import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import '../models/notification_settings.dart'; // <-- Importa el nuevo modelo

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String dbName = 'goals_triumphs.db';
    String path;
    try {
      var documentsDirectory = await getApplicationDocumentsDirectory();
      path = join(documentsDirectory.path, dbName);
    } catch (e) {
      print("Error obteniendo directorio, usando nombre simple: $e");
      path = dbName;
    }
    print("Abriendo DB en ruta/nombre: $path");
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    print("Creando tabla 'settings'...");
    await db.execute('''
      CREATE TABLE settings (
        id INTEGER PRIMARY KEY DEFAULT 1,
        notificationsEnabled INTEGER NOT NULL DEFAULT 1,
        dailyReminderTime TEXT,
        quietHoursEnabled INTEGER NOT NULL DEFAULT 0,
        quietHoursStartTime TEXT,
        quietHoursEndTime TEXT,
        vibrationEnabled INTEGER NOT NULL DEFAULT 1,
        CHECK (id = 1)
      )
    ''');
    print("Tabla 'settings' creada.");
    // Opcional: Insertar la fila por defecto inmediatamente después de crear la tabla
    // await db.insert('settings', NotificationSettings().toMap(), conflictAlgorithm: ConflictAlgorithm.ignore);
    // print("Fila de configuración por defecto insertada (o ignorada si ya existe).");
  }

  // --- NUEVOS MÉTODOS ---

  // Obtener la configuración de la base de datos
  Future<NotificationSettings> getSettings() async {
    final db = await database;
    // Busca la fila con id=1
    final List<Map<String, dynamic>> maps = await db.query(
      'settings',
      where: 'id = ?',
      whereArgs: [NotificationSettings.fixedId], // Usa el ID fijo
    );

    if (maps.isNotEmpty) {
      // Si existe, crea el objeto desde el mapa
      print("Configuración encontrada en DB, cargando...");
      return NotificationSettings.fromMap(maps.first);
    } else {
      // Si no existe (primera vez o error), crea defaults, guárdalos y devuélvelos
      print("Configuración no encontrada en DB, creando/guardando defaults...");
      final defaultSettings = NotificationSettings();
      await saveSettings(defaultSettings); // Llama a save para insertar
      return defaultSettings;
    }
  }

  // Guardar (Insertar o Reemplazar) la configuración
  Future<void> saveSettings(NotificationSettings settings) async {
    final db = await database;
    print("Guardando configuración en DB (ID: ${settings.id})...");
    await db.insert(
      'settings',
      settings.toMap(), // Convierte el objeto a mapa
      // ConflictAlgorithm.replace: Si ya existe una fila con id=1, la reemplaza.
      // Si no existe, la inserta. Perfecto para nuestra fila única.
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print("Configuración guardada.");
  }

  // --- FIN NUEVOS MÉTODOS ---
}
