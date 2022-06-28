import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ofertas_flutter/screens/navigationDrawer.dart';
import 'package:ofertas_flutter/widgets/formbase.dart';
import 'package:provider/provider.dart';

import '../providers/app_state.dart';

class AgregarLocal extends StatefulWidget {
  const AgregarLocal({Key? key}) : super(key: key);

  @override
  State<AgregarLocal> createState() => _AgregarLocalState();
}

class _AgregarLocalState extends State<AgregarLocal> {

  final TextEditingController _inputName = TextEditingController();
  final TextEditingController _inputLocation = TextEditingController();

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
        title: Text("Solicitar nuevo local"),
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
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: _inputName,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Nombre de local',
                      hintText: 'Ejemplo: Verdurería el Poroto'),
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
                    if (_inputName.text != "") {
                      if (await Provider.of<AppState>(context, listen: false)
                          .sendLocal(_inputName.text)) {
                        Navigator.pop(context);
                        msg("¡La solicitud ha sido enviado exitosamente!");
                      } else {
                        msg("Ha ocurrido un error al enviar la oferta");
                      }
                    }
                    else{
                      msg("Se debe completar el campo de nombre");
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
