import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:ofertas_flutter/screens/navigationDrawer.dart';

class Soporte extends StatefulWidget {
  const Soporte({Key? key}) : super(key: key);

  @override
  State<Soporte> createState() => _SoporteState();
}

class _SoporteState extends State<Soporte> {
  String dropdownValue = 'Tipo de consulta';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SOPORTE"),
      ),
      drawer: NavDrawer(
        username: 'Nombre de usuario',
        email: 'Correo',
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 150.0,
                width: 190.0,
                padding: EdgeInsets.only(top: 40, bottom: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(200),
                ),
                child: Center(
                  child: Image.asset('assets/logoTemp.png'),
                ),
              ),
              Container(
                color: Colors.brown[50],
                child: DropdownButton<String>(
                  value: dropdownValue,
                  icon: const Icon(Icons.arrow_downward),
                  dropdownColor: Colors.brown[50],
                  elevation: 16,
                  style: const TextStyle(color: Colors.indigo),
                  underline: Container(
                    height: 2,
                    color: Colors.indigo,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue!;
                    });
                  },
                  items: <String>['Tipo de consulta',
                                  'Ingreso de ofertas',
                                  'Control de tienda',
                                  'Funcionamiento de la aplicación',
                                  'Otro',]
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(10),
                child: TextField(
                  keyboardType: TextInputType.multiline,
                  maxLines: 5,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Descripción de la Consulta',
                      hintText: 'Explique su problema'),
                ),
              ),
              Container(
                child: const Text(
                  'Añadir capturas de pantalla',
                  style: TextStyle(color: Colors.black, fontSize: 15),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 10, bottom: 200),
                child: Center(
                  child: CircleAvatar(
                    backgroundColor: Colors.blue,
                    radius: 25,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: Icon(Icons.add),
                      color: Colors.white,
                      onPressed: () {},
                    ),
                  ),
                ),
              ),
              Container(
                height: 50,
                width: 250,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20)),
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
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
