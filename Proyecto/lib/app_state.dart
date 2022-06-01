import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AppState extends ChangeNotifier{
  StreamSubscription<QuerySnapshot>? _markersSubscription;
  List<Offer> _locations = <Offer>[];
  List<Offer> get locations => _locations;

  AppState(){
    init();
  }
  Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    print("Data from Cloud");
    _markersSubscription = FirebaseFirestore.instance
        .collection('Oferta')
        .snapshots()
        .listen((snapshot) {
      _locations = [];
      for (final document in snapshot.docs) {
        print("Getting data form Cloud");
        GeoPoint geoPoint = document.data()['ubicacion'];
        _locations.add(Offer(
            id: document.id,
            name: document.data()['nombre'] as String,
            price: document.data()['precio'],
            location: LatLng(geoPoint.latitude, geoPoint.longitude),
        ));
      }
      notifyListeners();
    });
  }

  Set<Marker> getMarkers(){
    Set<Marker> _markers = <Marker>{};
    for (final document in _locations) {
      print("Getting data form Cloud");
      _markers.add(Marker(
          markerId: MarkerId(document.id),
          position: document.location,
          infoWindow: InfoWindow(title: document.name)));
    }
    return _markers;
  }
}

class Offer{
  Offer({required this.id, required this.name, required this.price, required this.location});
  final String id;
  final String name;
  final int price;
  final LatLng location;
}