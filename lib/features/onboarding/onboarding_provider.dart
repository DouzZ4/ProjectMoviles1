import 'package:flutter/foundation.dart';

class OnboardingProvider with ChangeNotifier {
  // Por ahora, este provider no necesita manejar mucho estado
  // para la WelcomeScreen. Lo llenaremos cuando lleguemos a
  // SelectGoalsScreen.

  // Ejemplo de estado que podría tener después:
  // final Set<String> _selectedGoals = {};
  // Set<String> get selectedGoals => Set.unmodifiable(_selectedGoals);
  // bool get canProceed => _selectedGoals.isNotEmpty;

  // void toggleGoalSelection(String goal) { ... notifyListeners(); }
}
