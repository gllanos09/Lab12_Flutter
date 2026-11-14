import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:lab12_cupertino/data/productos_data.dart';
import 'package:lab12_cupertino/main.dart';

Future<void> _login(WidgetTester tester) async {
  await tester.pumpWidget(const MyApp());
  await tester.enterText(
    find.byType(CupertinoTextFormFieldRow).at(0),
    'juan@correo.com',
  );
  await tester.enterText(find.byType(CupertinoTextFormFieldRow).at(1), '1234');
  await tester.tap(find.text('Ingresar'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('El login valida los campos vacíos', (tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('Ingresar'));
    await tester.pumpAndSettle();

    expect(find.text('Ingresa tu email'), findsOneWidget);
    expect(find.text('Ingresa tu contraseña'), findsOneWidget);
  });

  testWidgets('Login correcto abre el menú con sus opciones', (tester) async {
    await _login(tester);

    expect(find.text('Menú'), findsOneWidget);
    for (final opcion in opcionesMenu) {
      expect(find.text(opcion['titulo'] as String), findsOneWidget);
    }
  });

  testWidgets('El listado muestra los productos y abre el detalle',
      (tester) async {
    await _login(tester);

    await tester.tap(find.text('Listar Productos'));
    await tester.pumpAndSettle();

    expect(find.text('Laptop'), findsOneWidget);
    expect(find.text('Agotado'), findsOneWidget);

    // Filtro "Agotados": solo queda el producto sin stock
    await tester.tap(find.text('Agotados'));
    await tester.pumpAndSettle();
    expect(find.text('Laptop'), findsNothing);
    expect(find.text('Audífonos'), findsOneWidget);

    await tester.tap(find.text('Audífonos'));
    await tester.pumpAndSettle();
    expect(find.text('Detalle'), findsOneWidget);
    expect(find.text('Audio'), findsOneWidget);
  });

  testWidgets('Registrar un producto lo agrega al repositorio',
      (tester) async {
    final totalInicial = ProductosData.total;
    await _login(tester);

    await tester.tap(find.text('Registrar Productos'));
    await tester.pumpAndSettle();

    final campos = find.byType(CupertinoTextFormFieldRow);
    await tester.enterText(campos.at(0), 'Webcam');
    await tester.enterText(campos.at(1), 'Webcam HD 1080p');
    await tester.enterText(campos.at(2), '180');
    await tester.enterText(campos.at(3), '5');
    await tester.ensureVisible(find.text('Guardar'));
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();

    expect(find.text('Producto registrado'), findsOneWidget);
    expect(ProductosData.total, totalInicial + 1);
    expect(ProductosData.productos.last.nombre, 'Webcam');
  });
}
