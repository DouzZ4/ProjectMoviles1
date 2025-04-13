import 'package:flutter/material.dart';
// 1. Importa la pantalla de selección de metas que acabamos de crear
import 'select_goals_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  static const String routeName = '/welcome';

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    const Color goldenYellow = Color(0xFFFFC107);
    const Color charcoalGray = Color(0xFF36454F);

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
                  'assets/images/logo_onboarding.png', // Asegúrate que la ruta es correcta
                  height: 120,
                ),
              ),
              const SizedBox(height: 40),
              Text(
                'Consigue todas esas metas que te propusiste a principio de año',
                textAlign: TextAlign.center,
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'En base a conseguir pequeños triunfos para motivarte a lograrlo',
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
              ),
              const Spacer(flex: 3),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: goldenYellow,
                  foregroundColor: charcoalGray,
                  minimumSize: const Size(double.infinity, 50),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
                onPressed: () {
                  // --- Acción de Navegación Actualizada ---
                  print(
                    'Botón Siguiente presionado - Navegando a SelectGoalsScreen',
                  );

                  // 2. Usamos pushReplacement para reemplazar la pantalla actual
                  //    en la pila de navegación. Esto evita que el usuario
                  //    pueda volver a WelcomeScreen presionando "Atrás".
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (_) => const SelectGoalsScreen(),
                    ),
                  );
                },
                child: const Text(
                  'Siguiente',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
