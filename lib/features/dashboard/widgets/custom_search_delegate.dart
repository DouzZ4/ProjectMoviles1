// lib/features/dashboard/widgets/custom_search_delegate.dart
import 'package:flutter/material.dart';
import '../../../core/theme/colors.dart'; // Importa tus colores

class CustomSearchDelegate extends SearchDelegate<String?> {
  // <String?> es el tipo de resultado que puede devolver

  // Lista de ejemplo para sugerencias/historial (podría venir de otro lado)
  final List<String> searchHistory = [
    'Caminar',
    'Beber agua',
    'Dormir',
    'Leer',
    'Meditar',
  ];

  final List<String> suggestions = [
    'Hacer ejercicio',
    'Planificar semana',
    'Estudiar Flutter',
    'Limpiar habitación',
  ];

  // ----- Personalización del Campo de Búsqueda -----
  @override
  String? get searchFieldLabel => 'Buscar metas, triunfos...'; // Placeholder text

  @override
  ThemeData appBarTheme(BuildContext context) {
    final theme = Theme.of(context);
    return theme.copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background, // Fondo blanco o el de tu tema
        elevation: 0, // Sin sombra
        iconTheme: const IconThemeData(
          color: AppColors.textPrimary,
        ), // Iconos oscuros
        titleTextStyle: theme.textTheme.titleLarge?.copyWith(
          color: AppColors.textPrimary,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(
          color: AppColors.textSecondary.withAlpha(200),
        ), // Color del placeholder
        border:
            InputBorder.none, // Sin borde visible en el TextField del AppBar
        focusedBorder: InputBorder.none,
      ),
    );
  }

  // ----- Acciones (lado derecho del AppBar de búsqueda) -----
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      // Botón para limpiar el texto
      if (query.isNotEmpty) // Mostrar solo si hay texto
        IconButton(
          icon: const Icon(Icons.clear),
          tooltip: 'Limpiar',
          onPressed: () {
            query = ''; // Limpia el texto de búsqueda
            showSuggestions(context); // Muestra sugerencias de nuevo
          },
        ),
    ];
  }

  // ----- Botón Izquierdo (generalmente para volver) -----
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_ios_new), // Icono de volver
      tooltip: 'Volver',
      onPressed: () {
        // Cierra la interfaz de búsqueda sin devolver resultado
        close(context, null);
      },
    );
  }

  // ----- Resultados (cuando el usuario confirma la búsqueda, ej. presionando Enter) -----
  @override
  Widget buildResults(BuildContext context) {
    // TODO: Implementar la lógica para buscar y mostrar resultados reales basados en 'query'
    print('Buscando resultados para: $query');
    // Por ahora, solo mostramos un placeholder
    return Center(
      child: Text(
        'Mostrando resultados para "$query"',
        style: const TextStyle(fontSize: 18),
        textAlign: TextAlign.center,
      ),
    );
  }

  // ----- Sugerencias (se muestran mientras el usuario escribe) -----
  @override
  Widget buildSuggestions(BuildContext context) {
    // Filtrar historial y sugerencias basado en lo que el usuario escribe ('query')
    final List<String> displayList;
    if (query.isEmpty) {
      displayList = searchHistory; // Mostrar historial si no hay query
    } else {
      // Combina y filtra historial + sugerencias
      final combined = {
        ...searchHistory,
        ...suggestions,
      }; // Usa Set para evitar duplicados iniciales
      displayList =
          combined
              .where((item) => item.toLowerCase().contains(query.toLowerCase()))
              .toList();
    }

    return ListView.builder(
      itemCount: displayList.length,
      itemBuilder: (context, index) {
        final item = displayList[index];
        return ListTile(
          leading: Icon(
            searchHistory.contains(item)
                ? Icons.history
                : Icons.lightbulb_outline,
            color: AppColors.mediumGrey,
          ), // Icono diferente para historial/sugerencia
          title: Text(item),
          trailing: IconButton(
            // Icono 'x' como en la imagen
            icon: const Icon(
              Icons.close,
              size: 18,
              color: AppColors.mediumGrey,
            ),
            tooltip: 'Quitar sugerencia (funcionalidad pendiente)',
            onPressed: () {
              // TODO: Implementar lógica para quitar del historial o manejar la interacción
              print('Quitar: $item');
            },
          ),
          onTap: () {
            query =
                item; // Pone el texto de la sugerencia en el campo de búsqueda
            showResults(
              context,
            ); // Muestra la pantalla de resultados (llama a buildResults)
            // O podrías cerrar y devolver el resultado: close(context, item);
          },
        );
      },
    );
  }
}
