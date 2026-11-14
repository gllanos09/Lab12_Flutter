import 'package:flutter/cupertino.dart';
import '../data/productos_data.dart';
import '../theme/app_theme.dart';
import '../widgets/app_card.dart';
import '../widgets/dialogos.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  /// Abre el diálogo de edición y actualiza el mapa usuarioActual.
  Future<void> _editarPerfil() async {
    final nombreCtrl = TextEditingController(text: usuarioActual['nombre']);
    final emailCtrl = TextEditingController(text: usuarioActual['email']);
    final telefonoCtrl = TextEditingController(text: usuarioActual['telefono']);
    String? error;

    final guardado = await showCupertinoDialog<bool>(
      context: context,
      builder: (context) {
        // StatefulBuilder permite mostrar el error dentro del diálogo
        return StatefulBuilder(
          builder: (context, setDialogState) {
            String? validar() {
              if (nombreCtrl.text.trim().isEmpty) return 'Ingresa el nombre';
              if (!emailCtrl.text.contains('@')) return 'Email no válido';
              if (telefonoCtrl.text.trim().length < 6) {
                return 'Teléfono no válido';
              }
              return null;
            }

            return CupertinoAlertDialog(
              title: const Text('Editar Perfil'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 12),
                  CupertinoTextField(
                    controller: nombreCtrl,
                    placeholder: 'Nombre',
                    prefix: const _PrefijoCampo(CupertinoIcons.person),
                  ),
                  const SizedBox(height: 8),
                  CupertinoTextField(
                    controller: emailCtrl,
                    placeholder: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    prefix: const _PrefijoCampo(CupertinoIcons.mail),
                  ),
                  const SizedBox(height: 8),
                  CupertinoTextField(
                    controller: telefonoCtrl,
                    placeholder: 'Teléfono',
                    keyboardType: TextInputType.phone,
                    prefix: const _PrefijoCampo(CupertinoIcons.phone),
                  ),
                  if (error != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      error!,
                      style: const TextStyle(
                        color: AppTheme.error,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ],
              ),
              actions: [
                CupertinoDialogAction(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancelar'),
                ),
                CupertinoDialogAction(
                  isDefaultAction: true,
                  onPressed: () {
                    final resultado = validar();
                    if (resultado == null) {
                      Navigator.pop(context, true);
                    } else {
                      setDialogState(() => error = resultado);
                    }
                  },
                  child: const Text('Guardar'),
                ),
              ],
            );
          },
        );
      },
    );

    if (guardado == true && mounted) {
      // Actualiza el mapa y redibuja la pantalla
      setState(() {
        usuarioActual['nombre'] = nombreCtrl.text.trim();
        usuarioActual['email'] = emailCtrl.text.trim();
        usuarioActual['telefono'] = telefonoCtrl.text.trim();
      });

      await mostrarAviso(
        context,
        titulo: 'Perfil actualizado',
        mensaje: 'Tus datos se guardaron correctamente.',
      );
    }

    nombreCtrl.dispose();
    emailCtrl.dispose();
    telefonoCtrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final suave = AppTheme.color(context, AppTheme.textoSuave);

    // Lista de mapas con las filas de datos del perfil
    final datosPerfil = [
      {
        'icono': CupertinoIcons.person,
        'etiqueta': 'Nombre',
        'valor': usuarioActual['nombre']!,
      },
      {
        'icono': CupertinoIcons.mail,
        'etiqueta': 'Email',
        'valor': usuarioActual['email']!,
      },
      {
        'icono': CupertinoIcons.phone,
        'etiqueta': 'Teléfono',
        'valor': usuarioActual['telefono']!,
      },
      {
        'icono': CupertinoIcons.gear,
        'etiqueta': 'Rol',
        'valor': usuarioActual['rol']!,
      },
    ];

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Perfil'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: _editarPerfil,
          child: const Text('Editar'),
        ),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 12),
          children: [
            // Card de cabecera con el avatar
            AppCard(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 16),
              child: Column(
                children: [
                  Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      color: AppTheme.primario.withValues(alpha: 0.14),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      CupertinoIcons.person_fill,
                      size: 52,
                      color: AppTheme.primario,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    usuarioActual['nombre']!,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(usuarioActual['email']!, style: TextStyle(color: suave)),
                ],
              ),
            ),

            // Un CupertinoListTile por cada mapa de datosPerfil
            CupertinoListSection.insetGrouped(
              header: const Text('Datos personales'),
              children: datosPerfil.map((dato) {
                return CupertinoListTile(
                  leading: Icon(dato['icono'] as IconData),
                  title: Text(dato['etiqueta'] as String),
                  additionalInfo: Text(dato['valor'] as String),
                );
              }).toList(),
            ),

            // Preferencia que modifica el tema global de toda la app
            CupertinoListSection.insetGrouped(
              header: const Text('Apariencia'),
              children: [
                CupertinoListTile(
                  leading: const Icon(CupertinoIcons.moon_fill),
                  title: const Text('Modo oscuro'),
                  trailing: CupertinoSwitch(
                    value: AppTheme.esOscuro,
                    onChanged: (valor) {
                      setState(() => AppTheme.cambiarModo(oscuro: valor));
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PrefijoCampo extends StatelessWidget {
  final IconData icono;

  const _PrefijoCampo(this.icono);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Icon(
        icono,
        size: 18,
        color: AppTheme.color(context, AppTheme.textoSuave),
      ),
    );
  }
}
