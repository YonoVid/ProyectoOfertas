import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'
    show FirebaseFirestore, GeoPoint, QuerySnapshot;
import 'package:ofertas_flutter/app_state.dart';
//import 'package:firebase_core/firebase_auth.dart';
import 'package:ofertas_flutter/screens/navigationDrawer.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late GoogleMapController mapController;
  late OverlayEntry? overlayEntry;
  late BuildContext widgetContext;

  final GlobalKey<_DataOverlayState> _keyDataOverlay = GlobalKey();

  String _localName = "";
  Set<Offer> _localOffers = {};
  DataOverlay _contextMenu = DataOverlay(name: "", offers: {});

  final LatLng _center = const LatLng(-33.45694, -70.64827);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _setStyle(controller);
  }

  void _setStyle(GoogleMapController controller) async {
    String value = await DefaultAssetBundle.of(context)
        .loadString('assets/google_maps_style.json');
    controller.setMapStyle(value);
  }

  void overlayData(Local local) async {
    print(local.id + "|" + local.name + "|" + local.location.toString());
    mapController
        .animateCamera(CameraUpdate.newLatLngZoom(local.location, 14.0));

    Set<Offer> offers =
    await Provider.of<AppState>(context, listen: false).getOffers(local.id);
    // Declaring and Initializing OverlayState and
    // OverlayEntry objects
    _keyDataOverlay.currentState!.loadData(local.name, offers);

  }

  void _hideOverlay() async {
      _keyDataOverlay.currentState!.hide();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("OFERTAS"),
        centerTitle: true,
        backgroundColor: Colors.indigo[500],
        elevation: 0.0,
      ),
      body: Stack(children: [
        Consumer<AppState>(
          builder: (context, appState, _) => GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 11.0,
            ),
            markers: appState.getMarkers(overlayData),
            onTap: (context) => {_hideOverlay()},
          ),
        ),
        DataOverlay(
          key: _keyDataOverlay,
          name: _localName,
          offers: _localOffers,
        )
      ]),
      backgroundColor: Colors.brown[200],
      drawer: NavDrawer(
        username: 'Nombre de usuario',
        email: 'Correo',
      ),
      /*floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.indigo[500],
        onPressed: () {
          Navigator.pushNamed(context, '/agregar_oferta');
        },
      ),*/
    );
  }
}

class DataOverlay extends StatefulWidget {
  const DataOverlay({Key? key, required this.name, required this.offers})
      : super(key: key);

  final String name;
  final Set<Offer> offers;

  @override
  State<DataOverlay> createState() => _DataOverlayState();
}

class _DataOverlayState extends State<DataOverlay> {
  bool _visibleState = false;
  String _name  = "";
  Set<Offer> _offers = {};

  void loadData(String name, Set<Offer> offers)
  {
    setState((){_name = name; _offers = offers;_visibleState=true;});
  }

  void hide(){
    if(_visibleState) {
      setState((){_visibleState=!_visibleState;});
    }
  }

  void changeVisible(){
    setState((){_visibleState=!_visibleState;});
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: _visibleState,
      child: Stack(children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 0.0, horizontal: 5.0),
            height: MediaQuery.of(context).size.height * 0.15,
            color: Colors.indigo[500],
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                for (var data in _offers)
                  DataOffer(
                    name: data.name,
                    price: data.price.toString(),
                  ),
              ],
            ),
          ),
        ),
        Align(
            alignment: FractionalOffset(0.6, 0.845),
            child: Card(
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
              color: Colors.indigo[500],
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                child: Text(
                  _name,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown[50],
                  ),
                ),
              ),
            )),
        Align(
          alignment: FractionalOffset(0.08, 0.88),
          child: Container(
            height: 100.0,
            width: 100.0,
            decoration: BoxDecoration(
              color: Colors.brown[100],
              border: Border.all(width: 2.0, color: Colors.indigo),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Image.asset('assets/P18.png'),
          ),
        ),
      ]),
    );
  }
}

class DataOffer extends StatelessWidget {
  const DataOffer({Key? key, required this.name, required this.price})
      : super(key: key);

  final String name;
  final String price;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.indigo[500],
      child: Container(
        height: MediaQuery.of(context).size.height * 0.13,
        margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(90.0, 0.0, 0.0, 0.0),
                child: DefaultTextStyle(
                  style: TextStyle(color: Colors.brown[50]),
                  child: ListTile(
                    title: Text(
                      name,
                      style: TextStyle(color: Colors.brown[50]),
                    ),
                    subtitle: Text(
                      "\$" + price,
                      style: TextStyle(color: Colors.brown[50]),
                    ),
                    style: ListTileStyle.list,
                  ),
                ),
              ),
            ),
            Column(
              children: [
                Expanded(
                    child: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.favorite_rounded,
                          color: Colors.brown[50],
                        ))),
                Expanded(
                    child: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.error_rounded),
                  color: Colors.brown[50],
                )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
