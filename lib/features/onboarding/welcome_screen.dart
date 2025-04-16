import 'package:flutter/material.dart';
// 1. Importa la pantalla de selección de metas
import 'select_goals_screen.dart';
import '../../core/theme/colors.dart'; // Si usas AppColors directamente

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
                  'assets/images/logo_onboarding.png',
                  height: 120,
                  semanticLabel: 'Logo de Goals & Triumphs',
                ),
              ),
              const SizedBox(height: 40),
              Text(
                'Consigue todas esas metas que te propusiste a principio de año',
                textAlign: TextAlign.center,
                style: textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              Text(
                'En base a conseguir pequeños triunfos para motivarte a lograrlo',
                textAlign: TextAlign.center,
                style: textTheme.titleMedium,
              ),
              const Spacer(flex: 3),
              ElevatedButton(
                onPressed: () {
                  print(
                    'Botón Siguiente presionado - Navegando a SelectGoalsScreen',
                  );
                  // 2. Navegación implementada
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (_) => const SelectGoalsScreen(),
                    ),
                  );
                },
                child: const Text('Siguiente'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
