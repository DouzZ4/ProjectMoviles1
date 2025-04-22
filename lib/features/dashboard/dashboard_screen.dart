import 'package:flutter/material.dart';
import '../../core/theme/colors.dart'; // Tus colores
// Importa las vistas de las pestañas
import '../goals_manager/goals_view.dart';
import '../goals_manager/progress_view.dart';
import '../goals_manager/triumphs_view.dart';
import '../dashboard/widgets/custom_search_delegate.dart'; // Importa el CustomSearchDelegate

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  static const String routeName = '/dashboard';

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

// Necesitamos SingleTickerProviderStateMixin para el TabController
class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  // Estado para el índice de la barra de navegación inferior
  int _bottomNavIndex = 1; // Empezar en "Metas" (índice 1)

  // Controlador para las pestañas superiores
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // Inicializa el TabController con 3 pestañas
    // vsync: this necesita el SingleTickerProviderStateMixin
    // initialIndex: 2 para que "Triunfos" esté seleccionada como en la imagen
    _tabController = TabController(length: 3, vsync: this, initialIndex: 2);
  }

  @override
  void dispose() {
    // Libera el controlador cuando el widget se destruye
    _tabController.dispose();
    super.dispose();
  }

  // Manejador para el cambio de ítem en la barra inferior
  void _onBottomNavItemTapped(int index) {
    // Por ahora, solo cambiamos el estado local.
    // En una app más compleja, esto podría navegar a otras scaffolds/rutas.
    if (_bottomNavIndex != index) {
      setState(() {
        _bottomNavIndex = index;
      });
      // Si el usuario selecciona algo diferente a "Metas", podríamos querer
      // resetear el TabController o manejar la vista de forma diferente.
      // Por ahora, el TabBar/TabBarView solo es visible si _bottomNavIndex == 1.
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        // El título podría cambiar según la pestaña o sección, por ahora fijo
        title: Text(
          'Metas', // Título como en la imagen
          style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: false, // Título a la izquierda es más común
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Buscar',
            onPressed: () {
              // Abre el CustomSearchDelegate al presionar el icono de búsqueda
              showSearch(
                context: context,
                delegate:
                    CustomSearchDelegate(), // Tu clase de búsqueda personalizada
              );
            },
          ),
        ],
        // La barra de pestañas va en la propiedad 'bottom' del AppBar
        bottom:
            (_bottomNavIndex ==
                    1) // Mostrar solo si la sección "Metas" está seleccionada abajo
                ? PreferredSize(
                  preferredSize: const Size.fromHeight(
                    kToolbarHeight - 8,
                  ), // Altura estándar de TabBar
                  child: Container(
                    // Color de fondo para la barra de pestañas (opcional)
                    color: Theme.of(context).appBarTheme.backgroundColor,
                    // O un color ligeramente diferente:
                    // color: AppColors.background.withAlpha(250),
                    child: TabBar(
                      controller: _tabController,
                      indicatorColor:
                          AppColors.primary, // Color de la línea indicadora
                      indicatorWeight: 3.0, // Grosor de la línea
                      labelColor:
                          AppColors
                              .primary, // Color del texto de la pestaña activa
                      unselectedLabelColor:
                          AppColors.textSecondary, // Color del texto inactivo
                      labelStyle: textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ), // Estilo del texto activo
                      unselectedLabelStyle:
                          textTheme.bodyLarge, // Estilo del texto inactivo
                      tabs: const [
                        Tab(text: 'Metas'),
                        Tab(text: 'En progreso'),
                        Tab(text: 'Triunfos'),
                      ],
                    ),
                  ),
                )
                : null, // No mostrar TabBar si no estamos en la sección "Metas"
      ),
      // Usamos IndexedStack si queremos mantener el estado de las vistas de la
      // barra de navegación inferior cuando no están visibles.
      // Si no, podríamos usar directamente el widget correspondiente al índice.
      body: IndexedStack(
        index: _bottomNavIndex,
        children: <Widget>[
          // Vista para "Explora" (Índice 0) - Placeholder
          const Center(child: Text('Contenido Explora')),

          // Vista para "Metas" (Índice 1) - Contiene el TabBarView
          // Solo mostrar TabBarView si estamos en esta sección
          (_bottomNavIndex == 1)
              ? TabBarView(
                controller: _tabController,
                children: const [
                  GoalsView(), // Contenido Pestaña Metas
                  ProgressView(), // Contenido Pestaña En progreso
                  TriumphsView(), // Contenido Pestaña Triunfos (con estado vacío)
                ],
              )
              : const SizedBox.shrink(), // Widget vacío si no estamos en la sección Metas
          // Vista para "Configuracion" (Índice 2) - Placeholder
          const Center(child: Text('Contenido Configuración')),
        ],
      ),

      // Barra de Navegación Inferior
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _bottomNavIndex, // Índice activo
        onTap: _onBottomNavItemTapped, // Callback al tocar
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.explore_outlined),
            activeIcon: Icon(
              Icons.explore,
            ), // Icono diferente cuando está activo
            label: 'Explora',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.checklist_rtl_outlined,
            ), // Icono que se parece más a una lista
            activeIcon: Icon(Icons.checklist_rtl),
            label: 'Metas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline), // Icono de perfil/configuración
            activeIcon: Icon(Icons.person),
            label: 'Configuracion',
          ),
        ],
        // Estilos opcionales (mejor definirlos en el ThemeData si es posible)
        // type: BottomNavigationBarType.fixed, // O .shifting
        // selectedItemColor: AppColors.primary,
        // unselectedItemColor: AppColors.textSecondary,
        // showSelectedLabels: true,
        // showUnselectedLabels: true,
      ),
    );
  }
}
