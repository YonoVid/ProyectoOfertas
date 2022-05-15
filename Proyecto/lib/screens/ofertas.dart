import 'package:flutter/material.dart';
import 'package:ofertas_flutter/screens/navigationDrawer.dart';

class Ofertas extends StatefulWidget {
  const Ofertas({Key? key}) : super(key: key);

  @override
  State<Ofertas> createState() => _OfertasState();
}

class _OfertasState extends State<Ofertas> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("OFERTAS"),
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.monetization_on_rounded)),
              Tab(icon: Icon(Icons.favorite_rounded)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            OfertasBusqueda(),
            OfertasBusqueda(),
          ],
        ),
        drawer: NavDrawer(
          username: 'Nombre de usuario',
          email: 'Correo',
        ),
      ),
    );
  }
}

class OfertasBusqueda extends StatefulWidget {
  const OfertasBusqueda({Key? key}) : super(key: key);

  @override
  State<OfertasBusqueda> createState() => _OfertasBusquedaState();
}

class _OfertasBusquedaState extends State<OfertasBusqueda> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListOfertas(
          thumbnail: Container(
            decoration: const BoxDecoration(color: Colors.yellow),
            child: Icon(Icons.emoji_food_beverage_rounded),
          ),
          title: TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/producto');
            },
            child: const Text(
              'Prueba Producto',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 14),
            ),
          ),
          price: "\$500",
        ),
        ListOfertas(
          thumbnail: Container(
            decoration: const BoxDecoration(color: Colors.white),
            child: Icon(Icons.emoji_food_beverage_rounded),
          ),
          title: TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/producto');
            },
            child: const Text(
              'Prueba Producto',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 14),
            ),
          ),
          price: "\$500",
        ),
        ListOfertas(
          thumbnail: Container(
            decoration: const BoxDecoration(color: Colors.white),
            child: Icon(Icons.emoji_food_beverage_rounded),
          ),
          title: TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/producto');
            },
            child: const Text(
              'Prueba Producto',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 14),
            ),
          ),
          price: "\$500",
        ),
      ],
    );
  }
}

class ListOfertas extends StatelessWidget {
  const ListOfertas({
    Key? key,
    required this.thumbnail,
    required this.title,
    required this.price,
  }) : super(key: key);

  final Widget thumbnail;
  final Widget title;
  final String price;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: thumbnail,
          ),
          Expanded(
            flex: 3,
            child: _OfertasDatos(name: title, price: price),
          ),
        ],
      ),
    );
  }
}

class _OfertasDatos extends StatelessWidget {
  const _OfertasDatos({
    Key? key,
    required this.name,
    required this.price,
  }) : super(key: key);

  final Widget name;
  final String price;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
      child: Column(
        children: [
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/producto');
            },
            child: const Text(
              'Prueba Producto',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 14),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 2.0),
            child: Text(
              price,
              style: TextStyle(
                fontSize: 10.0,
              ),
            ),
          ),

        ],
      ),
    );
  }
}
