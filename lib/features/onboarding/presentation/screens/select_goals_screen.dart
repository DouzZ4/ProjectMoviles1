import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // 1. Importa Provider

// 2. Importa el provider
import '../providers/onboarding_provider.dart';

// Importa la siguiente pantalla si la tienes
// import 'notification_settings_screen.dart';

// 3. Ahora es un StatelessWidget
class SelectGoalsScreen extends StatelessWidget {
  const SelectGoalsScreen({super.key});

  static const String routeName = '/select-goals';

  // La lógica de navegación puede permanecer aquí o moverse al Provider si es compleja
  void _navigateToNext(BuildContext context, Set<String> selectedGoals) {
    if (selectedGoals.isEmpty) return; // Doble chequeo

    // TODO: Implementar navegación real y usar las selectedGoals del provider
    print(
      'Navegando al siguiente paso con metas (desde Provider): $selectedGoals',
    );

    // Podrías llamar a un método en el provider antes de navegar:
    // Provider.of<OnboardingProvider>(context, listen: false).submitSelectedGoals().then((_) {
    //    Navigator.of(context).pushReplacement(...); // Navega DESPUÉS de guardar
    // });

    // Navegación simple por ahora:
    // Navigator.of(context).pushReplacement(
    //   MaterialPageRoute(builder: (_) => const NotificationSettingsScreen()),
    // );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    // Colores (idealmente desde el tema)
    const Color goldenYellow = Color(0xFFFFC107);
    const Color denimBlue = Color(0xFF2E5EAA);
    const Color charcoalGray = Color(0xFF36454F);
    final Color chipBackground = Colors.grey[200]!;
    final Color chipSelectedBackground = goldenYellow;
    final Color chipBorder = Colors.grey[400]!;
    final Color chipSelectedBorder = goldenYellow.withOpacity(0.8);

    // --- 4. Obtener la instancia del Provider ---
    // context.watch<T>() escucha los cambios y reconstruye este widget cuando
    // el provider llama a notifyListeners().
    final onboardingProvider = context.watch<OnboardingProvider>();

    // Alternativa: Puedes envolver solo las partes que necesitan datos/reconstruirse
    // con Consumer<OnboardingProvider>(builder: (context, provider, child) { ... })

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 24.0, 20.0, 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Barra de Progreso (sin cambios)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: 0.66,
                  minHeight: 10,
                  backgroundColor: Colors.grey[300],
                  valueColor: const AlwaysStoppedAnimation<Color>(denimBlue),
                ),
              ),
              const SizedBox(height: 32),

              // Título y Subtítulo (sin cambios)
              Text(
                'Dinos tus metas',
                style: textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Elige las que desees',
                style: textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // --- Lista de Metas (Ahora usa el Provider) ---
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Wrap(
                    spacing: 10.0,
                    runSpacing: 10.0,
                    alignment: WrapAlignment.center,
                    // 5. Usa la lista de metas del provider
                    children:
                        onboardingProvider.suggestedGoals.map((goal) {
                          // 6. Comprueba si está seleccionada usando el estado del provider
                          final bool isSelected = onboardingProvider
                              .selectedGoals
                              .contains(goal);
                          return FilterChip(
                            label: Text(goal),
                            selected: isSelected,
                            onSelected: (bool selected) {
                              // 7. Llama al método del provider para actualizar el estado.
                              // Usamos context.read<T>() aquí porque solo estamos ejecutando
                              // una acción, no necesitamos que este callback específico escuche cambios.
                              context
                                  .read<OnboardingProvider>()
                                  .toggleGoalSelection(goal);
                            },
                            // Estilos (sin cambios, pero podrían usar colores del provider si fueran dinámicos)
                            backgroundColor: chipBackground,
                            selectedColor: chipSelectedBackground,
                            labelStyle: TextStyle(
                              color: isSelected ? charcoalGray : Colors.black,
                              fontWeight:
                                  isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                              side: BorderSide(
                                color:
                                    isSelected
                                        ? chipSelectedBorder
                                        : chipBorder,
                                width: 1,
                              ),
                            ),
                            showCheckmark: false,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            elevation: isSelected ? 2 : 0,
                          );
                        }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // --- Botón Siguiente (Ahora usa el Provider) ---
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
                  disabledBackgroundColor: Colors.grey[350],
                  disabledForegroundColor: Colors.white,
                ),
                // 8. Habilita/deshabilita basado en el estado del provider
                onPressed:
                    onboardingProvider.canProceed
                        ? () => _navigateToNext(
                          context,
                          onboardingProvider.selectedGoals,
                        )
                        : null,
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
