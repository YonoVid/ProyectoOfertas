import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuth, FirebaseAuthException, UserCredential;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AppState extends ChangeNotifier {
  ApplicationLoginState _loginState = ApplicationLoginState.loggedOut;
  ApplicationLoginState get loginState => _loginState;

  User _user = User(uid:"anonymous", name:"anonymous", email:"");
  User get user => _user;

  StreamSubscription<QuerySnapshot>? _markersSubscription;
  StreamSubscription<QuerySnapshot>? _offersSubscription;
  Map<String, Local> _locals = <String, Local>{};
  Map<String, Local> get locals => _locals;

  Local? _localSelected = null;
  Local? get local => _localSelected;
  Offer? _offerSelected = null;
  Offer? get offerSelected => _offerSelected;
  set offerSelected(offer) => _offerSelected = offer;
  Set<Offer> _offersSelected = {};
  Set<Offer> get offersSelected => _offersSelected;
  //set offers (offer) => _offersSelected = offer;

  AppState() {
    init();
  }
  //Inicio de estado de la aplicación busca al usuario y carga los datos de
  //locales en la base de datos
  Future<void> init() async {
    /*WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );*/
    startLoginFlow();
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

  Set<Marker> getMarkers(Function function) {
    //Se crea un Set de marcadores
    Set<Marker> _markers = <Marker>{};
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
