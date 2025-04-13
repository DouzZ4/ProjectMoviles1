import 'package:flutter/foundation.dart'; // O 'package:flutter/material.dart';

// Usamos 'with ChangeNotifier' para convertir esta clase en un Provider
class OnboardingProvider with ChangeNotifier {
  // --- Estado Privado ---

  // Lista de metas sugeridas. En una app real, esto podría venir
  // de un repositorio o caso de uso al inicializar el provider.
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

  // El Set que guarda las metas seleccionadas por el usuario.
  final Set<String> _selectedGoals = {};

  // --- Getters Públicos (Vistas del Estado) ---

  // Proporcionamos una copia inmutable para que los widgets no modifiquen
  // la lista directamente. Solo el provider puede cambiar el estado interno.
  List<String> get suggestedGoals => List.unmodifiable(_suggestedGoals);
  Set<String> get selectedGoals => Set.unmodifiable(_selectedGoals);

  // Un getter útil para saber si el botón "Siguiente" debe estar habilitado.
  bool get canProceed => _selectedGoals.isNotEmpty;

  // --- Métodos Públicos (Acciones sobre el Estado) ---

  // Método para seleccionar/deseleccionar una meta.
  void toggleGoalSelection(String goal) {
    if (_selectedGoals.contains(goal)) {
      _selectedGoals.remove(goal);
    } else {
      _selectedGoals.add(goal);
    }
    // ¡Muy importante! Notifica a todos los widgets que están 'escuchando'
    // a este provider que el estado ha cambiado y necesitan redibujarse.
    notifyListeners();
  }

  // Método opcional para limpiar la selección si fuera necesario.
  void clearSelection() {
    if (_selectedGoals.isNotEmpty) {
      _selectedGoals.clear();
      notifyListeners();
    }
  }

  // Podrías añadir aquí un método para cuando el usuario presiona "Siguiente",
  // que podría interactuar con capas de datos/dominio para guardar las metas.
  // Future<void> submitSelectedGoals() async {
  //   print('Guardando metas seleccionadas: $_selectedGoals');
  //   // Aquí llamarías a tu use case o repository para persistir los datos.
  //   // await _saveGoalsUseCase.execute(_selectedGoals);
  // }
}
