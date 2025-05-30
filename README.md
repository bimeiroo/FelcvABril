# FELCV - Sistema de Gestión de Denuncias

Sistema para registro y seguimiento de denuncias para la Fuerza Especial de Lucha Contra la Violencia (FELCV).

## Configuración del Proyecto

### Requisitos

- Flutter SDK 3.29.1 o superior
- Dart SDK 3.7.0 o superior
- Android Studio 2023.1.1 o superior (para desarrollo en Android)
- VS Code (opcional, para desarrollo general)
- Java JDK 11 o superior

### Pasos para ejecutar en Android Studio

1. **Clonar el repositorio**
   ```
   git clone [URL_DEL_REPOSITORIO]
   cd felcv
   ```

2. **Obtener dependencias**
   ```
   flutter pub get
   ```

3. **Abrir en Android Studio**
   - Abrir Android Studio
   - Seleccionar "Open an existing project"
   - Navegar y seleccionar la carpeta del proyecto "felcv"

4. **Configurar Emulador o Dispositivo**
   - Configurar un emulador Android desde AVD Manager
   - O conectar un dispositivo físico Android con modo desarrollador activado

5. **Ejecutar la aplicación**
   - Seleccionar el dispositivo/emulador de la lista desplegable
   - Hacer clic en el botón "Run" (▶)

## Características

- Registro de denuncias con datos del denunciante, denunciado y detalles del caso
- Captura de imágenes como evidencia
- Generación de PDFs para reportes de denuncias
- Seguimiento del estado de denuncias
- Autenticación de usuarios
- Mapa para ubicación de hechos

## Permisos necesarios

La aplicación requiere los siguientes permisos:
- Almacenamiento (lectura/escritura)
- Cámara
- Ubicación
- Internet

## Solución de problemas

### Error en generación de PDF
Si experimenta problemas al generar PDFs en Android:
1. Verifique que ha concedido los permisos de almacenamiento
2. Para Android 10+, la aplicación intentará solicitar permisos adicionales
3. Si persisten los problemas, intente utilizar la ruta de almacenamiento temporal

### Problemas en plataforma web
- La aplicación implementa diferentes métodos para cada plataforma
- En web, se utiliza `printing` para generar PDFs directamente sin acceso a almacenamiento

## Desarrollo

El proyecto está organizado de la siguiente manera:
- `lib/models`: Modelos de datos
- `lib/screens`: Pantallas de la aplicación
- `lib/services`: Servicios para manejar operaciones como PDF, autenticación, etc.
- `lib/widgets`: Widgets reutilizables

## Licencia

Este proyecto está bajo licencia [ESPECIFICAR_LICENCIA]
#   F e l c v A B r i l 
 
 