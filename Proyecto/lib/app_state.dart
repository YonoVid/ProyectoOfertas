import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuth, FirebaseAuthException, UserCredential;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:geocode/geocode.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

class AppState extends ChangeNotifier {
  late Future<Database> databaseOffer;

  ApplicationLoginState _loginState = ApplicationLoginState.loggedOut;
  ApplicationLoginState get loginState => _loginState;

  User _user = User(uid:"anonymous", name:"anonymous", email:"");
  User get user => _user;

  StreamSubscription<QuerySnapshot>? _markersSubscription;
  StreamSubscription<QuerySnapshot>? _offersSubscription;
  Map<String, Local> _locals = <String, Local>{};
  Map<String, Local> get locals => _locals;

  Function _overlayData = (){};

  LatLng _location = LatLng(0.0, 0.0);
  LatLng get location => _location;
  set location(latlng) => _location = latlng;

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
    startLoginFlow();
    databaseOffer = openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      path.join(await getDatabasesPath(), 'offer_database.db'),
        onCreate: (db, version) {
          // Run the CREATE TABLE statement on the database.
          return db.execute(
            'CREATE TABLE offer(id TEXT PRIMARY KEY, name TEXT, price INTEGER)',
          );
        },
      version: 1,
    );
    for(var offer in await getFavorites())
      {
       favoritesId.add(offer.id);
      }
    print("Data from Cloud");
    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        _user.name = (user.displayName == null)?"user":user.displayName!;
        _user.email = (user.email == null)?"":user.email!;
        _user.uid = user.uid;
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
      _markers.clear();
      for (final document in snapshot.docs) {
        print("Getting data from Cloud");
        GeoPoint geoPoint = document.data()['ubicacion'];
        List<Offer> offers = <Offer>[];
        //Se obtienen los datos de los Locales
        _locals[document.id] = Local(
          id: document.id,
          name: document.data()['nombre'] as String,
          location: LatLng(geoPoint.latitude, geoPoint.longitude),
          offers: document.reference.collection('Oferta'),
        );
        getMarkers(_overlayData);
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
      print("Login in with user:" + email + "|password:" + password);
      var methods =
          await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
      for (var value in methods) {
        print(value);
      }
      if (methods.contains('password')) {
        print("Login method to server");
        UserCredential user = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        print("Login succesfull");
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

  Future<bool> registerAccount(
      String email,
      String displayName,
      String password,
      void Function(FirebaseAuthException e) errorCallback) async {
    try {
      var credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      await credential.user!.updateDisplayName(displayName);
      await signInWithEmailAndPassword(email, password, (e) { });
      return true;
    } on FirebaseAuthException catch (e) {
      print(e.toString());
    }
    return false;
  }

  /*Future<bool> registerAccount(
      String name, String email, String password) async {
    try {
      CollectionReference collection =
          FirebaseFirestore.instance.collection("Cliente");
      collection.add(
          {"UID": _uid, "nombre": name, "email": email, "password": password});
    } catch (e) {
      print(e.toString());
      return false;
    }
    return true;
  }*/

  void signOut() {
    FirebaseAuth.instance.signOut();
    _user = User(uid:"anonymous", name:"anonymous", email:"");
  }

  bool isLogged() {
    return _loginState == ApplicationLoginState.loggedIn;
  }

  void setOverlayFunction(Function overlayFunction) {
    _overlayData = overlayFunction;
    getMarkers(_overlayData);
    notifyListeners();
  }

  void setLocal(Local local) {
    _localSelected = local;
    _offersSubscription?.cancel();
    _offersSubscription = FirebaseFirestore.instance
        .collection("Local")
        .doc(local.id)
        .collection("Oferta")
        .snapshots()
        .listen((snapshot) {
          getOffersOf(local.id);
          notifyListeners();
    });
  }

  Future<bool> sendLocal(String name) async {
    try {
      //Se busca la colección que almacena las consultas
      CollectionReference collection = FirebaseFirestore.instance
          .collection("LocalPetition");
      collection.add({
        "UID": _user.uid,
        "nombre": name,
        "ubicacion": GeoPoint(_location.latitude, _location.longitude),
      });
      //_offersSelected.add(Offer(id:_uid, name:name,price: int.parse(price)));
    } catch (e) {
      print(e.toString());
      return false;
    }
    return true;
  }

  Future<bool> sendOffer(String name, String price, String category) async {
    try {
      //Se busca la colección que almacena las consultas
      CollectionReference collection = FirebaseFirestore.instance
          .collection("Local")
          .doc(_localSelected?.id)
          .collection("Oferta");
      collection.add({
        "UID": _user.uid,
        "nombre": name,
        "precio": int.parse(price),
        "category": category
      });
      //_offersSelected.add(Offer(id:_uid, name:name,price: int.parse(price)));
    } catch (e) {
      print(e.toString());
      return false;
    }
    return true;
  }

  Future<bool> sendReport(String type, String description) async {
    try {
      //Se busca el documento asociado a la oferta seleccionada
      DocumentReference document = FirebaseFirestore.instance
          .collection("Local")
          .doc(_localSelected?.id)
          .collection("Oferta")
          .doc(_offerSelected?.id);
      /* **Descomentar para verificar datos del documento**
      Map<String, dynamic>? data;
      {
        DocumentSnapshot value;
        value = await document.get();
        data = value.data() as Map<String, dynamic>?;
      }
      print(data.toString());*/
      document
          .collection("Reportes")
          .add({"UID": _user.uid, "tipo": type, "descripcion": description});
    } catch (e) {
      print(e.toString());
      return false;
    }
    return true;
  }

  Future<bool> sendConsult(String type, String description) async {
    try {
      //Se busca la colección que almacena las consultas
      CollectionReference collection =
          FirebaseFirestore.instance.collection("Consulta");

      collection.add({"UID": _user.uid, "tipo": type, "descripcion": description});
    } catch (e) {
      print(e.toString());
      return false;
    }
    return true;
  }

  Future<String> getLocation() async{
    Location location = new Location();
    PermissionStatus _permissionStatus;
    if(!(await location.serviceEnabled()))
      {
        if(!(await location.requestService()))
          {
            return "";
          }
      }
    _permissionStatus = await location.hasPermission();
    if(_permissionStatus == PermissionStatus.denied)
    {
      _permissionStatus = await location.requestPermission();
      if(_permissionStatus != PermissionStatus.granted)
      {
        return "";
      }
    }

    LocationData _currentPosition = await location.getLocation();

    return _currentPosition.latitude.toString() + "," + _currentPosition.longitude.toString();
  }

  void userMarker(Marker marker)
  {
    _markers.add(marker);
    notifyListeners();
  }

  void removeUserMarker()
  {
    _markers.removeWhere((marker) => marker.markerId == MarkerId("user"));
    notifyListeners();
  }

  Set<Marker> getMarkers(Function function) {
    //Se crea un Set de marcadores
    _markers = <Marker>{};
    //De los Locales obtenidos desde la base de datos
    //se crea un marcador por cada uno y se asigna la
    //función 'function' cuando son presionados
    _locals.forEach((key, value) {
      //print("Getting data from Cloud | " + value.id);
      _markers.add(Marker(
        markerId: MarkerId(value.id),
        position: value.location,
        onTap: () {
          function(value);
          removeUserMarker();
        },
      ));
    });
    return _markers;
  }

  Future<Set<Offer>> getOffersOf(String id) async {
    //Se crea un Set de Ofertas y una lista para almacenar
    //los documentos de la base de datos
    List data = [];
    Set<Offer> _offers = <Offer>{};
    try {
      //Se consiguen las Ofertas desde el Local con la id
      //indicada
      await _locals[id]?.offers.get().then((snapshot) => {
            snapshot.docs.forEach((document) {
              data.add(document);
            })
          });
      //Se almacenan las Ofertas en el Set _offers
      for (var document in data) {
        _offers.add(Offer(
          id: document.id,
          name: document.data()['nombre'] as String,
          price: document.data()['precio'],
        ));
        //print(document.id);
      }
    } catch (e) {
      print("ERROR: GETTING DATA FROM ID " + e.toString());
    }

    _offersSelected = _offers;
    return _offersSelected;
  }

  Future<Set<Offer>> getOffersFrom(int indexLocal, int indexOffer) async {
    Set<Offer> _offers = <Offer>{};
    int totalOffer = 0;
    int i = indexLocal;
    int e = indexOffer;
    try {
      print("LOCALS[" + _locals.length.toString() + "]:");
      for (i; i < _locals.length; i++) {
        //print("LOCAL INDEX " + i.toString());
        List data = [];
        if (totalOffer >= 50) {
          break;
        }
        await _locals.values.elementAt(i).offers.get().then((snapshot) => {
              snapshot.docs.forEach((document) {
                data.add(document);
              })
            });
        print("OFFERS[" + data.length.toString() + "]:");
        for (e; e < data.length; e++) {
          //print("OFFER INDEX " + e.toString());
          if (totalOffer >= 50) {
            break;
          }
          _offers.add(Offer(
            id: data[e].id,
            name: data[e].data()['nombre'] as String,
            price: data[e].data()['precio'],
          ));
          //print(data[e].id);
          totalOffer++;
        }
        e = 0;
      }
      indexLocal = i;
      indexOffer = e;
    } catch (e) {
      print("ERROR: GETTING OFFERS FROM DATABASE " + e.toString());
    }
    return _offers;
  }

  Future<bool> saveFavorite(Offer offer) async
  {
    //Obtener referencia de la base de datos
    final db = await databaseOffer;
    //Añadir oferta a la base de datos
    if((await db.query('offer',where: 'id = ?', whereArgs: [(offer.id)])).isEmpty){
      await db.insert('offer', offer.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
      favoritesId.add(offer.id);
    }
    else{
      await db.delete('offer', where: 'id = ?', whereArgs: [offer.id]);
      favoritesId.remove(offer.id);
    }
    notifyListeners();
    print(await getFavorites());
    return true;
  }

  Future<List<Offer>> getFavorites() async
  {
    //Obtener referencia de la base de datos
    final db = await databaseOffer;
    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('offer');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return Offer(
        id: maps[i]['id'],
        name: maps[i]['name'],
        price: maps[i]['price'],
      );
    });
  }
}

