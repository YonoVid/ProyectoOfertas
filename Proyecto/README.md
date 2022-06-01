# ofertas_flutter

Proyecto de ofertas

## Configurando Flutter

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Configurando Firebase

Primero, para poder comenzar a desarrollar con firebase debes instalar las
herramientas necesarias para su funcionamiento.

### Instalar la herramienta de consola Firebase cli
1. [Descarga la herramienta](https://firebase.google.com/docs/cli#setup_update_cli)
2. Ingresa con el correo del equipo (lostresalgoingenioso@gmail.com) utilizando el commando:
```
Firebase login
```
3. Instala la herramienta FlutterFire CLI
```
dart pub global activate flutterfire_cli
```
### Inicar en la applicación (necesario si no se ha agregado al proyecto)

\#**Actualmente este paso no es necesario para iniciar el proyecto, pero puede ser de ayuda si se ha editado la configuracion de Firebase**.
1. Usar comando en la aplicación del proyecto
```
carpeta_del_proyecto] flutterfire configure
```
2. Importar las librerias y configuración generada en el paso anterior
```
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
```
3. En el archivo lib/main.dart se debe iniciar Firebase
```
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
```
Para evitar errores de sincronización (puede presentarse como pantallas negras) puedes agregar esta línea antes de iniciar Firebase\
\# `WidgetsFlutterBinding.ensureInitialized();`
4. Reconstruye la aplicación
```
carpeta_del_proyecto] flutter run
```

\# Pueden ocurrir errores al exeder el tamaño del dex de la aplicación (porque se importan muchas clases) se puede agregar una línea a android/app/build.gradle
```
    defaultConfig {
        //Añadir esta línea
        multiDexEnabled true
    }
```

Como referencia puedes acceder a la [documentación official de firebase
para contectarse con flutter] ([https://flutter.dev/docs](https://firebase.google.com/docs/flutter/setup?platform=android)
