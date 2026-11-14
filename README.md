# Lab12 — Gestión de Productos con widgets Cupertino

Aplicación móvil desarrollada en **Flutter** usando la librería **Cupertino** (estilo iOS).
Es la continuación del [Lab08](https://github.com/gllanos09/Lab08-Multi): la misma app de inventario, reescrita por completo con widgets Cupertino en lugar de Material.

El objetivo del laboratorio es comprender, utilizar y crear, con widgets de Cupertino:

- ListViews
- ListTiles
- Listas y Mapas
- Rutas
- Tema Global
- Cards

---

## Descripción

La aplicación simula un sistema de gestión de inventario con seis pantallas: login, menú principal, listado de productos con búsqueda y filtro, detalle de producto, registro de productos y perfil de usuario editable con modo oscuro.

Los datos se manejan en memoria mediante listas de mapas, sin conexión a base de datos. Ningún archivo importa `material.dart`: toda la interfaz usa `package:flutter/cupertino.dart`.

---

## De Material (Lab08) a Cupertino (Lab12)

| Lab08 — Material | Lab12 — Cupertino |
|---|---|
| `MaterialApp` | `CupertinoApp` |
| `ThemeData` | `CupertinoThemeData` |
| `Scaffold` + `AppBar` | `CupertinoPageScaffold` + `CupertinoNavigationBar` |
| `ListTile` | `CupertinoListTile` / `CupertinoListTile.notched` |
| `Card` | `AppCard` (widget propio) y `CupertinoListSection.insetGrouped` |
| `TextFormField` | `CupertinoTextFormFieldRow` dentro de `CupertinoFormSection` |
| `TextField` de búsqueda | `CupertinoSearchTextField` |
| `ElevatedButton` / `TextButton` | `CupertinoButton.filled` / `CupertinoButton` |
| `AlertDialog` | `CupertinoAlertDialog` |
| `PopupMenuButton` | `CupertinoActionSheet` |
| `SnackBar` | `CupertinoAlertDialog` de aviso |
| `Icons` | `CupertinoIcons` |
| — | `CupertinoSlidingSegmentedControl`, `CupertinoPicker`, `CupertinoSwitch` |

---

## Requisitos

| Herramienta | Versión |
|---|---|
| Flutter SDK | Canal stable |
| Dart SDK | Incluido con Flutter |
| Git | Cualquier versión reciente |
| Navegador | Google Chrome (para ejecución web) |

---

## Instalación y ejecución

```bash
git clone https://github.com/USUARIO/REPOSITORIO.git
cd REPOSITORIO
flutter pub get
flutter run -d chrome
```

Para entrar, cualquier email con `@` y una contraseña de 4 caracteres o más.

---

## Estructura del proyecto

```
lib/
├── data/
│   └── productos_data.dart            Listas de mapas y repositorio en memoria
├── models/
│   └── producto.dart                  Modelo Producto con fromMap() y toMap()
├── routes/
│   └── app_routes.dart                Definición centralizada de rutas nombradas
├── screens/
│   ├── login_screen.dart              Pantalla 1 — Login
│   ├── menu_screen.dart               Pantalla 2 — Menú
│   ├── listar_productos_screen.dart   Pantalla 3 — Listar Productos
│   ├── detalle_producto_screen.dart   Pantalla 4 — Detalle de Producto
│   ├── registrar_producto_screen.dart Pantalla 5 — Registrar Producto
│   └── perfil_screen.dart             Pantalla 6 — Perfil
├── theme/
│   └── app_theme.dart                 Tema global (CupertinoThemeData)
├── widgets/
│   ├── app_card.dart                  Card e ícono reutilizables estilo iOS
│   └── dialogos.dart                  Diálogos de aviso y confirmación
└── main.dart                          Punto de entrada (CupertinoApp)
```

---

## Conceptos aplicados

### ListViews

- `ListView` en Menú, Detalle y Perfil, combinando Cards y secciones de lista.
- `ListView.builder` en Productos: construye cada fila bajo demanda según el índice.

### ListTiles

Se usa `CupertinoListTile` como fila base de todas las listas, con sus propiedades:

- `leading` — ícono o recuadro a la izquierda
- `title` y `subtitle` — texto principal y secundario
- `additionalInfo` — dato a la derecha (precio, valor del perfil)
- `trailing` — `CupertinoListTileChevron`, botón de acciones o `CupertinoSwitch`
- `onTap` — navegación al tocar la fila

`CupertinoListSection.insetGrouped` agrupa los tiles en bloques redondeados con encabezado.

### Listas y Mapas

- `productosIniciales` es una `List<Map<String, dynamic>>`; `Producto.fromMap()` convierte cada mapa en un objeto tipado.
- `opcionesMenu` genera los tiles del menú desde una lista de mapas (título, subtítulo, ícono y ruta).
- `filtrosStock` es un `Map<int, String>` del que se construye el control segmentado.
- `usuarioActual` es un `Map<String, String>` que se actualiza al editar el perfil.
- En Detalle, `producto.toMap()` vuelve el objeto a mapa para armar las filas.
- Operaciones sobre colecciones: `map()`, `where()` y `fold()` (valor total del inventario).

### Rutas

Rutas nombradas definidas en `AppRoutes` y registradas en `CupertinoApp`, que las abre con la transición deslizante de iOS:

| Ruta | Pantalla |
|---|---|
| `/` | Login |
| `/menu` | Menú |
| `/productos` | Listar Productos |
| `/detalle` | Detalle de Producto |
| `/registrar` | Registrar Producto |
| `/perfil` | Perfil |

Métodos de navegación utilizados:

- `Navigator.pushNamed()` — abre una pantalla conservando el historial
- `Navigator.pushNamed(..., arguments: producto)` — envía el producto a la pantalla de detalle
- `Navigator.pushReplacementNamed()` — reemplaza la pantalla actual (login → menú)
- `Navigator.pushNamedAndRemoveUntil()` — limpia el historial al cerrar sesión
- `Navigator.pop(context, valor)` — retorna un resultado a la pantalla anterior

### Tema Global

Definido en `AppTheme.tema()` y aplicado desde `CupertinoApp` con `CupertinoThemeData`:

- `primaryColor` — color de botones, íconos de los tiles, switches y enlaces
- `scaffoldBackgroundColor` y `barBackgroundColor` — fondo de pantallas y barra de navegación
- `brightness` — modo claro u oscuro
- Colores dinámicos (`CupertinoDynamicColor`) que se adaptan solos a cada modo

El interruptor **Modo oscuro** del Perfil cambia `AppTheme.brillo` (un `ValueNotifier`) y toda la aplicación se redibuja con el nuevo tema, sin tocar cada pantalla.

### Cards

Cupertino no incluye un widget `Card`, así que se creó `AppCard`: un contenedor reutilizable con bordes redondeados y sombra suave que toma su color del tema global. Se usa para el resumen del menú, cada producto del listado y las cabeceras de Detalle y Perfil.

---

## Funcionalidades

- Login con validación de email y contraseña, y opción de mostrar la contraseña
- Menú con resumen del inventario (productos, agotados y valor total)
- Listado de productos con búsqueda en tiempo real y filtro por stock
- Indicador visual para productos agotados
- Detalle de cada producto
- Registro de productos con validación y selector de categoría
- Eliminación de productos con confirmación
- Perfil con edición de nombre, email y teléfono
- Modo claro y oscuro
- Cierre de sesión con limpieza del historial de navegación

---

## Autor

Gabriel — TECSUP, Diseño y Desarrollo de Software
