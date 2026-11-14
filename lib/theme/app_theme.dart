import 'package:flutter/cupertino.dart';

/// Tema global de la aplicación (estilo Cupertino / iOS).
/// Centraliza colores, tipografía y el modo claro / oscuro.
class AppTheme {
  // Paleta de la aplicación
  static const Color primario = Color(0xFF1877F2);
  static const Color exito = CupertinoColors.systemGreen;
  static const Color error = CupertinoColors.systemRed;

  // Colores dinámicos: cambian solos entre modo claro y oscuro
  static const CupertinoDynamicColor fondo =
      CupertinoColors.systemGroupedBackground;
  static const CupertinoDynamicColor tarjeta =
      CupertinoColors.secondarySystemGroupedBackground;
  static const CupertinoDynamicColor texto = CupertinoColors.label;
  static const CupertinoDynamicColor textoSuave =
      CupertinoColors.secondaryLabel;
  static const CupertinoDynamicColor relleno =
      CupertinoColors.tertiarySystemFill;

  /// Brillo actual del tema. Al cambiarlo se redibuja toda la app.
  static final ValueNotifier<Brightness> brillo =
      ValueNotifier<Brightness>(Brightness.light);

  static bool get esOscuro => brillo.value == Brightness.dark;

  static void cambiarModo({required bool oscuro}) {
    brillo.value = oscuro ? Brightness.dark : Brightness.light;
  }

  /// Resuelve un color dinámico según el tema activo del contexto.
  static Color color(BuildContext context, Color color) =>
      CupertinoDynamicColor.resolve(color, context);

  /// Construye el tema global que recibe CupertinoApp.
  static CupertinoThemeData tema(Brightness brillo) {
    return CupertinoThemeData(
      brightness: brillo,
      primaryColor: primario,
      scaffoldBackgroundColor: fondo,
      barBackgroundColor: tarjeta,
      applyThemeToAll: true,
      textTheme: const CupertinoTextThemeData(primaryColor: primario),
    );
  }
}
