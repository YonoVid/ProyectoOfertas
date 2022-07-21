import 'package:flutter/material.dart';
import 'package:ofertas_flutter/screens/agregar_local.dart';
import 'package:ofertas_flutter/screens/filtro_ofertas.dart';
import 'package:ofertas_flutter/screens/gestionar_local.dart';
import 'package:ofertas_flutter/screens/local_ofertas.dart';
import 'package:ofertas_flutter/screens/manejo_local.dart';
import 'package:ofertas_flutter/screens/reporte.dart';
import 'package:provider/provider.dart';

import 'package:ofertas_flutter/providers/app_state.dart';
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
  // Avoid errors caused by flutter upgrade.
  // Importing 'package:flutter/widgets.dart' is required.
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
      '/filtro_ofertas': (context) => FiltroOfertas(),
      '/ofertas_local': (context) => OfertasLocal(),
      '/manejo_local': (context) => ManejoLocal(),
      '/gestionar_local': (context) => GestionarLocal(),
      '/soporte': (context) => Soporte(),
      '/preguntas': (context) => Preguntas(),
      '/opciones': (context) => Opciones(),
      '/agregar_local': (context) => AgregarLocal(),
      '/agregar_oferta': (context) => AgregarOferta(),
      '/reporte': (context) => Reporte(),
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
        iconTheme: IconThemeData(
          color: Colors.brown[50]
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
