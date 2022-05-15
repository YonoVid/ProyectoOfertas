import 'package:flutter/material.dart';
import 'package:ofertas_flutter/screens/home.dart';
import 'package:ofertas_flutter/screens/login.dart';
import 'package:ofertas_flutter/screens/example.dart';
import 'package:ofertas_flutter/screens/register.dart';
import 'package:ofertas_flutter/screens/ofertas.dart';
import 'package:ofertas_flutter/screens/soporte.dart';
import 'package:ofertas_flutter/screens/preguntas.dart';
import 'package:ofertas_flutter/screens/producto.dart';

void main() => runApp(MaterialApp(
    initialRoute: '/login',
    routes: {
      '/': (context) => const Home(),
      '/login': (context) => Login(),
      '/register': (context) => Register(),
      '/ofertas': (context) => Ofertas(),
      '/soporte': (context) => Soporte(),
      '/preguntas': (context) => Preguntas(),
      '/producto': (context) => Producto(),
      '/example': (context) => Example(),
    },
    theme: ThemeData(
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: Colors.indigo
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
));

