import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ofertas_flutter/screens/navigationDrawer.dart';
import 'package:ofertas_flutter/widgets/formbase.dart';
import 'package:provider/provider.dart';

import '../providers/app_state.dart';

class AgregarOferta extends StatefulWidget {
  const AgregarOferta({Key? key}) : super(key: key);

  @override
  State<AgregarOferta> createState() => _AgregarOfertaState();
}

class _AgregarOfertaState extends State<AgregarOferta> {
  String _dropdownValue = 'Tipo de producto';
  final List<String> _items = <String>[
    'Tipo de producto',
    'Frutas',
    'Verduras',
    'Despensa',
    'Productos higiene',
    'Medicamento',
    'Articulos de aseo',
    'Otro',
  ];

  final TextEditingController _inputName = TextEditingController();
  final TextEditingController _inputPrice = TextEditingController();

  void msg(String msg){
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AGREGAR OFERTA"),
        centerTitle: true,
        backgroundColor: Colors.indigo[500],
        elevation: 0.0,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: FormBase(
            children: [
              Container(
                height: 150.0,
                width: 150.0,
                decoration: BoxDecoration(
                  color: Colors.brown[100],
                  borderRadius: BorderRadius.circular(200),
                ),
                child: const FittedBox(
                    fit: BoxFit.cover,
                    child: Icon(
                      Icons.price_check_rounded,
                    )),
              ),
              Container(
                color: Colors.brown[50],
                margin: EdgeInsets.symmetric(vertical: 15.0),
                child: DropdownButton<String>(
                  value: _dropdownValue,
                  icon: const Icon(Icons.arrow_downward),
                  dropdownColor: Colors.brown[50],
                  elevation: 16,
                  style: const TextStyle(fontSize: 16.0, color: Colors.indigo),
                  underline: Container(
                    height: 2,
                    color: Colors.indigo,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      _dropdownValue = newValue!;
                    });
                  },
                  items: _items.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: _inputName,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Nombre de producto',
                      hintText: 'Ejemplo: Pasta Carozzi'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: _inputPrice,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Precio del producto',
                      hintText: 'Ejemplo: 1.000'),
                ),
              ),
              Container(
                height: 50,
                width: 250,
                decoration: BoxDecoration(
                    color: Colors.indigo[600],
                    borderRadius: BorderRadius.circular(20)),
                child: TextButton(
                  onPressed: () async {
                    if (_items[0] != _dropdownValue && _inputName.text != "" && _inputPrice.text != "") {
                      if (await Provider.of<AppState>(context, listen: false)
                          .sendOffer(_inputName.text, _inputPrice.text, _dropdownValue)) {
                        Navigator.pop(context);
                        msg("¡La oferta ha sido enviado exitosamente!");
                      } else {
                        msg("Ha ocurrido un error al enviar la oferta");
                      }
                    }
                    else{
                      msg("Se debe completar el campo de nombre y precio");
                    }
                  },
                  child: const Text(
                    'Enviar',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
