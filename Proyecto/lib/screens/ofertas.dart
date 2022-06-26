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
            OfertasBusqueda(local: false),
            OfertasBusqueda(local: true),
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
  OfertasBusqueda({Key? key, required this.local}) : super(key: key);

  bool local;
  @override
  State<OfertasBusqueda> createState() => _OfertasBusquedaState(local: local);
}

class _OfertasBusquedaState extends State<OfertasBusqueda> {
  _OfertasBusquedaState({required this.local}):super();
  
  Set<Offer> offers = {};
  int _indexLocal = 0;
  int _indexOffer = 0;
  bool local;

  @override
  void initState(){
    super.initState();
    _loadOffer();
  }

  void _loadOffer() async
  {
    if(local)
      {
        offers.addAll(await Provider.of<AppState>(context, listen: false).getFavorites());
      }
    else{

      offers = offers.union(await Provider.of<AppState>(context, listen: false).getOffersFrom(_indexLocal, _indexOffer));
    }
    setState((){});
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
          children: [
            for(var data in offers)
                ListOfertas(
                  thumbnail: Container(),
                  offer: data,
                ),
          ],
    );
  }
}

class ListOfertas extends StatelessWidget {
  const ListOfertas({
    Key? key,
    required this.thumbnail,
    required this.offer,
  }) : super(key: key);

  final Widget thumbnail;
  final Offer offer;

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
              child: _OfertasDatos(name: offer.name, price: "\$"+offer.price.toString(), location: "null",),
            ),

            Expanded(
              flex: 1,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                      child: Consumer<AppState>(
                        builder: (context, appState, _) => IconButton(
                            onPressed: () {
                              Provider.of<AppState>(context, listen: false).saveFavorite(offer);
                            },
                            icon: Icon(
                              Icons.favorite_rounded,
                              color: (appState.favoritesId.contains(offer.id))?Colors.redAccent:Colors.brown[50],
                            )),
                      )),
                  Flexible(
                      child: IconButton(
                        onPressed: () {
                          Provider.of<AppState>(context, listen: false).offerSelected = offer;
                          Navigator.pushNamed(context, "/reporte");
                        },
                        icon: Icon(Icons.error_rounded),
                          color: Colors.brown[50]
                      )),
                ],
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
