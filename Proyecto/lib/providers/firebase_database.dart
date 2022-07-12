import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ofertas_flutter/providers/provider_classes.dart';

import '../model/local_class.dart';
import '../model/offer_class.dart';

class FirebaseDatabase{

  late AppUser user;
  Local? userLocal;
  late Function notifyListeners;
  late Function loadMarkers;

  Map<String, Local> locals = <String, Local>{};

  ApplicationLoginState _loginState = ApplicationLoginState.loggedOut;
  get loginState => _loginState;

  late StreamSubscription<User?> _loginSubscription;
  late StreamSubscription<QuerySnapshot> _markersSubscription;
  StreamSubscription<QuerySnapshot>? offersSubscription;

  FirebaseDatabase(Function notifyFunction, Function markersFunction)
  {
    notifyListeners = notifyFunction;
    loadMarkers = markersFunction;
    user = AppUser(uid: "anonymous", name: "anonymous", email: "");
  }

  Future<void> init() async {
    _loginSubscription = FirebaseAuth.instance.userChanges().listen((user) async {
      if (user != null) {
        this.user.name = (user.displayName == null) ? "user" : user.displayName!;
        this.user.email = (user.email == null) ? "" : user.email!;
        this.user.uid = user.uid;
        _loginState = ApplicationLoginState.loggedIn;
        await getUserLocal();
      } else {
        userLocal = null;
        _loginState = ApplicationLoginState.loggedOut;
      }
      notifyListeners();
    });
    _markersSubscription = FirebaseFirestore.instance
        .collection('Local')
        .snapshots()
        .listen((snapshot) {
      locals.clear();
      for (final document in snapshot.docs) {
        print("Getting data from Cloud");
        GeoPoint geoPoint = document.data()['ubicacion'];
        List<Offer> offers = <Offer>[];
        //Se obtienen los datos de los Locales
        locals[document.id] = Local(
          id: document.id,
          name: document.data()['nombre'] as String,
          location: LatLng(geoPoint.latitude, geoPoint.longitude),
          offers: document.reference.collection('Oferta'),
        );
        loadMarkers(locals);
      }
      notifyListeners();
    });
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
        UserCredential user =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
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

  void signOut() {
    FirebaseAuth.instance.signOut();
    user = AppUser(uid: "anonymous", name: "anonymous", email: "");
  }

  Future<void> getUserLocal() async {
    try {
      Map<String, dynamic> document = {};
      await FirebaseFirestore.instance
          .collection("JefeLocal")
          .doc(user.uid)
          .get()
          .then((value) => document = (value.data())!);
      String localId = document['local'];
      if (locals.containsKey(localId)) userLocal = locals[localId];
    } catch (e) {
      print("ERROR LOCAL OWNER::" + e.toString());
    }
  }

  Future<bool> changeUsername(String newName) async {
    try {
      await FirebaseAuth.instance.currentUser!.updateDisplayName(newName);
      user.name = newName;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      print(e.toString());
    }
    return false;
  }

  Future<bool> changePassword(String oldPassword, String newPassword) async {
    bool result = true;
    try {
      var user = FirebaseAuth.instance.currentUser;
      var credential = EmailAuthProvider.credential(
          email: user?.email as String, password: oldPassword);
      // Prompt the user to re-provide their sign-in credentials
      await user
          ?.reauthenticateWithCredential(credential)
          .then((credential) async {
        // User re-authenticated.
        FirebaseAuth.instance.currentUser!.updatePassword(newPassword);
      }).onError((error, stackTrace) {
        print("ERROR CHANGE IN PASSWORD::" + error.toString());
        result = false;
      });
    } on FirebaseAuthException catch (e) {
      print("ERROR GETTING USER::" + e.toString());
      result = false;
    }
    print("OUT:" + result.toString());
    return result;
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
      await signInWithEmailAndPassword(email, password, (e) {});
      return true;
    } on FirebaseAuthException catch (e) {
      print(e.toString());
    }
    return false;
  }

  Future<bool> sendLocal(String name, LatLng location) async {
    try {
      //Se busca la colección que almacena las consultas
      CollectionReference collection =
      FirebaseFirestore.instance.collection("LocalPetition");
      collection.add({
        "UID": user.uid,
        "nombre": name,
        "ubicacion": GeoPoint(location.latitude, location.longitude),
      });
      //_offersSelected.add(Offer(id:_uid, name:name,price: int.parse(price)));
    } catch (e) {
      print(e.toString());
      return false;
    }
    return true;
  }

