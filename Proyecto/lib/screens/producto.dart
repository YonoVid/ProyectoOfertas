import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:ofertas_flutter/screens/navigationDrawer.dart';

class Producto extends StatelessWidget {
  const Producto({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Producto'),
      ),
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(200),
            ),
            child: Center(
              child: Image.asset('assets/producto.jpg'),
            ),
          ),
          CardProduct(
              nameprod: 'Nombre Producto',
              prize: "\$1500",
              titledes: 'Descripción',
              description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
          ),
            Container(
            height: 50,
            width: 100,
            decoration: BoxDecoration(
                color: Colors.indigo, borderRadius: BorderRadius.circular(20)),
            child: TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Ir a la Tienda',
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
            ),
          ),
        ],
      ),

      drawer: NavDrawer(
        username: 'Nombre de usuario',
        email: 'Correo',
      ),
    );
  }
}

class CardProduct extends StatelessWidget {
  const CardProduct({Key? key,
    required this.nameprod, 
    required this.prize, 
    required this.titledes, 
    required this.description,
    //required this.RatingBar,
  })
      : super(key: key);

  final String nameprod;
  final String prize;
  final String titledes;
  final String description;
  //final Widget RatingBar;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.brown[50],
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                nameprod,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
                child: Text(
                  prize,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                titledes,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            Text(
              description,
              style: TextStyle(
                fontSize: 15,
              ),
            ),
          ],
        ),
    );
  }
}
