import 'package:flutter/cupertino.dart';
import '../models/producto.dart';
import '../theme/app_theme.dart';
import '../widgets/app_card.dart';

/// Detalle de un producto.
/// Recibe el Producto por los argumentos de la ruta nombrada.
class DetalleProductoScreen extends StatelessWidget {
  const DetalleProductoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final producto = ModalRoute.of(context)!.settings.arguments as Producto;
    final suave = AppTheme.color(context, AppTheme.textoSuave);

    // El producto se convierte a Map y de ahí se arma la lista de filas
    final mapa = producto.toMap();
    final filas = [
      {
        'icono': CupertinoIcons.tag,
        'etiqueta': 'Categoría',
        'valor': mapa['categoria'] as String,
      },
      {
        'icono': CupertinoIcons.money_dollar_circle,
        'etiqueta': 'Precio',
        'valor': producto.precioFormateado,
      },
      {
        'icono': CupertinoIcons.cube_box,
        'etiqueta': 'Stock',
        'valor': '${mapa['stock']} unidades',
      },
      {
        'icono': CupertinoIcons.sum,
        'etiqueta': 'Valor total',
        'valor': 'S/ ${(producto.precio * producto.stock).toStringAsFixed(2)}',
      },
    ];

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        previousPageTitle: 'Productos',
        middle: Text('Detalle'),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 12),
          children: [
            // Card de cabecera
            AppCard(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  IconoCuadro(icono: producto.icono, size: 76),
                  const SizedBox(height: 14),
                  Text(
                    producto.nombre,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    producto.descripcion,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: suave),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: (producto.hayStock
                              ? AppTheme.exito
                              : AppTheme.error)
                          .withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      producto.hayStock ? 'Disponible' : 'Agotado',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color:
                            producto.hayStock ? AppTheme.exito : AppTheme.error,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            CupertinoListSection.insetGrouped(
              header: const Text('Información'),
              children: filas.map((fila) {
                return CupertinoListTile(
                  leading: Icon(fila['icono'] as IconData),
                  title: Text(fila['etiqueta'] as String),
                  additionalInfo: Text(fila['valor'] as String),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
