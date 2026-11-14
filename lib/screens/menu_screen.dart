import 'package:flutter/cupertino.dart';
import '../data/productos_data.dart';
import '../routes/app_routes.dart';
import '../theme/app_theme.dart';
import '../widgets/app_card.dart';
import '../widgets/dialogos.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  Future<void> _abrir(String ruta) async {
    await Navigator.pushNamed(context, ruta);
    // Al volver se refresca el resumen (pudo cambiar el inventario o el perfil)
    if (mounted) setState(() {});
  }

  Future<void> _cerrarSesion() async {
    final salir = await confirmar(
      context,
      titulo: 'Cerrar sesión',
      mensaje: '¿Seguro que deseas salir de la aplicación?',
      textoAceptar: 'Salir',
      destructivo: true,
    );
    if (!salir || !mounted) return;

    // Limpia todo el historial y vuelve al login
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.login,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final suave = AppTheme.color(context, AppTheme.textoSuave);

    // Lista de mapas con los indicadores de la Card de resumen
    final resumen = [
      {'valor': '${ProductosData.total}', 'etiqueta': 'Productos'},
      {'valor': '${ProductosData.agotados}', 'etiqueta': 'Agotados'},
      {
        'valor': 'S/ ${ProductosData.valorInventario.toStringAsFixed(0)}',
        'etiqueta': 'Inventario',
      },
    ];

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        automaticallyImplyLeading: false,
        middle: Text('Menú'),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 12),
          children: [
            // Card de bienvenida con el resumen del inventario
            AppCard(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Bienvenido', style: TextStyle(color: suave)),
                  const SizedBox(height: 2),
                  Text(
                    usuarioActual['nombre']!,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: resumen.map((dato) {
                      return Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              dato['valor']!,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.primario,
                              ),
                            ),
                            Text(
                              dato['etiqueta']!,
                              style: TextStyle(fontSize: 13, color: suave),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            // Genera un CupertinoListTile por cada mapa de opcionesMenu
            CupertinoListSection.insetGrouped(
              header: const Text('Opciones'),
              children: opcionesMenu.map((opcion) {
                return CupertinoListTile.notched(
                  leading: Icon(opcion['icono'] as IconData),
                  title: Text(opcion['titulo'] as String),
                  subtitle: Text(opcion['subtitulo'] as String),
                  trailing: const CupertinoListTileChevron(),
                  onTap: () => _abrir(opcion['ruta'] as String),
                );
              }).toList(),
            ),

            // Opción de salir, con estilo distinto
            CupertinoListSection.insetGrouped(
              children: [
                CupertinoListTile.notched(
                  leading: const Icon(
                    CupertinoIcons.square_arrow_right,
                    color: AppTheme.error,
                  ),
                  title: const Text(
                    'Cerrar sesión',
                    style: TextStyle(color: AppTheme.error),
                  ),
                  onTap: _cerrarSesion,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