  Future<bool> updateLocalOffer(Offer newOffer) async {
    if(userLocal != null)
      {
        try {
          //Se busca la colección que almacena las consultas
          await FirebaseFirestore.instance
              .collection("Local")
              .doc(userLocal?.id)
              .collection("Oferta")
              .doc(newOffer.id)
              .update({"nombre": newOffer.name, "precio": newOffer.price, "categoria": newOffer.category});
          //_offersSelected.add(Offer(id:_uid, name:name,price: int.parse(price)));
        } catch (e) {
          print(e.toString());
          return false;
        }
        return true;
      }
    return false;
  }

  Future<bool> changeLocalName(String name) async {
    if(userLocal != null)
      {
        try {
          //Se busca el local y se actualiza el nombre
          await FirebaseFirestore.instance
              .collection("Local")
              .doc(userLocal?.id)
              .update({"nombre": name}).then((value) {
            print("CHANGE LOCAL NAME: " + name);
            locals[userLocal?.id]?.name = name;
            userLocal?.name = name;
          }).onError((error, stackTrace) {
            print("ERROR CHANGE LOCAL NAME::" + error.toString());
          });

          notifyListeners();
          //_offersSelected.add(Offer(id:_uid, name:name,price: int.parse(price)));
        } catch (e) {
          print(e.toString());
          return false;
        }
        return true;
      }
    return false;
  }

  Future<bool> sendOffer(Offer offer, String localId) async {
    try {
      //Se busca la colección que almacena las consultas
      CollectionReference collection = FirebaseFirestore.instance
          .collection("Local")
          .doc(localId)
          .collection("Oferta");
      collection.add({
        "UID": user.uid,
        "nombre": offer.name,
        "precio": offer.price,
        "categoria": offer.category
      });
      //_offersSelected.add(Offer(id:_uid, name:name,price: int.parse(price)));
    } catch (e) {
      print(e.toString());
      return false;
    }
    return true;
  }

  Future<bool> sendReport(String type, String description, String localId, String offerId) async {
    try {
      //Se busca el documento asociado a la oferta seleccionada
      DocumentReference document = FirebaseFirestore.instance
          .collection("Local")
          .doc(localId)
          .collection("Oferta")
          .doc(offerId);
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
          .add({"UID": user.uid, "tipo": type, "descripcion": description});
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

      collection
          .add({"UID": user.uid, "tipo": type, "descripcion": description});
    } catch (e) {
      print(e.toString());
      return false;
    }
    return true;
  }

  Future<Set<Offer>> getOffersOf(String id) async {
    //Se crea un Set de Ofertas y una lista para almacenar
    //los documentos de la base de datos
    List data = [];
    Set<Offer> _offers = <Offer>{};
    try {
      //Se consiguen las Ofertas desde el Local con la id
      //indicada
      await locals[id]?.offers.get().then((snapshot) => {
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
            category: document.data()['categoria']));
        //print(document.id);
      }
    } catch (e) {
      print("ERROR: GETTING DATA FROM ID " + e.toString());
    }

    notifyListeners();
    return _offers;
  }

  Future<Set<Offer>> getOffersFrom(int indexLocal, int indexOffer, Filter offerFilter) async {
    Set<Offer> _offers = <Offer>{};
    int totalOffer = 0;
    int i = indexLocal;
    int e = indexOffer;
    try {
      print("LOCALS[" + locals.length.toString() + "]:");
      for (i; i < locals.length; i++) {
        //print("LOCAL INDEX " + i.toString());
        List data = [];
        if (totalOffer >= 50) {
          break;
        }
        await locals.values.elementAt(i).offers.get().then((snapshot) => {
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
          if (offerFilter.text != "" &&
              !(data[e].data()['nombre'] as String)
                  .toLowerCase()
                  .contains(offerFilter.text) ||
              offerFilter.range.start >= data[e].data()['precio'] ||
              offerFilter.range.end <= data[e].data()['precio'] ||
              !offerFilter.inCategory(data[e].data()['categoria'])) {
            continue;
          }
          _offers.add(Offer(
            id: data[e].id,
            name: data[e].data()['nombre'] as String,
            price: data[e].data()['precio'],
            category: data[e].data()['categoria'],
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

  Future<void> removeOffer(Offer offer) async {
    if(userLocal != null)
      {
        try {
          await FirebaseFirestore.instance
              .collection("Local")
              .doc(userLocal!.id)
              .collection("Oferta")
              .doc(offer.id)
              .delete()
              .then((value) => print("DELETE:" + offer.id))
              .onError((error, stackTrace) =>
              print("ERROR DELETE::" + error.toString()));
        } catch (e) {
          print("ERROR: GETTING OFFERS FROM DATABASE " + e.toString());
        }
      }
  }
}
