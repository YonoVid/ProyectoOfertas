import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'
    show EmailAuthProvider, FirebaseAuth, FirebaseAuthException, UserCredential;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:ofertas_flutter/providers/provider_classes.dart';
import 'package:ofertas_flutter/providers/sql_database.dart';

import '../model/local_class.dart';
import '../model/offer_class.dart';
import 'firebase_database.dart';

class AppState extends ChangeNotifier {
  late SqlDatabase sqlDatabase;
  FirebaseDatabase? firebaseDatabase;

  AppUser get user => firebaseDatabase!.user;

  int _tabIndex = 0;
  int get tabIndex => _tabIndex;
  set tabIndex(index) => _tabIndex = index;

  Map<int, String> _categories = {};
  Map<int, String> get categories => _categories;
  Map<int, bool> _stateCategories = {};
  Map<int, bool> get stateCategories => _stateCategories;

  Filter _offerFilter =
      Filter(text: "", range: RangeValues(0, 50000), category: {});
  Filter get offerFilter => _offerFilter;
  //set offerFilter(filter) => _offerFilter = filter;

  Map<String, Local> _locals = <String, Local>{};
  Map<String, Local> get locals => _locals;

  Function _overlayData = () {};
  Function _hideData = () {};
  Function get hideData => _hideData;
  Function _reloadOffer = () {};
  Function get reloadOffer => _reloadOffer;
  set reloadOffer(function) => _reloadOffer = function;

  LatLng _location = const LatLng(0.0, 0.0);
  LatLng get location => _location;
  set location(latlng) => _location = latlng;

  Local? get userLocal => firebaseDatabase?.userLocal;

  Local? _localSelected = null;
  Local? get local => _localSelected;
  Offer? _offerSelected = null;
  Offer? get offerSelected => _offerSelected;
  set offerSelected(offer) => _offerSelected = offer;
  Set<Offer> _offersSelected = {};
  Set<Offer> get offersSelected => _offersSelected;
  //set offers (offer) => _offersSelected = offer;

  Set<String> favoritesId = {};

  Set<Marker> _markers = {};
  Set<Marker> get markers => _markers;

  AppState() {
    init();
  }
  //Inicio de estado de la aplicación busca al usuario y carga los datos de
  //locales en la base de datos
  Future<void> init() async {
    // Avoid errors caused by flutter upgrade.
    // Importing 'package:flutter/widgets.dart' is required.
    WidgetsFlutterBinding.ensureInitialized();
    //Iniciar flujo de base de datos local y remoto
    await startDatabase();
    print("Data from Cloud");
    firebaseDatabase = FirebaseDatabase(notifyListeners, getMarkers);
    await firebaseDatabase!.init();
  }

  Future<void> startDatabase() async {
    //Se inicia funcionalidad de base de datos local
    sqlDatabase = SqlDatabase();
    await sqlDatabase.init();
    for (var offer in await getFavorites()) {
      favoritesId.add(offer.id);
    }
    getCategories();
  }

  Future<void> signInWithEmailAndPassword(
    String email,
    String password,
    void Function(FirebaseAuthException e) errorCallback,
  ) async {
    await firebaseDatabase!.signInWithEmailAndPassword(email, password, (e) { });
  }

  Future<bool> changeUsername(String newName) async {
    return firebaseDatabase!.changeUsername(newName);
  }

  Future<bool> changePassword(String oldPassword, String newPassword) async {
    return changePassword(oldPassword, newPassword);
  }

  Future<bool> registerAccount(
      String email,
      String displayName,
      String password,
      void Function(FirebaseAuthException e) errorCallback) async {
    return firebaseDatabase!.registerAccount(email, displayName, password, (e) { });
  }

  void signOut() {
    firebaseDatabase!.signOut();
  }

  bool isLogged() {
    return firebaseDatabase!.loginState == ApplicationLoginState.loggedIn;
  }

  void setOverlayFunction(Function overlayFunction) {
    _overlayData = overlayFunction;
    if(firebaseDatabase != null)getMarkers(firebaseDatabase!.locals);
    notifyListeners();
  }

  void setHideOverlayFunction(Function hideFunction) {
    _hideData = hideFunction;
    notifyListeners();
  }

  void setLocal(Local local) {
    _localSelected = local;
    firebaseDatabase!.offersSubscription?.cancel();
    firebaseDatabase!.offersSubscription = FirebaseFirestore.instance
        .collection("Local")
        .doc(local.id)
        .collection("Oferta")
        .snapshots()
        .listen((snapshot) {
      getOffersOf(local.id);
      notifyListeners();
    });
  }

