import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart' show FirebaseFirestore, GeoPoint, QuerySnapshot;
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

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("OFERTAS"),
        centerTitle: true,
        backgroundColor: Colors.indigo[500],
        elevation: 0.0,
      ),
      body: Consumer<AppState>(
        builder: (context, appState, _) => GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 11.0,
          ),
          markers: appState.getMarkers(),
        ),
      ),
      backgroundColor: Colors.brown[200],
      drawer: NavDrawer(
        username: 'Nombre de usuario',
        email: 'Correo',
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.indigo[500],
        onPressed: () {
          Navigator.pushNamed(context, '/agregar_oferta');
        },
      ),
    );
  }
}
