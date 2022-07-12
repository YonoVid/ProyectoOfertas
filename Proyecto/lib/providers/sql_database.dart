import 'package:ofertas_flutter/providers/provider_classes.dart';
import 'package:sqflite/sqflite.dart';

import 'package:path/path.dart' as path;

import '../model/offer_class.dart';

class SqlDatabase{

  late Future<Database> databaseOffer;

  SqlDatabase();

  //Se debe inicializar la interfaz antes de utilizarla
  Future<void> init() async {
    databaseOffer = openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      path.join(await getDatabasesPath(), 'offer_database.db'),
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        db.execute(
          'CREATE TABLE offer(id TEXT PRIMARY KEY, name TEXT, price INTEGER, category TEXT)',
        );
        db.execute(
          'CREATE TABLE category(id INTEGER PRIMARY KEY, name TEXT)',
        );
        return db.execute(
          'CREATE TABLE updates(name TEXT PRIMARY KEY, dateUpdate date)',
        );
      },
      onUpgrade: (db, versionOld, versionNew) {
        /*if (versionOld == 2) {
          db.execute(
            'DROP TABLE IF EXISTS offer',
          );
          db.execute(
            'CREATE TABLE offer(id TEXT PRIMARY KEY, name TEXT, price INTEGER, category TEXT)',
          );
        }
        if (versionOld == 1) {
          db.execute(
            'CREATE TABLE category(id INTEGER PRIMARY KEY, name TEXT)',
          );
          return db.execute(
            'CREATE TABLE updates(name TEXT PRIMARY KEY, dateUpdate date)',
          );
        }*/
      },
      version: 1,
    );
  }

  Future<void> addCategory(int id, String category) async {
    //Obtener referencia de la base de datos
    final db = await databaseOffer;
    try {
        await db.insert(
            'category',
            {
              'id': id,
              'name': category,
            },
            conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (e) {
      print("ERROR ADD CATEGORY (SQL)::" + e.toString());
      }
  }

  Future<Map<int, String>> getCategories() async {
    //Petición a base de datos local para obtener categorias
    final db = await databaseOffer;
    Map<int, String> categories = {};
    try {
      final List<Map<String, dynamic>> maps = await db.query('categories');
      for (var data in maps) {
        categories[data['id']] = data['name'];
      }
    } catch (e) {
      print(e.toString());
    }
    return categories;
  }

  Future<List<Offer>> getFavorites(Filter offerFilter) async {
    //Obtener referencia de la base de datos
    List<Offer> offers = [];
    final db = await databaseOffer;
    // Petición a base de datos local para obtener ofertas favoritas
    final List<Map<String, dynamic>> maps = await db.query('offer');

    // Convertir el mapa en una lista de objetos Offer
    for (var data in maps) {
      if (offerFilter.text != "" &&
          !(data['name'] as String)
              .toLowerCase()
              .contains(offerFilter.text) ||
          offerFilter.range.start >= data['price'] ||
          offerFilter.range.end <= data['price'] ||
          !offerFilter.inCategory(data['category'])) {
        continue;
      }
      offers.add(Offer(
          id: data['id'],
          name: data['name'],
          price: data['price'],
          category: data['category']));
    }
    return offers;
  }

  Future<bool> saveFavorite(Offer offer) async {
    //Obtener referencia de la base de datos
    final db = await databaseOffer;
    //Añadir oferta a la base de datos
    if ((await db.query('offer', where: 'id = ?', whereArgs: [(offer.id)]))
        .isEmpty) {
      await db.insert('offer', offer.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
      return true;
    } else {
      await db.delete('offer', where: 'id = ?', whereArgs: [offer.id]);
      return false;
    }
  }
}
