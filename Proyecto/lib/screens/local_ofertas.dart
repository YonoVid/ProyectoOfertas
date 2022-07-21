import 'package:flutter/material.dart';
import 'package:ofertas_flutter/screens/navigationDrawer.dart';
import 'package:provider/provider.dart';

import '../model/offer_class.dart';
import '../providers/app_state.dart';

class OfertasLocal extends StatefulWidget {
  const OfertasLocal({Key? key}) : super(key: key);

  @override
  State<OfertasLocal> createState() => _OfertasLocalState();
}

class _OfertasLocalState extends State<OfertasLocal> {
  String _dropDownCategoryDefault = "Categoría de la oferta";
  String _dropDownValue = "Categoría de la oferta";
  TextEditingController _inputController0 = TextEditingController();
  TextEditingController _inputController1 = TextEditingController();

  void msg(String msg) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("OFERTAS LOCAL"),
        centerTitle: true,
        backgroundColor: Colors.indigo[500],
        elevation: 0.0,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
              decoration: BoxDecoration(
                  color: Colors.indigo[500],
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              child: Stack(children: [
                Positioned(
                  top: 10,
                  left: 120,
                  right: 20,
                  child: Container(
                    margin:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
                    color: Colors.indigo[500],
                    child: Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: Consumer<AppState>(
                            builder: (context, appState, _) => Text(
                              (appState.local?.name == null)
                                  ? ""
                                  : appState.local?.name as String,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.brown[50],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 80.0,
                  left: 125.0,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.white),
                        borderRadius: BorderRadius.circular(20)),
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, "/agregar_oferta");
                      },
                      child: Row(
                        children: const [
                          Icon(Icons.add_circle_outline_rounded, color: Colors.white,),
                          Text(
                            ' Solicitar oferta',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 20.0,
                  left: 20.0,
                  child: Container(
                    height: 75.0,
                    width: 75.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage('assets/ofertas.png')),
                      color: Colors.brown[100],
                      border: Border.all(width: 2.0, color: Colors.indigo),
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ),
              ]),
            ),
          ),
          Expanded(
            flex: 5,
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
              decoration: BoxDecoration(
                  color: Colors.brown[100],
                  // Red border with the width is equal to 5
                  border: Border.all(width: 5, color: Colors.indigo)),
              child: Consumer<AppState>(
                builder: (context, appState, _) => ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    for (var data in appState.offersSelected)
                      LocalOfertas(
                        thumbnail: Container(),
                        offer: data,
                        functionLocalOffer: (){},
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LocalOfertas extends StatelessWidget {
  const LocalOfertas({
    Key? key,
    required this.thumbnail,
    required this.offer,
    required this.functionLocalOffer,
  }) : super(key: key);

  final Widget thumbnail;
  final Offer offer;
  final Function functionLocalOffer;

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
              child: _OfertasDatos(
                name: offer.name,
                price: "\$" + offer.price.toString(),
                location: offer.category,
              ),
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
