import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // 1. Importa Provider

// 2. Importa tu provider recién creado
import 'features/onboarding/presentation/providers/onboarding_provider.dart';
import 'features/onboarding/presentation/screens/welcome_screen.dart';
// Asegúrate de tener tus otras importaciones necesarias (tema, etc.)

void main() {
  runApp(
    // 3. Envuelve tu App con MultiProvider (recomendado si tendrás más providers)
    MultiProvider(
      providers: [
        // Registra tu OnboardingProvider
        ChangeNotifierProvider(create: (_) => OnboardingProvider()),
        // Puedes añadir otros providers aquí en el futuro:
        // ChangeNotifierProvider(create: (_) => SettingsProvider()),
        // ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const MyApp(), // Tu widget principal que contiene MaterialApp
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Goals & Triumphs',
      theme: ThemeData(
        // TODO: Configura tu tema real aquí
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2E5EAA), // Denim Blue
          secondary: const Color(0xFFFFC107), // Golden Yellow
        ),
        useMaterial3: true,
      ),
      // La pantalla inicial sigue siendo WelcomeScreen
      home: const WelcomeScreen(),
      // Si usas rutas nombradas con Navigator, defínelas aquí.
      // Si usas GoRouter, la configuración del router iría aquí.
    );
  }
}
