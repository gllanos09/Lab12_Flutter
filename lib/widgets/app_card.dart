import 'package:flutter/cupertino.dart';
import '../theme/app_theme.dart';

/// Card con estilo Cupertino.
/// La librería Cupertino no trae un widget Card, así que se construye uno
/// propio y reutilizable que toma sus colores del tema global.
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;

  const AppCard({
    super.key,
    required this.child,
    this.margin = const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppTheme.color(context, AppTheme.tarjeta),
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

/// Recuadro redondeado con un ícono, usado como `leading` en los ListTile.
class IconoCuadro extends StatelessWidget {
  final IconData icono;
  final Color color;
  final double size;

  const IconoCuadro({
    super.key,
    required this.icono,
    this.color = AppTheme.primario,
    this.size = 44,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(size * 0.24),
      ),
      child: Icon(icono, color: color, size: size * 0.52),
    );
  }
}
