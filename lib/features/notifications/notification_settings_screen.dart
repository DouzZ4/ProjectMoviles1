import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // 1. Importa Provider
import 'notification_settings_provider.dart'; // 2. Importa el Provider de Notificaciones
import '../../core/theme/colors.dart'; // Importa colores
import 'package:flutter/foundation.dart'; // Para kDebugMode

// Importa la pantalla principal si la tienes para la navegación final
// import '../dashboard/dashboard_screen.dart';

class NotificationSettingsScreen extends StatelessWidget {
  const NotificationSettingsScreen({super.key});

  void _finishOnboarding(BuildContext context) async {
    // Llama al provider para guardar antes de salir (si quieres)
    final provider = context.read<NotificationSettingsProvider>();
    await provider.saveSettings(); // Llama al método save

    if (kDebugMode) {
      print('Onboarding Finalizado! Navegando a la app principal...');
    }

    // TODO: Implementar navegación REAL a la pantalla principal (DashboardScreen)
    if (!context.mounted) return; // Buena práctica: comprobar antes de navegar
    // Navigator.of(context).pushAndRemoveUntil(
    //   MaterialPageRoute(builder: (_) => const DashboardScreen()),
    //   (route) => false, // Elimina todas las rutas anteriores (onboarding)
    // );
  }

  @override
  Widget build(BuildContext context) {
    // 3. Obtén la instancia del provider y escucha cambios (`watch`)
    final settingsProvider = context.watch<NotificationSettingsProvider>();
    final textTheme = Theme.of(context).textTheme; // Para estilos de texto

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurar Notificaciones'),
        automaticallyImplyLeading: false, // No botón de atrás
      ),
      body: ListView(
        // Permite scroll si el contenido crece
        padding: const EdgeInsets.symmetric(
          vertical: 24.0,
          horizontal: 16.0,
        ), // Ajusta padding
        children: [
          // Barra de Progreso (Último paso)
          Padding(
            padding: const EdgeInsets.only(bottom: 32.0), // Más espacio abajo
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: const LinearProgressIndicator(
                value: 1.0, // 100%
                minHeight: 10,
                backgroundColor: AppColors.lightGrey,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ),
          ),

          // Texto introductorio (ajustado estilo)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Personaliza cómo y cuándo quieres recibir recordatorios sobre tus metas.',
              textAlign: TextAlign.center,
              style: textTheme.titleMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(height: 32), // Más espacio
          // --- 4. Interruptor General ---
          Card(
            // Envuelve en una Card para darle un fondo y borde sutil (opcional)
            elevation: 0.5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: SwitchListTile(
              title: Text(
                'Activar Notificaciones',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ), // Ajusta estilo
              ),
              subtitle: Text(
                // El subtítulo cambia según el estado
                settingsProvider.notificationsEnabled
                    ? 'Recibirás recordatorios y alertas.'
                    : 'No recibirás ninguna notificación.',
                style: textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              // 5. Vincula el valor al estado del provider
              value: settingsProvider.notificationsEnabled,
              // 6. Llama al método del provider cuando cambia el valor
              onChanged: (bool newValue) {
                // Usa 'read' dentro de callbacks
                context
                    .read<NotificationSettingsProvider>()
                    .updateNotificationsEnabled(newValue);
              },
              // Estilos visuales (opcional, usa el tema por defecto o personaliza)
              activeColor: AppColors.white, // Color del círculo del switch
              activeTrackColor:
                  AppColors.primary, // Color de la pista encendida
              inactiveThumbColor: AppColors.white,
              inactiveTrackColor: AppColors.mediumGrey.withOpacity(0.5),
              // Icono que también cambia (opcional)
              secondary: Icon(
                settingsProvider.notificationsEnabled
                    ? Icons
                        .notifications_active // Icono activo
                    : Icons.notifications_off_outlined, // Icono inactivo
                color:
                    settingsProvider.notificationsEnabled
                        ? AppColors.primary
                        : AppColors.mediumGrey,
                size: 28, // Tamaño del icono
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ), // Padding interno
            ),
          ),

          const Divider(
            height: 40,
            indent: 16,
            endIndent: 16,
          ), // Separador visual
          // --- Aquí añadiremos los otros controles ---
          // Mostraremos las otras opciones solo si las notificaciones están habilitadas
          if (settingsProvider.notificationsEnabled) ...[
            const Center(
              child: Text(
                'Configuración adicional aparecerá aquí...',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
            // TODO: Añadir selector de hora, horas de silencio, vibración
          ] else ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Activa las notificaciones para configurar recordatorios y otras opciones.',
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],

          const SizedBox(height: 40), // Espacio antes del botón final
          // Botón Finalizar
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
            ), // Padding para el botón
            child: ElevatedButton(
              // El estilo general viene del tema
              onPressed: () => _finishOnboarding(context),
              child: const Text('Finalizar'),
            ),
          ),
          const SizedBox(height: 16), // Espacio al final
        ],
      ),
    );
  }
}
