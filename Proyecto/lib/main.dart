import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:ofertas_flutter/app_state.dart';
import 'package:ofertas_flutter/screens/home.dart';
import 'package:ofertas_flutter/screens/login.dart';
import 'package:ofertas_flutter/screens/agregar_oferta.dart';
import 'package:ofertas_flutter/screens/registro.dart';
import 'package:ofertas_flutter/screens/ofertas.dart';
import 'package:ofertas_flutter/screens/soporte.dart';
import 'package:ofertas_flutter/screens/preguntas.dart';
import 'package:ofertas_flutter/screens/opciones.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppState(),
      builder: (context, _) => OfertasFlutter(),
    ),
  );
}
class OfertasFlutter extends StatelessWidget {
  @override
    Widget build(BuildContext context) => MaterialApp(
  initialRoute: '/login',
  routes:
   {
      '/': (context) => const Home(),
      '/login': (context) => Login(),
      '/register': (context) => Register(),
      '/ofertas': (context) => Ofertas(),
      '/soporte': (context) => Soporte(),
      '/preguntas': (context) => Preguntas(),
      '/opciones': (context) => Opciones(),
      '/agregar_oferta': (context) => AgregarOferta(),
    },
    theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.indigo
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.indigo[600], // Background color (orange in my case).
          textTheme: ButtonTextTheme.accent,
          colorScheme:
          Theme.of(context).colorScheme.copyWith(secondary: Colors.white), // Text color
        ),
        canvasColor: Colors.brown[200]
    ),
    /*
    theme: ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.indigo[500],
      primarySwatch: Colors.indigo,
      fontFamily: 'MontserratAlternate',
      textTheme: TextTheme(
        headline1: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
        headline6: TextStyle(fontSize: 30.0, fontStyle: FontStyle.italic),
        bodyText2: TextStyle(fontSize: 18.0, fontFamily: 'Hind'),
      ),
    ),
     */
  );
}
