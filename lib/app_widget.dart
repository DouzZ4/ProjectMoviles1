import 'package:flutter/material.dart';
// Importa la configuración del tema (la crearemos enseguida)
import 'core/theme/app_theme.dart';
// Importa la primera pantalla a mostrar
import 'features/onboarding/welcome_screen.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Goals & Triumphs',
      debugShowCheckedModeBanner: false, // Opcional: quitar banner de debug
      theme: AppTheme.lightTheme, // Aplica el tema claro (lo definiremos)
      // darkTheme: AppTheme.darkTheme, // Opcional: definir tema oscuro
      // themeMode: ThemeMode.system, // Opcional: elegir tema según sistema
      home: const WelcomeScreen(), // La primera pantalla que verá el usuario
    );
  }
}
