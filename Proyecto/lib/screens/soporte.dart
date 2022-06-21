import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ofertas_flutter/screens/navigationDrawer.dart';
import 'package:ofertas_flutter/widgets/formbase.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';

class Soporte extends StatefulWidget {
  const Soporte({Key? key}) : super(key: key);

  @override
  State<Soporte> createState() => _SoporteState();
}

class _SoporteState extends State<Soporte> {
  String _dropdownValue = 'Tipo de consulta';
  final List<String> _items = <String>[
    'Tipo de consulta',
    'Ingreso de ofertas',
    'Control de tienda',
    'Funcionamiento de la aplicación',
    'Otro',
  ];
  final TextEditingController _inputDescription = TextEditingController();

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
        title: Text("SOPORTE"),
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
                      Icons.support_rounded,
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
              Container(
                height: MediaQuery.of(context).size.height / 3,
                width: 250,
                child: TextField(
                  controller: _inputDescription,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      fillColor: Colors.white,
                      labelText: 'Comentarios',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      hintText: 'Describe tu problema'),
                  textInputAction: TextInputAction.newline,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  minLines: 10,
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
                    if (_items[0] != _dropdownValue && _inputDescription.text != "") {
                      if (await Provider.of<AppState>(context, listen: false)
                          .sendConsult(
                              _dropdownValue, _inputDescription.text)) {
                        msg("¡La consulta ha sido enviado exitosamente!");
                        Navigator.pop(context);
                      } else {
                        msg("Ha ocurrido un error al enviar la consulta");
                        Navigator.pop(context);
                      }
                    }
                    else{msg("Debes elegir un tipo de consulta y describir tu problema");}
                  },
                  child: const Text(
                    'Enviar consulta',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      drawer: NavDrawer(
        username: 'Nombre de usuario',
        email: 'Correo',
      ),
    );
  }
}
