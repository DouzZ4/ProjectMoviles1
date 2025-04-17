import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'notification_settings_provider.dart';
import '../../core/theme/colors.dart';
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
    //   MaterialPageRoute(builder: (_) => const DashboardScreen()),
    //   (route) => false, // Elimina todas las rutas anteriores (onboarding)
    // );
  }

  @override
  Widget build(BuildContext context) {
    // Obtén la instancia del provider y escucha cambios (`watch`)
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
          // --- Interruptor General (CORREGIDO: PRIMERO EL SWITCH GENERAL) ---
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
              value:
                  settingsProvider
                      .notificationsEnabled, // Vincula el valor al estado del provider
              onChanged: (bool newValue) {
                // Llama al método del provider cuando cambia el valor
                // Usa 'read' dentro de callbacks
                context
                    .read<NotificationSettingsProvider>()
                    .updateNotificationsEnabled(newValue);
              },
              activeColor: AppColors.white, // Color del círculo del switch
              activeTrackColor:
                  AppColors.primary, // Color de la pista encendida
              inactiveThumbColor: AppColors.white,
              inactiveTrackColor: AppColors.mediumGrey.withAlpha(
                (255 * 0.5).round(),
              ), // Usa withAlpha
              secondary: Icon(
                // Icono que también cambia (opcional)
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
          // --- Controles Detallados (SOLO SI ESTÁN ACTIVADAS LAS NOTIFICACIONES) ---
          if (settingsProvider.notificationsEnabled) ...[
            // --- Selector de Hora de Recordatorio Diario (CORREGIDO: DENTRO DEL IF) ---
            ListTile(
              leading: const Icon(
                Icons.alarm_outlined,
                color: AppColors.primary,
              ),
              title: const Text('Recordatorio diario'),
              subtitle: Text(
                settingsProvider.dailyReminderTime == null
                    ? 'No establecido'
                    : settingsProvider.dailyReminderTime!.format(
                      context,
                    ), // Muestra hora formateada
                style: TextStyle(color: AppColors.textSecondary),
              ),
              trailing: const Icon(
                Icons.edit_outlined,
                size: 20,
                color: AppColors.mediumGrey,
              ),
              onTap: () async {
                final TimeOfDay? currentTime =
                    settingsProvider.dailyReminderTime;
                final TimeOfDay? selectedTime = await showTimePicker(
                  context: context,
                  initialTime:
                      currentTime ??
                      const TimeOfDay(hour: 9, minute: 0), // Hora por defecto
                  helpText:
                      'SELECCIONA HORA DEL RECORDATORIO', // Texto de ayuda
                );
                if (selectedTime != null) {
                  context
                      .read<NotificationSettingsProvider>()
                      .updateDailyReminderTime(selectedTime);
                }
              },
              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
            ),
            const SizedBox(height: 24), // Espacio
            // --- Horas de Silencio (No Molestar) (CORREGIDO: DENTRO DEL IF) ---
            SwitchListTile(
              secondary: Icon(
                Icons.bedtime_outlined, // Icono de luna/dormir
                color:
                    settingsProvider.quietHoursEnabled
                        ? AppColors.primary
                        : AppColors.mediumGrey,
              ),
              title: const Text('Horas de silencio'),
              subtitle: Text(
                settingsProvider.quietHoursEnabled
                    ? 'Notificaciones silenciadas durante este periodo.'
                    : 'Puedes recibir notificaciones a cualquier hora.',
                style: TextStyle(color: AppColors.textSecondary),
              ),
              value:
                  settingsProvider.quietHoursEnabled, // Vinculado al provider
              onChanged: (bool newValue) {
                // Actualiza el estado en el provider
                context
                    .read<NotificationSettingsProvider>()
                    .updateQuietHoursEnabled(newValue);
              },
              activeColor: AppColors.white,
              activeTrackColor: AppColors.primary,
              inactiveThumbColor: AppColors.white,
              inactiveTrackColor: AppColors.mediumGrey.withAlpha(
                (255 * 0.5).round(),
              ), // Usa withAlpha
              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
            ),

            // Selectores de Hora (Solo si las Horas de Silencio están activadas)
            if (settingsProvider.quietHoursEnabled) ...[
              Padding(
                // Indentación para mostrar que depende del switch anterior
                padding: const EdgeInsets.only(
                  left: 50.0,
                  right: 8.0,
                  top: 4.0,
                ),
                child: Column(
                  children: [
                    // ListTile para Hora de Inicio
                    ListTile(
                      dense: true,
                      visualDensity: VisualDensity.compact,
                      contentPadding: EdgeInsets.zero,
                      title: const Text(
                        'Desde',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                      trailing: TextButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                        ),
                        onPressed: () async {
                          final TimeOfDay? currentStartTime =
                              settingsProvider.quietHoursStartTime;
                          final TimeOfDay? selectedTime = await showTimePicker(
                            context: context,
                            initialTime:
                                currentStartTime ??
                                const TimeOfDay(hour: 22, minute: 0),
                            helpText: 'INICIO HORAS DE SILENCIO',
                          );
                          if (selectedTime != null) {
                            context
                                .read<NotificationSettingsProvider>()
                                .updateQuietHoursStartTime(selectedTime);
                          }
                        },
                        child: Text(
                          // Muestra hora seleccionada
                          settingsProvider.quietHoursStartTime?.format(
                                context,
                              ) ??
                              'Establecer',
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                    // ListTile para Hora de Fin
                    ListTile(
                      dense: true,
                      visualDensity: VisualDensity.compact,
                      contentPadding: EdgeInsets.zero,
                      title: const Text(
                        'Hasta',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                      trailing: TextButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                        ),
                        onPressed: () async {
                          final TimeOfDay? currentEndTime =
                              settingsProvider.quietHoursEndTime;
                          final TimeOfDay? selectedTime = await showTimePicker(
                            context: context,
                            initialTime:
                                currentEndTime ??
                                const TimeOfDay(hour: 7, minute: 0),
                            helpText: 'FIN HORAS DE SILENCIO',
                          );
                          if (selectedTime != null) {
                            context
                                .read<NotificationSettingsProvider>()
                                .updateQuietHoursEndTime(selectedTime);
                          }
                        },
                        child: Text(
                          // Muestra hora seleccionada
                          settingsProvider.quietHoursEndTime?.format(context) ??
                              'Establecer',
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ], // Fin del if quietHoursEnabled

            const SizedBox(height: 24), // Espacio

            // TODO: Añadir Interruptor de Vibración (iría aquí)
          ] else ...[
            // Mensaje cuando las notificaciones están desactivadas
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 24.0,
              ), // Padding para centrar un poco más
              child: Text(
                'Activa las notificaciones para configurar recordatorios y otras opciones.',
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ], // Fin del if settingsProvider.notificationsEnabled

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
