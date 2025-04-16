import 'package:flutter/foundation.dart'; // Necesario para kDebugMode
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'onboarding_provider.dart'; // Asegúrate que la ruta sea correcta
import '../../core/theme/colors.dart'; // Asegúrate que la ruta sea correcta
import '../notifications/notification_settings_screen.dart';

// Importa la siguiente pantalla si la tienes definida
// import '../notifications/notification_settings_screen.dart';

class SelectGoalsScreen extends StatefulWidget {
  const SelectGoalsScreen({super.key});

  @override
  State<SelectGoalsScreen> createState() => _SelectGoalsScreenState();
}

class _SelectGoalsScreenState extends State<SelectGoalsScreen> {
  late TextEditingController _customGoalController;
  final FocusNode _customGoalFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _customGoalController = TextEditingController();
  }

  @override
  void dispose() {
    _customGoalController.dispose();
    _customGoalFocusNode.dispose();
    super.dispose();
  }

  void _handleAddCustomGoal() {
    final String goalText = _customGoalController.text;
    final provider = context.read<OnboardingProvider>();

    if (provider.addCustomGoal(goalText)) {
      _customGoalController.clear();
      _customGoalFocusNode.unfocus();
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            goalText.trim().isEmpty
                ? 'Por favor, ingresa una meta.'
                : 'Esa meta ya existe o es una sugerencia.',
            style: const TextStyle(color: AppColors.white),
          ),
          // CORREGIDO: Usando withAlpha para consistencia (aunque withOpacity podría funcionar aquí)
          backgroundColor: AppColors.accent.withAlpha((255 * 0.9).round()),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
      _customGoalFocusNode.requestFocus();
    }
  }

  void _navigateToNext(BuildContext context, Set<String> selectedGoals) {
    if (selectedGoals.isEmpty) return;
    // CORREGIDO: print envuelto en kDebugMode
    if (kDebugMode) {
      print(
        'Navegando al siguiente paso con metas (desde Provider): $selectedGoals',
      );
    }
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const NotificationSettingsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final onboardingProvider = context.watch<OnboardingProvider>();

    // CORREGIDO: Usando withAlpha en lugar de withOpacity
    final Color chipBackground = AppColors.lightGrey.withAlpha(
      (255 * 0.5).round(),
    );
    final Color chipBorder = AppColors.mediumGrey.withAlpha(
      (255 * 0.5).round(),
    );

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 24.0, 20.0, 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Barra de Progreso
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: 0.66,
                  minHeight: 10,
                  backgroundColor: AppColors.lightGrey,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Título y Subtítulo
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
                style: textTheme.titleMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // Campo de Texto y Botón para Añadir Meta Personalizada
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _customGoalController,
                        focusNode: _customGoalFocusNode,
                        decoration: InputDecoration(
                          hintText: 'O añade tu propia meta...',
                          // CORREGIDO: Usando withAlpha
                          hintStyle: TextStyle(
                            color: AppColors.textSecondary.withAlpha(
                              (255 * 0.8).round(),
                            ),
                          ),
                          filled: true,
                          // CORREGIDO: Usando withAlpha
                          fillColor: AppColors.lightGrey.withAlpha(
                            (255 * 0.3).round(),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: AppColors.primary,
                              width: 1.5,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          isDense: true,
                        ),
                        textCapitalization: TextCapitalization.sentences,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => _handleAddCustomGoal(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton.filled(
                      icon: const Icon(Icons.add_circle_outline_rounded),
                      tooltip: 'Añadir meta',
                      style: IconButton.styleFrom(
                        backgroundColor: AppColors.secondary,
                        foregroundColor: AppColors.textPrimary,
                      ),
                      onPressed: _handleAddCustomGoal,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Lista Combinada de Metas
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Wrap(
                    spacing: 10.0,
                    runSpacing: 10.0,
                    alignment: WrapAlignment.center,
                    children:
                        onboardingProvider.allDisplayGoals.map((goal) {
                          final bool isSelected = onboardingProvider
                              .selectedGoals
                              .contains(goal);
                          final bool isCustom = onboardingProvider.customGoals
                              .contains(goal);
                          return FilterChip(
                            label: Text(goal),
                            avatar:
                                isCustom
                                    ? Icon(
                                      Icons.star_border_rounded,
                                      size: 18,
                                      color:
                                          isSelected
                                              ? AppColors.textPrimary
                                              // CORREGIDO: Usando withAlpha
                                              : AppColors.primary.withAlpha(
                                                (255 * 0.8).round(),
                                              ),
                                    )
                                    : null,
                            selected: isSelected,
                            onSelected: (_) {
                              context
                                  .read<OnboardingProvider>()
                                  .toggleGoalSelection(goal);
                            },
                            backgroundColor: chipBackground,
                            selectedColor: AppColors.secondary,
                            labelStyle: TextStyle(
                              color:
                                  isSelected
                                      ? AppColors.textPrimary
                                      // CORREGIDO: Usando withAlpha
                                      : AppColors.textPrimary.withAlpha(
                                        (255 * 0.9).round(),
                                      ),
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
                                        // CORREGIDO: Usando withAlpha
                                        ? AppColors.secondary.withAlpha(
                                          (255 * 0.8).round(),
                                        )
                                        : chipBorder,
                                width: 1.2,
                              ),
                            ),
                            showCheckmark: false,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            elevation: isSelected ? 1.5 : 0,
                          );
                        }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Botón Siguiente (Ya corregido en respuesta anterior)
              ElevatedButton(
                style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
                  backgroundColor: WidgetStateProperty.resolveWith<Color?>((
                    Set<WidgetState> states,
                  ) {
                    if (states.contains(WidgetState.disabled)) {
                      return AppColors.mediumGrey;
                    }
                    return AppColors.secondary;
                  }),
                  foregroundColor: WidgetStateProperty.resolveWith<Color?>((
                    Set<WidgetState> states,
                  ) {
                    if (states.contains(WidgetState.disabled)) {
                      return AppColors.white.withAlpha(
                        (255 * 0.8).round(),
                      ); // Corregido
                    }
                    return AppColors.textPrimary;
                  }),
                ),
                onPressed:
                    onboardingProvider.canProceed
                        ? () => _navigateToNext(
                          context,
                          onboardingProvider.selectedGoals,
                        )
                        : null,
                child: const Text('Siguiente'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
