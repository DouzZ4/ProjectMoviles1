import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Importa Provider si lo usas aquí

// Importa tu provider si lo necesitas aquí
// import 'notification_settings_provider.dart';
import '../../core/theme/colors.dart'; // Importa colores

// Importa la pantalla principal si la tienes para la navegación final
// import '../dashboard/dashboard_screen.dart';

class NotificationSettingsScreen extends StatelessWidget {
  // Empezamos con StatelessWidget
  const NotificationSettingsScreen({super.key});

  // Lógica del botón Finalizar (puede llamar a un método del provider)
  void _finishOnboarding(BuildContext context) async {
    // Opcional: Llama al provider para guardar la configuración
    // final provider = context.read<NotificationSettingsProvider>();
    // await provider.saveSettings();

    print('Onboarding Finalizado!');
    // TODO: Implementar navegación a la pantalla principal (DashboardScreen)
    // Navigator.of(context).pushAndRemoveUntil(
    //   MaterialPageRoute(builder: (_) => const DashboardScreen()),
    //   (route) => false, // Elimina todas las rutas anteriores (onboarding)
    // );
  }

  @override
  Widget build(BuildContext context) {
    // final settingsProvider = context.watch<NotificationSettingsProvider>(); // Obtén el provider si lo necesitas

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurar Notificaciones'),
        automaticallyImplyLeading:
            false, // No permitir volver atrás en onboarding
      ),
      body: ListView(
        // Usamos ListView para que sea scrollable si hay muchos elementos
        padding: const EdgeInsets.all(16.0),
        children: [
          // Barra de Progreso (Último paso)
          Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: const LinearProgressIndicator(
                value: 1.0, // 100% completado
                minHeight: 10,
                backgroundColor: AppColors.lightGrey,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ),
          ),

          const Text(
            'Personaliza cómo y cuándo quieres recibir recordatorios sobre tus metas.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 24),

          // --- Aquí añadiremos los controles (Switches, ListTiles, etc.) ---
          const Center(child: Text('Controles de Notificación Irán Aquí')),
          const SizedBox(height: 40), // Espacio antes del botón
          // Botón Finalizar
          ElevatedButton(
            onPressed: () => _finishOnboarding(context),
            child: const Text('Finalizar'),
          ),
        ],
      ),
    );
  }
}
