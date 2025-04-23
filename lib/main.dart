import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart'; // Para kIsWeb
import 'package:sqflite/sqflite.dart'; // Importa sqflite
// Importa el paquete FFI Web SOLO si NO es kIsWeb, o usa conditional import
// La forma más segura es configurar la factory condicionalmente
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart'; // Para Web Factory

// Importa tu servicio de base de datos
import 'core/services/database_service.dart';
// Importa tus providers y AppWidget...
import 'features/onboarding/onboarding_provider.dart';
import 'features/notifications/notification_settings_provider.dart';
import 'app_widget.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // --- Configuración específica de sqflite para WEB ---
  if (kIsWeb) {
    // Cambia la fábrica de base de datos por defecto a la versión FFI Web
    databaseFactory = databaseFactoryFfiWeb;
    print(
      "Factory de Base de Datos configurada para Web (sqflite_common_ffi_web)",
    );
  }
  // --- Fin Configuración Web ---

  // Llama al getter para inicializar la base de datos ANTES de runApp
  // Esto asegura que la tabla se cree si es necesario.
  // El resultado no se usa aquí, solo se llama para activar la inicialización.
  try {
    await DatabaseService().database; // Llama al getter para inicializar
    print("Inicialización de DatabaseService completada (o DB ya abierta).");
  } catch (e) {
    print("Error durante la inicialización de DatabaseService: $e");
    // Decide cómo manejar un error crítico de DB aquí
  }

  // Configura providers y ejecuta la app
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => OnboardingProvider()),
        ChangeNotifierProvider(create: (_) => NotificationSettingsProvider()),
        // Si necesitas acceso al DatabaseService en otros providers o widgets,
        // podrías proporcionarlo aquí también:
        // Provider(create: (_) => DatabaseService()),
      ],
      child: const AppWidget(),
    ),
  );
}
