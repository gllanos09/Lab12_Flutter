import 'package:flutter/cupertino.dart';
import '../data/productos_data.dart';
import '../models/producto.dart';
import '../theme/app_theme.dart';
import '../widgets/dialogos.dart';

class RegistrarProductoScreen extends StatefulWidget {
  const RegistrarProductoScreen({super.key});

  @override
  State<RegistrarProductoScreen> createState() =>
      _RegistrarProductoScreenState();
}

class _RegistrarProductoScreenState extends State<RegistrarProductoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreCtrl = TextEditingController();
  final _descripcionCtrl = TextEditingController();
  final _precioCtrl = TextEditingController();
  final _stockCtrl = TextEditingController();

  /// Categorías disponibles: cada una con su ícono (lista de mapas).
  static const List<Map<String, dynamic>> _categorias = [
    {'nombre': 'General', 'icono': CupertinoIcons.cube_box},
    {'nombre': 'Cómputo', 'icono': CupertinoIcons.device_laptop},
    {'nombre': 'Periféricos', 'icono': CupertinoIcons.keyboard},
    {'nombre': 'Audio', 'icono': CupertinoIcons.headphones},
  ];
  int _categoria = 0;

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _descripcionCtrl.dispose();
    _precioCtrl.dispose();
    _stockCtrl.dispose();
    super.dispose();
  }

  /// Selector de categoría con CupertinoPicker en una hoja inferior.
  void _elegirCategoria() {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (context) => Container(
        height: 240,
        color: AppTheme.color(context, AppTheme.tarjeta),
        child: SafeArea(
          top: false,
          child: CupertinoPicker(
            itemExtent: 38,
            scrollController:
                FixedExtentScrollController(initialItem: _categoria),
            onSelectedItemChanged: (indice) {
              setState(() => _categoria = indice);
            },
            children: _categorias
                .map((c) => Center(child: Text(c['nombre'] as String)))
                .toList(),
          ),
        ),
      ),
    );
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;

    // Se construye un Map y desde él se crea el Producto
    final nuevoProducto = Producto.fromMap({
      'nombre': _nombreCtrl.text.trim(),
      'descripcion': _descripcionCtrl.text.trim(),
      'categoria': _categorias[_categoria]['nombre'],
      'precio': double.parse(_precioCtrl.text.trim()),
      'stock': int.parse(_stockCtrl.text.trim()),
      'icono': _categorias[_categoria]['icono'],
    });

    ProductosData.agregar(nuevoProducto);

    await mostrarAviso(
      context,
      titulo: 'Producto registrado',
      mensaje: '${nuevoProducto.nombre} se guardó correctamente.',
    );

    // Devuelve true para que la lista se actualice
    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final suave = AppTheme.color(context, AppTheme.textoSuave);

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Registrar Producto'),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Marcador de imagen
                    Container(
                      width: 150,
                      height: 110,
                      decoration: BoxDecoration(
                        color: AppTheme.color(context, AppTheme.relleno),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(CupertinoIcons.camera, size: 34, color: suave),
                          const SizedBox(height: 6),
                          Text(
                            'Seleccionar imagen',
                            style: TextStyle(fontSize: 12, color: suave),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),

                    CupertinoFormSection.insetGrouped(
                      header: const Text('Datos del producto'),
                      children: [
                        CupertinoTextFormFieldRow(
                          controller: _nombreCtrl,
                          prefix: const Text('Nombre'),
                          placeholder: 'Nombre del producto',
                          textAlign: TextAlign.end,
                          validator: (valor) =>
                              (valor == null || valor.trim().isEmpty)
                                  ? 'Ingresa el nombre'
                                  : null,
                        ),
                        CupertinoTextFormFieldRow(
                          controller: _descripcionCtrl,
                          prefix: const Text('Descripción'),
                          placeholder: 'Descripción breve',
                          textAlign: TextAlign.end,
                          validator: (valor) =>
                              (valor == null || valor.trim().isEmpty)
                                  ? 'Ingresa la descripción'
                                  : null,
                        ),
                        // Fila que abre el CupertinoPicker
                        CupertinoListTile(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          title: const Text('Categoría'),
                          additionalInfo: Text(
                            _categorias[_categoria]['nombre'] as String,
                          ),
                          trailing: const CupertinoListTileChevron(),
                          onTap: _elegirCategoria,
                        ),
                      ],
                    ),

                    CupertinoFormSection.insetGrouped(
                      header: const Text('Inventario'),
                      children: [
                        CupertinoTextFormFieldRow(
                          controller: _precioCtrl,
                          prefix: const Text('Precio (S/)'),
                          placeholder: '0.00',
                          textAlign: TextAlign.end,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          validator: (valor) {
                            if (valor == null || valor.trim().isEmpty) {
                              return 'Ingresa el precio';
                            }
                            final numero = double.tryParse(valor.trim());
                            if (numero == null) return 'Debe ser un número';
                            if (numero <= 0) return 'Debe ser mayor a 0';
                            return null;
                          },
                        ),
                        CupertinoTextFormFieldRow(
                          controller: _stockCtrl,
                          prefix: const Text('Stock'),
                          placeholder: '0',
                          textAlign: TextAlign.end,
                          keyboardType: TextInputType.number,
                          validator: (valor) {
                            if (valor == null || valor.trim().isEmpty) {
                              return 'Ingresa el stock';
                            }
                            final numero = int.tryParse(valor.trim());
                            if (numero == null) {
                              return 'Debe ser un número entero';
                            }
                            if (numero < 0) return 'No puede ser negativo';
                            return null;
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: SizedBox(
                        width: double.infinity,
                        child: CupertinoButton.filled(
                          onPressed: _guardar,
                          child: const Text(
                            'Guardar',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