class Local {
  Local(
      {required this.id,
      required this.name,
      required this.location,
      required this.offers});
  final String id;
  final String name;
  final LatLng location;
  final CollectionReference offers;
}

/*
* factory City.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return City(
      name: data?['name'],
      state: data?['state'],
      country: data?['country'],
      capital: data?['capital'],
      population: data?['population'],
      regions:
          data?['regions'] is Iterable ? List.from(data?['regions']) : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (name != null) "name": name,
      if (state != null) "state": state,
      if (country != null) "country": country,
      if (capital != null) "capital": capital,
      if (population != null) "population": population,
      if (regions != null) "regions": regions,
    };
  }
*
* */
class Offer {
  Offer({required this.id, required this.name, required this.price});
  final String id;
  final String name;
  final int price;

  // Mapa de Oferta para almacenar con sqlite. colmunas deben ser nombres
  // en base de datos
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
    };
  }

  // ToString para facilitar lectura en consola de los datos.
  @override
  String toString() {
    return 'Offer{id: $id, name: $name, price: $price}';
  }
}

class User {
  User({required this.uid, required this.name, required this.email});
  String uid;
  String name;
  String email;
}

enum ApplicationLoginState {
  loggedOut,
  notRegistered,
  emailAddress,
  register,
  loggedIn,
}
