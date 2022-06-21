import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ofertas_flutter/screens/navigationDrawer.dart';
import 'package:ofertas_flutter/widgets/formbase.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';

class Reporte extends StatefulWidget {
  const Reporte({Key? key}) : super(key: key);

  @override
  State<Reporte> createState() => _ReporteState();
}

class _ReporteState extends State<Reporte> {
  String _dropdownValue = 'Causa del reporte';
  final List<String> _items = [
    'Causa del reporte',
    'La oferta no existe',
    'No es el producto indicado',
    'Precio incorrecto',
    'La oferta ha terminado',
    'Otro',
  ];
  bool _showTextBox = true; //false;
  final TextEditingController _inputDescription = TextEditingController();

  void msg(String msg){
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
    ));
  }
  @override
  Widget build(BuildContext context) {
    Offer? offer = Provider.of<AppState>(context, listen: false).offerSelected;
    return Scaffold(
      appBar: AppBar(
        title: Text("REPORTAR"),
        centerTitle: true,
        backgroundColor: Colors.indigo[500],
        elevation: 0.0,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: FormBase(
            children: [
              Card(
                color: Colors.indigo[500],
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.13,
                  margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                  padding: const EdgeInsets.all(10.0),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(90.0, 0.0, 0.0, 0.0),
                    child: DefaultTextStyle(
                      style: TextStyle(color: Colors.brown[50]),
                      child: ListTile(
                        title: Text(
                          offer!.name,
                          style: TextStyle(color: Colors.brown[50]),
                        ),
                        subtitle: Text(
                          "\$" + offer.price.toString(),
                          style: TextStyle(color: Colors.brown[50]),
                        ),
                        style: ListTileStyle.list,
                      ),
                    ),
                  ),
                ),
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
                      //Método que permite ocultar la caja de texto
                      /*if(newValue == _items.last) {
                        _showTextBox = true;
                      } else {
                        _showTextBox = false;
                      }*/
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
              Visibility(
                visible: _showTextBox,
                child: Container(
                  height: MediaQuery.of(context).size.height / 3,
                  width: 250,
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
              ),
              Container(
                height: 50,
                width: 250,
                decoration: BoxDecoration(
                    color: Colors.indigo[600],
                    borderRadius: BorderRadius.circular(20)),
                child: TextButton(
                  onPressed: () async {
                    if (_items[0] != _dropdownValue) {
                      if (await Provider.of<AppState>(context, listen: false)
                          .sendReport(_dropdownValue, _inputDescription.text)) {
                        Navigator.pop(context);
                        msg("¡El reporte ha sido enviado exitosamente!");
                      } else {
                        Navigator.pop(context);
                        msg("Ha ocurrido un error al enviar el reporte");
                      }
                    }
                    else{
                      msg("Se debe elegir la causa del reporte");
                    }
                  },
                  child: const Text(
                    'Reportar',
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
