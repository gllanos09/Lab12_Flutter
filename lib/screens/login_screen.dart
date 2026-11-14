import 'package:flutter/cupertino.dart';
import '../routes/app_routes.dart';
import '../theme/app_theme.dart';
import '../widgets/app_card.dart';
import '../widgets/dialogos.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _mostrarPass = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _iniciarSesion() {
    if (_formKey.currentState!.validate()) {
      // Navega al menú y elimina el login del historial
      Navigator.pushReplacementNamed(context, AppRoutes.menu);
    }
  }

  @override
  Widget build(BuildContext context) {
    final suave = AppTheme.color(context, AppTheme.textoSuave);

    return CupertinoPageScaffold(
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const IconoCuadro(icono: CupertinoIcons.bag_fill, size: 84),
                  const SizedBox(height: 20),
                  const Text(
                    'Iniciar Sesión',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Ingresa tus credenciales para continuar',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: suave),
                  ),
                  const SizedBox(height: 18),

                  // Formulario agrupado estilo iOS
                  Form(
                    key: _formKey,
                    child: CupertinoFormSection.insetGrouped(
                      children: [
                        CupertinoTextFormFieldRow(
                          controller: _emailCtrl,
                          prefix: Icon(CupertinoIcons.mail, color: suave),
                          placeholder: 'Email',
                          keyboardType: TextInputType.emailAddress,
                          autocorrect: false,
                          validator: (valor) {
                            if (valor == null || valor.trim().isEmpty) {
                              return 'Ingresa tu email';
                            }
                            if (!valor.contains('@')) {
                              return 'Email no válido';
                            }
                            return null;
                          },
                        ),
                        CupertinoTextFormFieldRow(
                          controller: _passCtrl,
                          prefix: Icon(CupertinoIcons.lock, color: suave),
                          placeholder: 'Password',
                          obscureText: !_mostrarPass,
                          validator: (valor) {
                            if (valor == null || valor.isEmpty) {
                              return 'Ingresa tu contraseña';
                            }
                            if (valor.length < 4) {
                              return 'Mínimo 4 caracteres';
                            }
                            return null;
                          },
                        ),
                        CupertinoFormRow(
                          prefix: const Text('Mostrar contraseña'),
                          child: CupertinoSwitch(
                            value: _mostrarPass,
                            onChanged: (valor) {
                              setState(() => _mostrarPass = valor);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SizedBox(
                      width: double.infinity,
                      child: CupertinoButton.filled(
                        onPressed: _iniciarSesion,
                        child: const Text(
                          'Ingresar',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                  CupertinoButton(
                    onPressed: () => mostrarAviso(
                      context,
                      titulo: 'Recuperar contraseña',
                      mensaje: 'Función no implementada.',
                    ),
                    child: const Text('¿Olvidaste tu contraseña?'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
