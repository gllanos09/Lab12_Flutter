import 'package:flutter/cupertino.dart';
import '../models/producto.dart';
import '../routes/app_routes.dart';

/// Lista de mapas con los productos iniciales.
final List<Map<String, dynamic>> productosIniciales = [
  {
    'nombre': 'Laptop',
    'descripcion': 'Laptop 14 pulgadas, 16GB RAM',
    'categoria': 'Cómputo',
    'precio': 3500.00,
    'stock': 10,
    'icono': CupertinoIcons.device_laptop,
  },
  {
    'nombre': 'Mouse',
    'descripcion': 'Mouse inalámbrico ergonómico',
    'categoria': 'Periféricos',
    'precio': 50.00,
    'stock': 25,
    'icono': CupertinoIcons.cursor_rays,
  },
  {
    'nombre': 'Teclado',
    'descripcion': 'Teclado mecánico retroiluminado',
    'categoria': 'Periféricos',
    'precio': 120.00,
    'stock': 15,
    'icono': CupertinoIcons.keyboard,
  },
  {
    'nombre': 'Monitor',
    'descripcion': 'Monitor LED 24 pulgadas Full HD',
    'categoria': 'Cómputo',
    'precio': 800.00,
    'stock': 8,
    'icono': CupertinoIcons.desktopcomputer,
  },
  {
    'nombre': 'Audífonos',
    'descripcion': 'Audífonos con cancelación de ruido',
    'categoria': 'Audio',
    'precio': 250.00,
    'stock': 0,
    'icono': CupertinoIcons.headphones,
  },
];

/// Repositorio en memoria de los productos.
class ProductosData {
  /// Lista de objetos Producto construida a partir de la lista de mapas.
  static final List<Producto> productos =
      productosIniciales.map((mapa) => Producto.fromMap(mapa)).toList();

  static void agregar(Producto producto) => productos.add(producto);

  static void eliminar(Producto producto) => productos.remove(producto);

  static int get total => productos.length;

  static int get agotados => productos.where((p) => !p.hayStock).length;

  /// Suma del valor del inventario (precio x stock de cada producto).
  static double get valorInventario =>
      productos.fold(0, (suma, p) => suma + p.precio * p.stock);
}

/// Lista de mapas con las opciones del menú principal.
final List<Map<String, dynamic>> opcionesMenu = [
  {
    'titulo': 'Registrar Productos',
    'subtitulo': 'Agrega un producto al inventario',
    'icono': CupertinoIcons.cart_badge_plus,
    'ruta': AppRoutes.registrar,
  },
  {
    'titulo': 'Listar Productos',
    'subtitulo': 'Consulta, busca y elimina productos',
    'icono': CupertinoIcons.list_bullet,
    'ruta': AppRoutes.productos,
  },
  {
    'titulo': 'Perfil',
    'subtitulo': 'Tus datos y preferencias',
    'icono': CupertinoIcons.person_fill,
    'ruta': AppRoutes.perfil,
  },
];

/// Mapa con los filtros del listado (clave -> etiqueta).
const Map<int, String> filtrosStock = {
  0: 'Todos',
  1: 'Disponibles',
  2: 'Agotados',
};

/// Mapa con los datos del usuario logueado.
final Map<String, String> usuarioActual = {
  'nombre': 'Juan Pérez',
  'email': 'juan.perez@correo.com',
  'telefono': '987654321',
  'rol': 'Administrador',
};
