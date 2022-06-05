import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth, FirebaseAuthException;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'firebase_options.dart';

class AppState extends ChangeNotifier{

  ApplicationLoginState _loginState = ApplicationLoginState.loggedOut;
  ApplicationLoginState get loginState => _loginState;

  String? _email;
  String? get email => _email;

  StreamSubscription<QuerySnapshot>? _markersSubscription;
  List<Offer> _locations = <Offer>[];
  List<Offer> get locations => _locations;

  AppState(){
    init();
  }

  Future<void> init() async {
    /*WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );*/
    startLoginFlow();
    print("Data from Cloud");
    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        _loginState = ApplicationLoginState.loggedIn;
      } else {
        _loginState = ApplicationLoginState.loggedOut;
      }
      notifyListeners();
    });
    _markersSubscription = FirebaseFirestore.instance
        .collection('Oferta')
        .snapshots()
        .listen((snapshot) {
      _locations = [];
      for (final document in snapshot.docs) {
        print("Getting data from Cloud");
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

  void startLoginFlow() {
    _loginState = ApplicationLoginState.emailAddress;
    notifyListeners();
  }

  Future<void> signInWithEmailAndPassword(
      String email,
      String password,
      void Function(FirebaseAuthException e) errorCallback,
      ) async {
    try {
      print("Login in with user:" + email + "|password:"+password);
      var methods =
      await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
      for(var value in methods)
        {
          print(value);
        }
      if (methods.contains('password')) {
        print("Login method to server");
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        print("Login succesfull");
        _email = email;
        print(ApplicationLoginState);
      } else {
        _loginState = ApplicationLoginState.notRegistered;
      }
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
    }
  }

  void cancelRegistration() {
    _loginState = ApplicationLoginState.emailAddress;
    notifyListeners();
  }

  Future<void> registerAccount(
      String email,
      String displayName,
      String password,
      void Function(FirebaseAuthException e) errorCallback) async {
    try {
      var credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      await credential.user!.updateDisplayName(displayName);
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
    }
  }

  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  bool isLogged() {
    return _loginState == ApplicationLoginState.loggedIn;
  }

  Set<Marker> getMarkers(){
    Set<Marker> _markers = <Marker>{};
    for (final document in _locations) {
      print("Getting data from Cloud | " + document.id);
      _markers.add(Marker(
          markerId: MarkerId(document.id),
          position: document.location,
          onTap: (){
            print(
                document.toString());
          },
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

enum ApplicationLoginState {
  loggedOut,
  notRegistered,
  emailAddress,
  register,
  loggedIn,
}