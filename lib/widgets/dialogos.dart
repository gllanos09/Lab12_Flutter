import 'package:flutter/cupertino.dart';

/// Muestra un CupertinoAlertDialog informativo con un solo botón.
Future<void> mostrarAviso(
  BuildContext context, {
  required String titulo,
  required String mensaje,
}) {
  return showCupertinoDialog<void>(
    context: context,
    builder: (context) => CupertinoAlertDialog(
      title: Text(titulo),
      content: Text(mensaje),
      actions: [
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: () => Navigator.pop(context),
          child: const Text('Aceptar'),
        ),
      ],
    ),
  );
}

/// Muestra un CupertinoAlertDialog de confirmación.
/// Devuelve true si el usuario acepta.
Future<bool> confirmar(
  BuildContext context, {
  required String titulo,
  required String mensaje,
  String textoAceptar = 'Aceptar',
  bool destructivo = false,
}) async {
  final respuesta = await showCupertinoDialog<bool>(
    context: context,
    builder: (context) => CupertinoAlertDialog(
      title: Text(titulo),
      content: Text(mensaje),
      actions: [
        CupertinoDialogAction(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancelar'),
        ),
        CupertinoDialogAction(
          isDestructiveAction: destructivo,
          isDefaultAction: !destructivo,
          onPressed: () => Navigator.pop(context, true),
          child: Text(textoAceptar),
        ),
      ],
    ),
  );
  return respuesta ?? false;
}
