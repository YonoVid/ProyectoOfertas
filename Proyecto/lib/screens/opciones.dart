import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:ofertas_flutter/screens/navigationDrawer.dart';

class Opciones extends StatefulWidget {
  const Opciones({Key? key}) : super(key: key);

  @override
  State<Opciones> createState() => _OpcionesState();
}

class _OpcionesState extends State<Opciones> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("OPCIONES"),
        centerTitle: true,
        backgroundColor: Colors.indigo[500],
        elevation: 0.0,
      ),
      body: OpcionesLista(),
      drawer: NavDrawer(
        username: 'Nombre de usuario',
        email: 'Correo',
      ),
    );
  }
}

class OpcionesLista extends StatefulWidget {
  const OpcionesLista({Key? key}) : super(key: key);

  @override
  State<OpcionesLista> createState() => _OpcionesListaState();
}

class _OpcionesListaState extends State<OpcionesLista> with RestorationMixin {
  final RestorableDouble _discreteValue = RestorableDouble(20);

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_discreteValue, 'discrete_value');
  }

  @override
  void dispose() {
    _discreteValue.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListOpcion(
          title: 'Prueba opción',
          icon: Icons.person,
        ),
        ListOpcion(
          title: 'Prueba opción',
          icon: Icons.location_on_rounded,
        ),
        ListOpcion(
          title: 'Prueba opción',
          icon: Icons.settings_rounded,
        ),
        Container(
          color: Colors.brown[100],
          height: MediaQuery.of(context).size.height / 10,
          margin: EdgeInsets.all(1.0),
          padding: EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Slider(
                value: _discreteValue.value,
                min: 0,
                max: 200,
                divisions: 5,
                label: _discreteValue.value.round().toString(),
                onChanged: (value) {
                  setState(() {
                    _discreteValue.value = value;
                  });
                },
              ),
              Text("Distancia de búsqueda"),
            ],
          ),
        ),
      ],
    );
  }

  @override
  // TODO: implement restorationId
  String? get restorationId => "opciones_ofertas";
}

class ListOpcion extends StatelessWidget {
  const ListOpcion({
    Key? key,
    required this.icon,
    required this.title,
  }) : super(key: key);

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        color: Colors.brown[100],
        height: MediaQuery.of(context).size.height / 10,
        margin: EdgeInsets.all(1.0),
        padding: EdgeInsets.symmetric(horizontal: 30.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: Center(
                child: Icon(icon),
              ),
            ),
            Expanded(
              flex: 3,
              child: Center(
                child: Text(
                  title,
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
