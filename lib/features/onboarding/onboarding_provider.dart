import 'package:flutter/foundation.dart';

class OnboardingProvider with ChangeNotifier {
  // --- Estado Privado ---

  final List<String> _suggestedGoals = [
    'Bajar de peso',
    'Organizar mi espacio',
    'Leer un nuevo libro',
    'Dedicar tiempo a practicar',
    'Comenzar un curso online',
    'Hacer ejercicio frecuente',
    'Tomar suficientes vasos de agua',
    'Dar un paseo diario',
    'Ahorrar dinero',
    'Aprender un idioma',
    'Meditar regularmente',
    'Cocinar más en casa',
  ];

  // Nuevo: Set para guardar las metas añadidas por el usuario
  final Set<String> _customGoals = {};

  // Set que guarda las metas seleccionadas (tanto sugeridas como personalizadas)
  final Set<String> _selectedGoals = {};

  // --- Getters Públicos ---

  List<String> get suggestedGoals => List.unmodifiable(_suggestedGoals);
  // Nuevo: Getter para las metas personalizadas
  Set<String> get customGoals => Set.unmodifiable(_customGoals);

  // Nuevo: Getter que combina ambas listas para mostrar en la UI
  List<String> get allDisplayGoals =>
      List.unmodifiable([..._suggestedGoals, ..._customGoals]);

  Set<String> get selectedGoals => Set.unmodifiable(_selectedGoals);
  bool get canProceed => _selectedGoals.isNotEmpty;

  // --- Métodos Públicos ---

  void toggleGoalSelection(String goal) {
    // Funciona igual, ya que _selectedGoals maneja cualquier String
    if (_selectedGoals.contains(goal)) {
      _selectedGoals.remove(goal);
    } else {
      _selectedGoals.add(goal);
    }
    notifyListeners();
  }

  // Nuevo: Método para añadir una meta personalizada
  // Devuelve true si se añadió, false si no (ej. vacía o duplicada)
  bool addCustomGoal(String goal) {
    final String trimmedGoal = goal.trim(); // Quitar espacios extra
    if (trimmedGoal.isEmpty) {
      print('Intento de añadir meta vacía.');
      return false; // No añadir metas vacías
    }

    // Opcional: Verificar si ya existe (ignorando mayúsculas/minúsculas)
    bool existsInSuggested = _suggestedGoals.any(
      (g) => g.toLowerCase() == trimmedGoal.toLowerCase(),
    );
    bool existsInCustom = _customGoals.any(
      (g) => g.toLowerCase() == trimmedGoal.toLowerCase(),
    );

    if (existsInSuggested || existsInCustom) {
      print('La meta "$trimmedGoal" ya existe.');
      // Podrías mostrar un mensaje al usuario aquí si quieres
      return false; // No añadir duplicados
    }

    // Añadir la meta personalizada
    _customGoals.add(trimmedGoal);
    print('Meta personalizada añadida: $trimmedGoal');

    // Opcional: ¿Seleccionar automáticamente la meta recién añadida?
    // toggleGoalSelection(trimmedGoal); // Descomenta si quieres este comportamiento

    notifyListeners(); // Notifica que la lista combinada (allDisplayGoals) cambió
    return true;
  }

  void clearSelection() {
    if (_selectedGoals.isNotEmpty) {
      _selectedGoals.clear();
      notifyListeners();
    }
  }
}
