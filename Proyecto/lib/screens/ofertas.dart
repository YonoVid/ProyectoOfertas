import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ofertas_flutter/screens/navigationDrawer.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';

class Ofertas extends StatefulWidget {
  const Ofertas({Key? key}) : super(key: key);

  static final _OfertasTabKey = new GlobalKey<_OfertasState>();

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
    return Consumer<AppState>(
      builder: (context, appState, _) =>
        ListView(
          children: [
            for(var data in appState.locations)
                ListOfertas(
                  thumbnail: Container(),
                  title: data.name,
                  price: "\$" + data.price.toString(),
                  location: data.location.toString(),
                ),
          ],
        ),
    );
  }
}

class ListOfertas extends StatelessWidget {
  const ListOfertas({
    Key? key,
    required this.thumbnail,
    required this.title,
    required this.price,
    required this.location,
  }) : super(key: key);

  final Widget thumbnail;
  final String title;
  final String price;
  final String location;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        color: Colors.brown[100],
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Container(
                decoration: const BoxDecoration(color: Colors.brown),
                child: Icon(Icons.emoji_food_beverage_rounded),
                height: 80.0,
              ),
            ),
            Expanded(
              flex: 3,
              child: _OfertasDatos(name: title, price: price, location: location,),
            ),
            Expanded(
              flex: 1,
              child: IconButton(
                  color: Colors.grey[500],
                  icon: Icon(Icons.favorite_rounded),
                  onPressed: (){},
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OfertasDatos extends StatelessWidget {
  const _OfertasDatos({
    Key? key,
    required this.name,
    required this.location,
    required this.price,
  }) : super(key: key);

  final String name;
  final String price;
  final String location;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5.0, 5.0, 0.0, 10.0),
      child: Column(
        children: [
          Text(
            name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 14.0,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 1.0, vertical: 5.0),
            child: Text(
              location,
              style: TextStyle(
                fontSize: 10.0,
              ),
            ),
          ),
          Text(
            price,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14.0,
            ),
          ),
        ],
      ),
    );
  }
}
