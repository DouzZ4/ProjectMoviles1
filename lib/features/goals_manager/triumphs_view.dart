import 'package:flutter/material.dart';
import '../../core/theme/colors.dart'; // Importa tus colores

class TriumphsView extends StatelessWidget {
  const TriumphsView({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      // Usar Container para posible padding o color de fondo
      // color: Colors.white, // Opcional: si el fondo del scaffold no es blanco
      padding: const EdgeInsets.symmetric(
        horizontal: 32.0,
      ), // Padding horizontal
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Centrar verticalmente
        crossAxisAlignment:
            CrossAxisAlignment.stretch, // Estirar horizontalmente
        children: [
          // Icono Placeholder
          Icon(
            Icons.image_outlined, // Icono de imagen placeholder
            size: 100,
            color: AppColors.mediumGrey.withAlpha(150), // Gris semitransparente
          ),
          const SizedBox(height: 24),

          // Texto "Sin Triunfos"
          Text(
            'Sin Triunfos',
            textAlign: TextAlign.center,
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),

          // Texto descriptivo
          Text(
            // Corregido "obetener" a "obtener"
            'Sigue completando Metas para obtener Triunfos',
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 32),

          // Botón "Agrega triunfos"
          ElevatedButton(
            // Usar el estilo del tema, pero quizás hacerlo menos ancho
            style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
              minimumSize: WidgetStateProperty.all(
                const Size(150, 45),
              ), // Ancho menor
              maximumSize: WidgetStateProperty.all(
                const Size(250, 45),
              ), // Ancho máximo
              // Centrar el botón si es menos ancho que el padre
              alignment: Alignment.center,
            ),

            // Centrar el botón en la columna requiere un truco o un padre diferente,
            // por ahora se estirará por el CrossAxisAlignment.stretch de la Columna padre.
            // Si quieres centrarlo, envuélvelo en un Center o Row con MainAxisAlignment.center.
            // Para este ejemplo, lo dejamos estirado como en el código anterior.
            onPressed: () {
              // TODO: Implementar la acción para agregar triunfos
              print('Botón "Agrega triunfos" presionado');
            },
            child: const Text('Agrega triunfos'),
          ),
        ],
      ),
    );
  }
}
