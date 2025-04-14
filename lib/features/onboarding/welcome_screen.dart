import 'package:flutter/material.dart';
// Importa la pantalla siguiente (la crearemos después)
// import 'select_goals_screen.dart';
// Importa tus colores definidos
import '../../core/theme/colors.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(flex: 2),
              Center(
                child: Image.asset(
                  // ¡¡IMPORTANTE!! Necesitas añadir la imagen y configurar pubspec.yaml
                  'assets/images/logo_onboarding.png',
                  height: 120,
                  semanticLabel: 'Logo de Goals & Triumphs',
                ),
              ),
              const SizedBox(height: 40),
              Text(
                'Consigue todas esas metas que te propusiste a principio de año',
                textAlign: TextAlign.center,
                // Usa estilos del tema si están definidos
                style: textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              Text(
                'En base a conseguir pequeños triunfos para motivarte a lograrlo',
                textAlign: TextAlign.center,
                // Usa estilos del tema
                style: textTheme.titleMedium,
              ),
              const Spacer(flex: 3),
              ElevatedButton(
                // El estilo viene del ElevatedButtonThemeData en app_theme.dart
                onPressed: () {
                  print(
                    'Botón Siguiente presionado - Navegar a SelectGoalsScreen',
                  );
                  // TODO: Añadir navegación a SelectGoalsScreen cuando la creemos
                  // Navigator.of(context).pushReplacement(
                  //   MaterialPageRoute(builder: (_) => const SelectGoalsScreen()),
                  // );
                },
                child: const Text(
                  'Siguiente',
                ), // El estilo del texto también viene del tema
              ),
            ],
          ),
        ),
      ),
    );
  }
}
