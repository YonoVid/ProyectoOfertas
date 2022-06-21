import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ofertas_flutter/app_state.dart';

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

  DataOverlay _contextMenu = DataOverlay(name: "");

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
    if (local.id != _keyDataOverlay.currentState!._id) {
      Set<Offer> offers = await Provider.of<AppState>(context, listen: false)
          .getOffersOf(local.id);
      // Declaring and Initializing OverlayState and
      // OverlayEntry objects
      _keyDataOverlay.currentState!.loadData(local, offers);
    } else {
      _keyDataOverlay.currentState!.show();
    }
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
          name: "Local",
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
  const DataOverlay({Key? key, required this.name}) : super(key: key);

  final String name;

  @override
  State<DataOverlay> createState() => _DataOverlayState();
}

class _DataOverlayState extends State<DataOverlay> {
  final _scrollController = ScrollController();
  bool _visibleState = false;
  bool _visibleExtra = false;
  String _id = "";
  String _name = "";
  LatLng _location = const LatLng(0.0, 0.0);
  Set<Offer> _offers = {};

  void loadData(Local local, Set<Offer> offers) {
    setState(() {
      _id = local.id;
      _name = local.name;
      _location = local.location;
      _offers = offers;
      _visibleState = true;
    });
    Provider.of<AppState>(context, listen: false).setLocal(local);
  }

  void hide() {
    if (_visibleState) {
      setState(() {
        _visibleState = !_visibleState;
        _visibleExtra = false;
      });
    }
  }

  void show() {
    if (!_visibleState) {
      setState(() {
        _visibleState = !_visibleState;
      });
    }
  }

  void changeVisible() {
    setState(() {
      _visibleState = !_visibleState;
    });
  }

  void goToLocalPage() {
    //Provider.of<AppState>(context, listen: false).setLocal(_local, _offers);
  }

  void scrollToLast() {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250), curve: Curves.decelerate);
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: _visibleState,
      child: Positioned(
        height: MediaQuery.of(context).size.height * 0.35,
        bottom: 5.0,
        left: 0.0,
        right: 0.0,
        child: Stack(children: [
          Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 0.0, horizontal: 5.0),
              height: MediaQuery.of(context).size.height * 0.25,
              color: Colors.indigo[500],
              child: ListView(
                controller: _scrollController,
                padding: EdgeInsets.zero,
                children: [
                  for (var data in _offers)
                    DataOffer(
                      offer: data,
                    ),
                ],
              ),
            ),
          ),
          Positioned(
              top: 30,
              left: 120,
              right: 20,
              child: Card(
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
                color: Colors.indigo[500],
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 10.0),
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
          Positioned(
            top: 20.0,
            left: 20.0,
            child: GestureDetector(
              onTap: () {
                setState((){_visibleExtra = !_visibleExtra;});
              },
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
          ),
          Visibility(
            visible: _visibleExtra,
            child: Positioned(
              top: 0.0,
              left: 20.0,
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.indigo[500],
                  shape: CircleBorder(),
                ),
                child: Icon(
                  Icons.add,
                  color: Colors.brown[50],
                ),
                onPressed: () {
                  Navigator.pushNamed(context, "/agregar_oferta");
                },
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

class DataOffer extends StatelessWidget {
  const DataOffer({Key? key, required this.offer}) : super(key: key);

  final Offer offer;

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
                      offer.name,
                      style: TextStyle(color: Colors.brown[50]),
                    ),
                    subtitle: Text(
                      "\$" + offer.price.toString(),
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
                        ))),
                Expanded(
                    child: IconButton(
                  onPressed: () {
                    Provider.of<AppState>(context, listen: false).offer = offer;
                    Navigator.pushNamed(context, "/reporte");
                  },
                  icon: Icon(Icons.error_rounded),
                )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
