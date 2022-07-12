import 'package:flutter/material.dart';
import 'package:ofertas_flutter/screens/navigationDrawer.dart';
import 'package:provider/provider.dart';

import '../model/offer_class.dart';
import '../providers/app_state.dart';

class GestionarLocal extends StatefulWidget {
  const GestionarLocal({Key? key}) : super(key: key);

  @override
  State<GestionarLocal> createState() => _GestionarLocalState();
}

class _GestionarLocalState extends State<GestionarLocal> {
  String _dropDownCategoryDefault = "Categoría de la oferta";
  String _dropDownValue = "Categoría de la oferta";
  TextEditingController _inputController0 = TextEditingController();
  TextEditingController _inputController1 = TextEditingController();

  Future<void> changeLocalName(context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Elegir un nuevo nombre de local'),
        content: IntrinsicHeight(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Nombre actual: \n' +
                    (Provider.of<AppState>(context, listen: false)
                        .userLocal
                        ?.name as String)),
              ),
              TextField(
                controller: _inputController0,
                maxLength: 30,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  fillColor: Colors.white,
                  labelText: 'Nuevo nombre de local',
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _inputController0.clear();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (_inputController0.text.length >= 6) {
                Navigator.pop(context);
                if (await Provider.of<AppState>(context, listen: false)
                    .changeLocalName(_inputController0.text)) {
                  _inputController0.clear();
                  msg("¡Nombre de usuario ha sido cambiada exitosamente!");
                }
              } else {
                msg("Nombre debe tener un mínimo 6 caracteres");
              }
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> formLocalOffer(context, Function function, Offer offer) async {
    if (offer.id != "-1") {
      _inputController0.text = offer.name;
      _inputController1.text = offer.price.toString();
      _dropDownValue = offer.category;
    }
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Crear nueva oferta'),
        content: SingleChildScrollView(
          child: IntrinsicHeight(
            child: Column(
              children: [
                TextField(
                  controller: _inputController0,
                  maxLength: 30,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    fillColor: Colors.white,
                    labelText: 'Nombre de la oferta',
                  ),
                ),
                TextField(
                  controller: _inputController1,
                  keyboardType: TextInputType.number,
                  maxLength: 30,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    fillColor: Colors.white,
                    labelText: 'Precio de la oferta',
                  ),
                ),
                Container(
                  color: Colors.brown[50],
                  padding: EdgeInsets.all(10.0),
                  child: Consumer<AppState>(
                    builder: (context, appState, _) => StatefulBuilder(
                      builder: (context, dropDownState) => DropdownButton<String>(
                        value: _dropDownValue,
                        icon: const Icon(Icons.arrow_downward),
                        dropdownColor: Colors.brown[50],
                        elevation: 16,
                        style:
                        const TextStyle(fontSize: 16.0, color: Colors.indigo),
                        underline: Container(
                          height: 2,
                          color: Colors.indigo,
                        ),
                        onChanged: (String? newValue) {
                          dropDownState(() {
                            _dropDownValue = newValue as String;
                          });
                        },
                        items: [
                          DropdownMenuItem<String>(
                            value: _dropDownCategoryDefault,
                            child: Text(_dropDownCategoryDefault),
                          )
                        ] +
                            appState.categories.values
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _inputController0.clear();
              _inputController1.clear();
              _dropDownValue = _dropDownCategoryDefault;
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (_dropDownCategoryDefault != _dropDownValue &&
                  _inputController0.text != "" &&
                  _inputController1.text != "") {
                if (await function(Offer(
                    id: offer.id,
                    name: _inputController0.text,
                    price: int.parse(_inputController1.text),
                    category: _dropDownValue))) {
                  _inputController0.clear();
                  _inputController1.clear();
                  _dropDownValue = _dropDownCategoryDefault;
                  Navigator.pop(context);
                  msg("¡La oferta ha sido enviado exitosamente!");
                } else {
                  msg("Ha ocurrido un error al enviar la oferta");
                }
              } else {
                msg("Se debe completar el campo de nombre, precio y categoría");
              }
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void msg(String msg) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MANEJAR LOCAL"),
        centerTitle: true,
        backgroundColor: Colors.indigo[500],
        elevation: 0.0,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
              decoration: BoxDecoration(
                  color: Colors.indigo[500],
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              child: Stack(children: [
                Positioned(
                  top: 10,
                  left: 120,
                  right: 20,
                  child: Container(
                    margin:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
                    color: Colors.indigo[500],
                    child: Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: Consumer<AppState>(
                            builder: (context, appState, _) => Text(
                              (appState.userLocal?.name == null)
                                  ? ""
                                  : appState.userLocal?.name as String,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.brown[50],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: IconButton(
                              onPressed: () async =>
                              await changeLocalName(context),
                              icon: Icon(Icons.edit),
                              color: Colors.brown[50]),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 80.0,
                  left: 125.0,
                  child: Container(
                    padding:
                    EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                    decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(20)),
                    child: TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Cambiar plan',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 20.0,
                  left: 20.0,
                  child: Container(
                    height: 75.0,
                    width: 75.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage('assets/ofertas.png')),
                      color: Colors.brown[100],
                      border: Border.all(width: 2.0, color: Colors.indigo),
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ),
              ]),
            ),
          ),
          Expanded(
            flex: 5,
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
              decoration: BoxDecoration(
                  color: Colors.brown[100],
                  // Red border with the width is equal to 5
                  border: Border.all(width: 5, color: Colors.indigo)),
              child: Consumer<AppState>(
                builder: (context, appState, _) => ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    for (var data in appState.offersSelected)
                      LocalOfertas(
                        thumbnail: Container(),
                        offer: data,
                        functionLocalOffer: formLocalOffer,
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async => await formLocalOffer(
            context,
            Provider.of<AppState>(context, listen: false).sendOffer,
            Offer(
              id: "-1",
              name: "",
              price: -1,
              category: "",
            )),
        label: Text("Nueva oferta"),
        icon: const Icon(Icons.add_circle_outline_rounded),
      ),
      drawer: NavDrawer(
        username: 'Nombre de usuario',
        email: 'Correo',
      ),
    );
  }
}

class LocalOfertas extends StatelessWidget {
  const LocalOfertas({
    Key? key,
    required this.thumbnail,
    required this.offer,
    required this.functionLocalOffer,
  }) : super(key: key);

  final Widget thumbnail;
  final Offer offer;
  final Function functionLocalOffer;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        color: Colors.brown[100],
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Container(
                decoration: const BoxDecoration(color: Colors.brown),
                child: Icon(Icons.emoji_food_beverage_rounded),
                height: 80.0,
              ),
            ),
            Expanded(
              flex: 3,
              child: _OfertasDatos(
                name: offer.name,
                price: "\$" + offer.price.toString(),
                location: "null",
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                      child: Consumer<AppState>(
                        builder: (context, appState, _) => IconButton(
                            onPressed: () {
                              functionLocalOffer(
                                  context,
                                  Provider.of<AppState>(context, listen: false)
                                      .updateLocalOffer,
                                  offer);
                            },
                            icon: Icon(
                              Icons.edit,
                              color: (appState.favoritesId.contains(offer.id))
                                  ? Colors.redAccent
                                  : Colors.brown[50],
                            )),
                      )),
                  Flexible(
                      child: IconButton(
                          onPressed: () {
                            Provider.of<AppState>(context, listen: false)
                                .removeOffer(offer);
                          },
                          icon: Icon(Icons.remove_circle_outline),
                          color: Colors.brown[50])),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OfertasDatos extends StatelessWidget {
  const _OfertasDatos({
    Key? key,
    required this.name,
    required this.location,
    required this.price,
  }) : super(key: key);

  final String name;
  final String price;
  final String location;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5.0, 5.0, 0.0, 10.0),
      child: Column(
        children: [
          Text(
            name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 14.0,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 1.0, vertical: 5.0),
            child: Text(
              location,
              style: TextStyle(
                fontSize: 10.0,
              ),
            ),
          ),
          Text(
            price,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14.0,
            ),
          ),
        ],
      ),
    );
  }
}
