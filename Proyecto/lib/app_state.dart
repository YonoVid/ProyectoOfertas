import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth, FirebaseAuthException;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ofertas_flutter/screens/home.dart';

import 'firebase_options.dart';

class AppState extends ChangeNotifier{

  ApplicationLoginState _loginState = ApplicationLoginState.loggedOut;
  ApplicationLoginState get loginState => _loginState;

  String? _email;
  String? get email => _email;

  StreamSubscription<QuerySnapshot>? _markersSubscription;
  Map<String, Local> _locals = <String, Local>{};
  Map<String, Local> get locals => _locals;

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
        .collection('Local')
        .snapshots()
        .listen((snapshot) {
      _locals.clear();
      for (final document in snapshot.docs) {
        print("Getting data from Cloud");
        GeoPoint geoPoint = document.data()['ubicacion'];
        List<Offer> offers= <Offer>[];

        /*for(final offer in document.reference.collection('Oferta'))
          {
            offers.add(Offer(
              id: offer.id,
              name: offer.data()['nombre'] as String,
              price: offer.data()['precio']
            ));
          }*/
        _locals[document.id]=Local(
          id: document.id,
          name: document.data()['nombre'] as String,
          location: LatLng(geoPoint.latitude, geoPoint.longitude),
          offers: document.reference.collection('Oferta'),
        );
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

  Set<Marker> getMarkers(Function function){
    Set<Marker> _markers = <Marker>{};
    _locals.forEach((key, value) {
      print("Getting data from Cloud | " + value.id);
      _markers.add(Marker(
          markerId: MarkerId(value.id),
          position: value.location,
          onTap: (){
            function(value);
          },
      ));
    });
    return _markers;
  }

  Future<Set<Offer>> getOffers(String id) async{
    List data = [];
    Set<Offer> _offers = <Offer>{};
    try{
      await _locals[id]?.offers.get().then((snapshot) =>
      {
        snapshot.docs.forEach((document) {
          data.add(document

      );})});
      for(var document in data)
        {
          _offers.add(Offer(
            id:document.id,
            name: document.data()['nombre'] as String,
            price: document.data()['precio'],
          ));
          print(document.id);
        }
    }
    catch(e){
      print("ERROR: GETTING DATA FROM ID " + e.toString());
    }

    return _offers;
  }
}

class Local{
  Local({required this.id, required this.name, required this.location, required this.offers});
  final String id;
  final String name;
  final LatLng location;
  final CollectionReference offers;
}

class Offer{
  Offer({required this.id, required this.name, required this.price});
  final String id;
  final String name;
  final int price;
}

enum ApplicationLoginState {
  loggedOut,
  notRegistered,
  emailAddress,
  register,
  loggedIn,
}