import 'package:flutter/cupertino.dart';
import '../data/productos_data.dart';
import '../models/producto.dart';
import '../routes/app_routes.dart';
import '../theme/app_theme.dart';
import '../widgets/app_card.dart';
import '../widgets/dialogos.dart';

class ListarProductosScreen extends StatefulWidget {
  const ListarProductosScreen({super.key});

  @override
  State<ListarProductosScreen> createState() => _ListarProductosScreenState();
}

class _ListarProductosScreenState extends State<ListarProductosScreen> {
  final _buscarCtrl = TextEditingController();
  String _texto = '';
  int _filtroStock = 0; // clave del mapa filtrosStock

  @override
  void dispose() {
    _buscarCtrl.dispose();
    super.dispose();
  }

  /// Filtra la lista según el buscador y el control segmentado.
  List<Producto> get _productosFiltrados {
    return ProductosData.productos.where((p) {
      final coincideTexto =
          p.nombre.toLowerCase().contains(_texto.toLowerCase());
      final coincideStock = switch (_filtroStock) {
        1 => p.hayStock,
        2 => !p.hayStock,
        _ => true,
      };
      return coincideTexto && coincideStock;
    }).toList();
  }

  Future<void> _irARegistrar() async {
    final resultado = await Navigator.pushNamed(context, AppRoutes.registrar);
    // Si el formulario guardó un producto, refresca la lista
    if (resultado == true && mounted) setState(() {});
  }

  void _verDetalle(Producto producto) {
    // El producto viaja como argumento de la ruta nombrada
    Navigator.pushNamed(context, AppRoutes.detalle, arguments: producto);
  }

  Future<void> _eliminar(Producto producto) async {
    final aceptar = await confirmar(
      context,
      titulo: 'Eliminar producto',
      mensaje: '¿Deseas eliminar "${producto.nombre}" del inventario?',
      textoAceptar: 'Eliminar',
      destructivo: true,
    );
    if (aceptar && mounted) {
      setState(() => ProductosData.eliminar(producto));
    }
  }

  /// Menú contextual estilo iOS (hoja de acciones).
  void _mostrarAcciones(Producto producto) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: Text(producto.nombre),
        message: Text(producto.descripcion),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              _verDetalle(producto);
            },
            child: const Text('Ver detalle'),
          ),
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
              _eliminar(producto);
            },
            child: const Text('Eliminar'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final productos = _productosFiltrados;
    final suave = AppTheme.color(context, AppTheme.textoSuave);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Productos'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: _irARegistrar,
          child: const Icon(CupertinoIcons.add),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Buscador
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: CupertinoSearchTextField(
                controller: _buscarCtrl,
                placeholder: 'Buscar producto...',
                onChanged: (valor) => setState(() => _texto = valor),
              ),
            ),

            // Filtro por stock, generado desde el mapa filtrosStock
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: SizedBox(
                width: double.infinity,
                child: CupertinoSlidingSegmentedControl<int>(
                  groupValue: _filtroStock,
                  children: filtrosStock.map(
                    (clave, etiqueta) => MapEntry(
                      clave,
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Text(etiqueta),
                      ),
                    ),
                  ),
                  onValueChanged: (valor) {
                    setState(() => _filtroStock = valor ?? 0);
                  },
                ),
              ),
            ),

            // ListView con los productos
            Expanded(
              child: productos.isEmpty
                  ? Center(
                      child: Text(
                        'No se encontraron productos',
                        style: TextStyle(color: suave),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.only(bottom: 16),
                      itemCount: productos.length,
                      itemBuilder: (context, index) {
                        final producto = productos[index];

                        return AppCard(
                          child: CupertinoListTile(
                            padding: const EdgeInsets.fromLTRB(14, 12, 6, 12),
                            leadingSize: 46,
                            leadingToTitle: 14,
                            leading: IconoCuadro(
                              icono: producto.icono,
                              size: 46,
                            ),
                            title: Text(
                              producto.nombre,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600),
                            ),
                            subtitle: Row(
                              children: [
                                Text('Stock: ${producto.stock}'),
                                if (!producto.hayStock) ...[
                                  const SizedBox(width: 8),
                                  const _EtiquetaAgotado(),
                                ],
                              ],
                            ),
                            additionalInfo: Text(producto.precioFormateado),
                            trailing: CupertinoButton(
                              padding: EdgeInsets.zero,
                              onPressed: () => _mostrarAcciones(producto),
                              child: Icon(
                                CupertinoIcons.ellipsis_vertical,
                                color: suave,
                                size: 20,
                              ),
                            ),
                            onTap: () => _verDetalle(producto),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EtiquetaAgotado extends StatelessWidget {
  const _EtiquetaAgotado();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
      decoration: BoxDecoration(
        color: AppTheme.error.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Text(
        'Agotado',
        style: TextStyle(
          fontSize: 11,
          color: AppTheme.error,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