  Future<void> getCategories() async {
    //Obtener referencia de la base de datos
    try {
      Map<String, dynamic> document = {};
      await FirebaseFirestore.instance
          .collection("Datos")
          .doc("Ofertas")
          .get()
          .then((value) => document = (value.data())!);
      List categories = document['categorias'];
      for (int i = 1; i < categories.length; i++) {
        print(categories[i]);
        _categories[i] = categories[i];
        _stateCategories[i] = false;
        await sqlDatabase.addCategory(i, categories[i]);
      }
      print(categories[0]);
      _categories[0] = categories[0];
      _stateCategories[0] = false;
      await sqlDatabase.addCategory(0, categories[0]);
    } catch (e) {
      print(e.toString());
      // Petición a base de datos local para obtener categorias
      _categories = await sqlDatabase.getCategories();
    }
  }

  Future<bool> sendLocal(String name) async {
    return firebaseDatabase!.sendLocal(name, _location);
  }

  Future<bool> updateLocalOffer(Offer newOffer) async {
    return firebaseDatabase!.updateLocalOffer(newOffer);
  }

  Future<bool> changeLocalName(String name) async {
    return firebaseDatabase!.changeLocalName(name);
  }

  Future<bool> sendOffer(Offer offer) async {
    return firebaseDatabase!.sendOffer(offer, _localSelected?.id as String);
  }

  Future<bool> sendReport(String type, String description) async {
    return firebaseDatabase!.sendReport(type, description, _localSelected?.id as String, _offerSelected?.id as String);
  }

  Future<bool> sendConsult(String type, String description) async {
    return firebaseDatabase!.sendConsult(type, description);
  }

  Future<String> getLocation() async {
    Location location = new Location();
    PermissionStatus _permissionStatus;
    if (!(await location.serviceEnabled())) {
      if (!(await location.requestService())) {
        return "";
      }
    }
    _permissionStatus = await location.hasPermission();
    if (_permissionStatus == PermissionStatus.denied) {
      _permissionStatus = await location.requestPermission();
      if (_permissionStatus != PermissionStatus.granted) {
        return "";
      }
    }

    LocationData _currentPosition = await location.getLocation();
    _location = LatLng(_currentPosition.latitude as double,
        _currentPosition.longitude as double);

    return _currentPosition.latitude.toString() +
        "," +
        _currentPosition.longitude.toString();
  }

  void userMarker(Marker marker) {
    _markers.add(marker);
    notifyListeners();
  }

  void removeUserMarker() {
    _markers.removeWhere((marker) => marker.markerId == MarkerId("user"));
    notifyListeners();
  }

  Set<Marker> getMarkers(Map<String, Local> locals) {
    //Se crea un Set de marcadores
    _markers = <Marker>{};
    //De los Locales obtenidos desde la base de datos
    //se crea un marcador por cada uno y se asigna la
    //función 'function' cuando son presionados
    locals.forEach((key, value) {
      //print("Getting data from Cloud | " + value.id);
      _markers.add(Marker(
        markerId: MarkerId(value.id),
        position: value.location,
        onTap: () {
          _overlayData(value);
          removeUserMarker();
        },
      ));
    });
    return _markers;
  }

  Future<void> getOffersOf(String id) async {
    //Se crea un Set de Ofertas y una lista para almacenar
    //los documentos de la base de datos

    _offersSelected = await firebaseDatabase!.getOffersOf(id);
    notifyListeners();
  }

  Future<Set<Offer>> getOffersFrom(int indexLocal, int indexOffer) async {
    return firebaseDatabase!.getOffersFrom(indexLocal, indexOffer, offerFilter);
  }

  Future<void> removeOffer(Offer offer) async {
    firebaseDatabase!.removeOffer(offer);
  }

  Future<bool> saveFavorite(Offer offer) async {
    //Se actualiza la lista de id en favoritos de acuerdo al resultado de la
    //operación
    await sqlDatabase.saveFavorite(offer) ? favoritesId.add(offer.id):favoritesId.remove(offer.id);
    //Se indica que se ha actualizado a las interfaces
    notifyListeners();
    return true;
  }

  Future<List<Offer>> getFavorites() async {
    return await sqlDatabase.getFavorites(offerFilter);
  }
}
