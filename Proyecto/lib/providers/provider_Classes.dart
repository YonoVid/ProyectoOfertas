import 'package:flutter/material.dart';
import 'package:ofertas_flutter/model/offerClass.dart';

class User {
  User({required this.uid, required this.name, required this.email});
  String uid;
  String name;
  String email;
}

class Offers {
  Offers({required this.all, required this.favorites});
  Set<Offer> all;
  Set<Offer> favorites;
}

class Filter {
  Filter({required this.text, required this.range, required this.category});
  String text;
  RangeValues range;
  Set<String> category;

  bool inCategory(String category)
  {
    if(this.category.isEmpty)
    {
      return true;
    }
    return this.category.contains(category);
  }
}

enum ApplicationLoginState {
  loggedOut,
  notRegistered,
  emailAddress,
  register,
  loggedIn,
}