import 'package:flutter/cupertino.dart';
import 'routes/app_routes.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Escucha el brillo del tema: al cambiarlo se reconstruye CupertinoApp
    return ValueListenableBuilder<Brightness>(
      valueListenable: AppTheme.brillo,
      builder: (context, brillo, _) {
        return CupertinoApp(
          title: 'Lab12 - Gestión de Productos',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.tema(brillo),
          initialRoute: AppRoutes.login,
          routes: AppRoutes.rutas,
        );
      },
    );
  }
}
