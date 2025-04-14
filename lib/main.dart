import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Importa el provider de onboarding (lo crearemos enseguida)
import 'features/onboarding/onboarding_provider.dart';
// Importa el widget raíz de la app (lo crearemos enseguida)
import 'app_widget.dart';

void main() {
  runApp(
    // Configura los providers globales aquí
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => OnboardingProvider()),
        // Aquí añadirás más providers globales si los necesitas en el futuro
      ],
      child: const AppWidget(), // Llama al widget raíz de tu aplicación
    ),
  );
}
