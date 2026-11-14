import 'package:flutter/cupertino.dart';
import '../screens/detalle_producto_screen.dart';
import '../screens/listar_productos_screen.dart';
import '../screens/login_screen.dart';
import '../screens/menu_screen.dart';
import '../screens/perfil_screen.dart';
import '../screens/registrar_producto_screen.dart';

/// Definición centralizada de las rutas nombradas.
/// CupertinoApp las abre con CupertinoPageRoute (transición estilo iOS).
class AppRoutes {
  static const String login = '/';
  static const String menu = '/menu';
  static const String productos = '/productos';
  static const String registrar = '/registrar';
  static const String detalle = '/detalle';
  static const String perfil = '/perfil';

  static Map<String, WidgetBuilder> get rutas => {
        login: (context) => const LoginScreen(),
        menu: (context) => const MenuScreen(),
        productos: (context) => const ListarProductosScreen(),
        registrar: (context) => const RegistrarProductoScreen(),
        // Recibe el Producto mediante los argumentos de la ruta
        detalle: (context) => const DetalleProductoScreen(),
        perfil: (context) => const PerfilScreen(),
      };
}
