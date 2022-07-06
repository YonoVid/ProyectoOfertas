import 'package:flutter/material.dart';
import 'package:ofertas_flutter/providers/app_state.dart';

import 'package:ofertas_flutter/screens/navigationDrawer.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../model/localClass.dart';
import '../model/offerClass.dart';

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

  Set<Marker> _markers = {};
  bool _canAddLocal = false;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _setStyle(controller);

    Provider.of<AppState>(context, listen: false)
        .setOverlayFunction(overlayData);
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
    print(local.id != Provider.of<AppState>(context, listen: false).local?.id);
    if (local.id != Provider.of<AppState>(context, listen: false).local?.id) {
      Provider.of<AppState>(context, listen: false).setLocal(local);
      await Provider.of<AppState>(context, listen: false).getOffersOf(local.id);
    }
    if (_canAddLocal)
      setState(() {
        _canAddLocal = false;
      });
    _keyDataOverlay.currentState!.show();
  }

  void _hideOverlay() async {
    _keyDataOverlay.currentState!.hide();
  }

  void _userMarker(AppState appState, LatLng point)
  {
    appState.location = point;
    appState.userMarker(Marker(
      markerId: const MarkerId("user"),
      position: point,
      infoWindow: InfoWindow(
        title: 'Solicitar nuevo local',
        onTap: () {},
      ),
      onTap: () {},
      icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueBlue),
    ));
    mapController.animateCamera(CameraUpdate.newLatLngZoom(point, 14.0));
    print(appState.markers.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("OFERTAS"),
          centerTitle: true,
          backgroundColor: Colors.indigo[500],
          elevation: 0.0,
          actions: <Widget>[
            Visibility(
              visible: !_canAddLocal,
              child: IconButton(
                icon: const Icon(Icons.location_on_outlined),
                tooltip: 'Añadir local',
                onPressed: () async {
                  setState(()
                  {
                    _canAddLocal = !_canAddLocal;
                  });
                  await Provider.of<AppState>(context, listen: false).getLocation();
                  _userMarker(Provider.of<AppState>(context, listen: false), Provider.of<AppState>(context, listen: false).location);
                },
              ),
            ),
            Visibility(
              visible: _canAddLocal,
              child: IconButton(
                icon: const Icon(Icons.add_business_outlined),
                tooltip: 'Añadir local',
                onPressed: () {
                  Navigator.pushNamed(context, "/agregar_local");
                },
              ),
            ),
          ]),
      body: Stack(children: [
        Consumer<AppState>(
          builder: (context, appState, _) => GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 11.0,
              ),
              markers: appState.markers,
              mapToolbarEnabled: false,
              onTap: (LatLng point) {
                print(point.toString());
                if (_keyDataOverlay.currentState?.isVisible() as bool) {
                  _hideOverlay();
                } else {
                  appState.removeUserMarker();
                }
                if (_canAddLocal)
                  setState(() {
                    _canAddLocal = false;
                  });
              },
              onLongPress: (LatLng point) {
                setState(() {
                  _canAddLocal = true;
                });
                _userMarker(appState, point);
              }),
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

  bool isVisible() => _visibleState;

  void goToLocalPage() {
    //Provider.of<AppState>(context, listen: false).setLocal(_local, _offers);
  }

  void scrollToLast() {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250), curve: Curves.decelerate);
  }

  @override
  Widget build(BuildContext context) {
    Local? _local = Provider.of<AppState>(context, listen: false).local;
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
              child: Consumer<AppState>(
                builder: (context, appState, _) => ListView(
                  controller: _scrollController,
                  padding: EdgeInsets.zero,
                  children: [
                    for (var data in appState.offersSelected)
                      DataOffer(
                        offer: data,
                      ),
                  ],
                ),
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
                      vertical: 0.0, horizontal: 10.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: Text(
                          (_local?.name == null) ? "" : _local?.name as String,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.brown[50],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: PopupMenuButton<int>(
                            onSelected: (value){
                              if( value == 1) Navigator.pushNamed(context, "/agregar_oferta");
                            },
                            itemBuilder: (context) => [
                              // popupmenu item 1
                              PopupMenuItem(
                                value: 1,
                                child: Row(
                                  children: [
                                    Icon(Icons.add_circle_outline_rounded,color: Colors.indigo[500],),
                                    SizedBox(
                                      // sized box with width 10
                                      width: 5,
                                    ),
                                    Text("Agregar oferta")
                                  ],
                                ),
                              ),
                            ]),
                      )
                    ],
                  ),
                ),
              )),
          Positioned(
            top: 20.0,
            left: 20.0,
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
      ),
    );
  }
}

class DataOffer extends StatefulWidget {
  DataOffer({Key? key, required this.offer}) : super(key: key);

  final Offer offer;
  @override
  State<DataOffer> createState() => _DataOfferState();
}

class _DataOfferState extends State<DataOffer> {
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
                      widget.offer.name,
                      style: TextStyle(color: Colors.brown[50]),
                    ),
                    subtitle: Text(
                      "\$" + widget.offer.price.toString(),
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
                    child: Consumer<AppState>(
                  builder: (context, appState, _) => IconButton(
                      onPressed: () {
                        //setState((){print('Prefavorite:$favorite');favorite = !favorite;print('Postfavorite:$favorite');});
                        Provider.of<AppState>(context, listen: false)
                            .saveFavorite(widget.offer);
                      },
                      icon: Icon(
                        Icons.favorite_rounded,
                        color: (appState.favoritesId.contains(widget.offer.id))
                            ? Colors.redAccent
                            : Colors.brown[50],
                      )),
                )),
                Expanded(
                    child: IconButton(
                  onPressed: () {
                    Provider.of<AppState>(context, listen: false)
                        .offerSelected = widget.offer;
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
