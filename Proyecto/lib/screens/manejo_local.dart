import 'package:flutter/material.dart';
import 'package:ofertas_flutter/screens/navigationDrawer.dart';
import 'package:provider/provider.dart';

import '../model/localClass.dart';
import '../model/offerClass.dart';
import '../providers/app_state.dart';
import '../widgets/formbase.dart';

class ManejoLocal extends StatefulWidget {
  const ManejoLocal({Key? key}) : super(key: key);

  @override
  State<ManejoLocal> createState() => _ManejoLocalState();
}

class _ManejoLocalState extends State<ManejoLocal> {
  String _dropDownCategoryDefault = "Elegir local";
  String _dropDownValue = "Elegir local";
  TextEditingController _inputDescription = TextEditingController();

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
                child: Consumer<AppState>(
                  builder: (context, appState, _) => DropdownButton<String>(
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
                      setState(() {
                        _dropDownValue = newValue!;
                      });
                    },
                    items: [
                      DropdownMenuItem<String>(
                        value: _dropDownCategoryDefault,
                        child: Text(_dropDownCategoryDefault),
                      )
                    ] +
                        appState.locals.values
                            .map<DropdownMenuItem<String>>((Local value) {
                          return DropdownMenuItem<String>(
                            value: value.id,
                            child: Text(value.name),
                          );
                        }).toList(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: _inputDescription,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      fillColor: Colors.white,
                      labelText: 'Comentarios (opcional)',
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
                    if (_dropDownValue != _dropDownCategoryDefault &&
                        _inputDescription.text != "") {
                      if (false) {
                        Navigator.pop(context);
                        msg("¡La oferta ha sido enviado exitosamente!");
                      } else {
                        msg("Ha ocurrido un error al enviar la oferta");
                      }
                    } else {
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
      drawer: NavDrawer(
        username: 'Nombre de usuario',
        email: 'Correo',
      ),
    );
  }
}