import 'package:flutter/cupertino.dart';

/// Modelo de datos de un producto.
/// Incluye conversión desde y hacia Map (mapas).
class Producto {
  final String nombre;
  final String descripcion;
  final String categoria;
  final double precio;
  final int stock;
  final IconData icono;

  Producto({
    required this.nombre,
    required this.descripcion,
    required this.precio,
    required this.stock,
    this.categoria = 'General',
    this.icono = CupertinoIcons.cube_box,
  });

  /// Crea un Producto a partir de un Map.
  factory Producto.fromMap(Map<String, dynamic> map) {
    return Producto(
      nombre: map['nombre'] as String,
      descripcion: map['descripcion'] as String? ?? '',
      categoria: map['categoria'] as String? ?? 'General',
      precio: (map['precio'] as num).toDouble(),
      stock: map['stock'] as int,
      icono: map['icono'] as IconData? ?? CupertinoIcons.cube_box,
    );
  }

  /// Convierte el Producto a un Map.
  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'descripcion': descripcion,
      'categoria': categoria,
      'precio': precio,
      'stock': stock,
      'icono': icono,
    };
  }

  /// Precio formateado en soles.
  String get precioFormateado => 'S/ ${precio.toStringAsFixed(2)}';

  bool get hayStock => stock > 0;
}
