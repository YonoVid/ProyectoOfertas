import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ofertas_flutter/screens/navigationDrawer.dart';
import 'package:provider/provider.dart';

import '../providers/app_state.dart';
import '../model/offerClass.dart';

class Ofertas extends StatefulWidget {
  const Ofertas({Key? key}) : super(key: key);

  static final _OfertasTabKey = GlobalKey<_OfertasState>();

  @override
  State<Ofertas> createState() => _OfertasState();
}

class _OfertasState extends State<Ofertas> with SingleTickerProviderStateMixin {

  final TextEditingController _filterController = TextEditingController();

  final GlobalKey<_OfertasBusquedaState> _offersKey = GlobalKey();
  final GlobalKey<_OfertasBusquedaState> _favoriteOffersKey = GlobalKey();

  void changeFilter(){
    Provider.of<AppState>(context, listen: false).offerFilter.text = _filterController.text.toLowerCase();
    _favoriteOffersKey.currentState?.reload();
    _offersKey.currentState?.reload();
  }

  @override
  Widget build(BuildContext context) {
    var tabIndex = Provider.of<AppState>(context, listen: false).tabIndex;
    return DefaultTabController(
      length: 2,
      initialIndex: tabIndex,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Expanded(
                child: Container(
                  child: TextField(
                    onChanged: (String? filter){
                      changeFilter();
                    },
                    controller: _filterController,
                    decoration: InputDecoration(
                        hintStyle: TextStyle(color: Color(Colors.brown[50]!.value)),
                        border: OutlineInputBorder(),
                        hintText: 'Buscar término',
                        suffixIcon: IconButton(     // Icon to
                          icon: Icon(Icons.clear, color: Colors.brown[50],), // clear text
                          onPressed: (){
                            _filterController.clear();
                            changeFilter();
                            },),),
                    style: TextStyle(color: Colors.brown[50]),
                  ),
                ),
              ),
              IconButton(onPressed: (){
                Navigator.pushNamed(context, "/filtro_ofertas");
              }, icon: Icon(Icons.filter_alt_rounded))
            ],
          ),
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.monetization_on_rounded)),
              Tab(icon: Icon(Icons.favorite_rounded)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            OfertasBusqueda(key: _offersKey,local: false),
            OfertasBusqueda(key: _favoriteOffersKey,local: true),
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

  TextEditingController _inputFilter = TextEditingController();

  @override
  void initState(){
    super.initState();
    _loadOffer();

    Provider.of<AppState>(context, listen: false).reloadOffer = reload;
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
  void reload() async{
    offers = {};
    _loadOffer();
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
