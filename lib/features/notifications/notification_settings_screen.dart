import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'notification_settings_provider.dart';
import '../../core/theme/colors.dart';
import 'package:flutter/foundation.dart'; // Para kDebugMode
// Importa la pantalla principal para la navegación final
import '../dashboard/dashboard_screen.dart';

class NotificationSettingsScreen extends StatelessWidget {
  const NotificationSettingsScreen({super.key});

  void _finishOnboarding(BuildContext context) async {
    final provider = context.read<NotificationSettingsProvider>();
    // Llama a saveSettings que ahora internamente llama a _saveCurrentSettings
    await provider.saveSettings();

    if (kDebugMode) {
      print('Onboarding Finalizado! Navegando a la app principal...');
    }

    if (!context.mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => const DashboardScreen(),
      ), // Navega al Dashboard
      (route) => false, // Elimina stack de onboarding
    );
  }

  @override
  Widget build(BuildContext context) {
    final settingsProvider = context.watch<NotificationSettingsProvider>();
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurar Notificaciones'),
        automaticallyImplyLeading: false,
      ),
      // --- CORRECCIÓN PRINCIPAL: Condición basada en isLoading ---
      body:
          settingsProvider
                  .isLoading // Muestra indicador si está cargando
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                // Muestra el contenido si NO está cargando
                padding: const EdgeInsets.symmetric(
                  vertical: 24.0,
                  horizontal: 16.0,
                ),
                children: [
                  // Barra de Progreso
                  Padding(
                    padding: const EdgeInsets.only(bottom: 32.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: const LinearProgressIndicator(
                        value: 1.0, // 100%
                        minHeight: 10,
                        backgroundColor: AppColors.lightGrey,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.primary,
                        ),
                      ),
                    ),
                  ),

                  // Texto introductorio
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
                  const SizedBox(height: 32),

                  // --- Interruptor General (CORREGIDO: Orden correcto) ---
                  Card(
                    elevation: 0.5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: SwitchListTile(
                      title: Text(
                        'Activar Notificaciones',
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Text(
                        settingsProvider.notificationsEnabled
                            ? 'Recibirás recordatorios y alertas.'
                            : 'No recibirás ninguna notificación.',
                        style: textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      value: settingsProvider.notificationsEnabled,
                      onChanged: (bool newValue) {
                        context
                            .read<NotificationSettingsProvider>()
                            .updateNotificationsEnabled(newValue);
                      },
                      activeColor: AppColors.white,
                      activeTrackColor: AppColors.primary,
                      inactiveThumbColor: AppColors.white,
                      inactiveTrackColor: AppColors.mediumGrey.withAlpha(
                        (255 * 0.5).round(),
                      ),
                      secondary: Icon(
                        settingsProvider.notificationsEnabled
                            ? Icons.notifications_active
                            : Icons.notifications_off_outlined,
                        color:
                            settingsProvider.notificationsEnabled
                                ? AppColors.primary
                                : AppColors.mediumGrey,
                        size: 28,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                  ),

                  const Divider(height: 40, indent: 16, endIndent: 16),

                  // --- Controles Detallados (SOLO SI ESTÁN ACTIVADAS LAS NOTIFICACIONES)---
                  if (settingsProvider.notificationsEnabled) ...[
                    // --- Selector de Hora de Recordatorio Diario ---
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
                            ),
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
                              const TimeOfDay(hour: 9, minute: 0),
                          helpText: 'SELECCIONA HORA DEL RECORDATORIO',
                        );
                        if (selectedTime != null) {
                          context
                              .read<NotificationSettingsProvider>()
                              .updateDailyReminderTime(selectedTime);
                        }
                      },
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                    const SizedBox(height: 24),

                    // --- Horas de Silencio (No Molestar) ---
                    SwitchListTile(
                      secondary: Icon(
                        Icons.bedtime_outlined,
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
                      value: settingsProvider.quietHoursEnabled,
                      onChanged: (bool newValue) {
                        context
                            .read<NotificationSettingsProvider>()
                            .updateQuietHoursEnabled(newValue);
                      },
                      activeColor: AppColors.white,
                      activeTrackColor: AppColors.primary,
                      inactiveThumbColor: AppColors.white,
                      inactiveTrackColor: AppColors.mediumGrey.withAlpha(
                        (255 * 0.5).round(),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                    ),

                    // Selectores de Hora (Solo si las Horas de Silencio están activadas)
                    if (settingsProvider.quietHoursEnabled) ...[
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 50.0,
                          right: 8.0,
                          top: 4.0,
                        ),
                        child: Column(
                          children: [
                            ListTile(
                              // Hora Inicio
                              dense: true,
                              visualDensity: VisualDensity.compact,
                              contentPadding: EdgeInsets.zero,
                              title: const Text(
                                'Desde',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              trailing: TextButton(
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                ),
                                onPressed: () async {
                                  final TimeOfDay? currentStartTime =
                                      settingsProvider.quietHoursStartTime;
                                  final TimeOfDay? selectedTime =
                                      await showTimePicker(
                                        context: context,
                                        initialTime:
                                            currentStartTime ??
                                            const TimeOfDay(
                                              hour: 22,
                                              minute: 0,
                                            ),
                                        helpText: 'INICIO HORAS DE SILENCIO',
                                      );
                                  if (selectedTime != null) {
                                    context
                                        .read<NotificationSettingsProvider>()
                                        .updateQuietHoursStartTime(
                                          selectedTime,
                                        );
                                  }
                                },
                                child: Text(
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
                            ListTile(
                              // Hora Fin
                              dense: true,
                              visualDensity: VisualDensity.compact,
                              contentPadding: EdgeInsets.zero,
                              title: const Text(
                                'Hasta',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              trailing: TextButton(
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                ),
                                onPressed: () async {
                                  final TimeOfDay? currentEndTime =
                                      settingsProvider.quietHoursEndTime;
                                  final TimeOfDay? selectedTime =
                                      await showTimePicker(
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
                                  settingsProvider.quietHoursEndTime?.format(
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
                          ],
                        ),
                      ),
                    ], // Fin del if quietHoursEnabled

                    const SizedBox(height: 24),

                    // --- Interruptor de Vibración ---
                    SwitchListTile(
                      secondary: Icon(
                        Icons.vibration,
                        color:
                            settingsProvider.vibrationEnabled
                                ? AppColors.primary
                                : AppColors.mediumGrey,
                      ),
                      title: const Text('Vibrar al notificar'),
                      subtitle: Text(
                        settingsProvider.vibrationEnabled
                            ? 'Activado'
                            : 'Desactivado',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                      value: settingsProvider.vibrationEnabled,
                      onChanged: (bool newValue) {
                        context
                            .read<NotificationSettingsProvider>()
                            .updateVibrationEnabled(newValue);
                      },
                      activeColor: AppColors.white,
                      activeTrackColor: AppColors.primary,
                      inactiveThumbColor: AppColors.white,
                      inactiveTrackColor: AppColors.mediumGrey.withAlpha(
                        (255 * 0.5).round(),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                  ] else ...[
                    // Mensaje cuando las notificaciones están desactivadas
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 24.0,
                      ),
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
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ElevatedButton(
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
