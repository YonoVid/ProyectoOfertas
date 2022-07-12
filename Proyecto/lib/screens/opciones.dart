import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:ofertas_flutter/screens/navigationDrawer.dart';
import 'package:provider/provider.dart';

import '../model/offer_class.dart';
import '../providers/app_state.dart';

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
  TextEditingController _inputController0 = TextEditingController();
  TextEditingController _inputController1 = TextEditingController();
  TextEditingController _inputController2 = TextEditingController();

  void msg(String msg) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
    ));
  }

  Future<void> changeName(context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Elegir un nuevo nombre de usuario'),
        content: IntrinsicHeight(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Nombre actual: \n' +
                    (Provider.of<AppState>(context, listen: false).user.name)),
              ),
              TextField(
                controller: _inputController0,
                maxLength: 30,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  fillColor: Colors.white,
                  labelText: 'Nuevo nombre de usuario',
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
            onPressed: () async{
              if (_inputController0.text.length >= 6) {
                Navigator.pop(context);
                if(await Provider.of<AppState>(context, listen: false)
                    .changeUsername(_inputController0.text))
                  {
                    _inputController0.clear();
                    msg("¡Nombre de usuario ha sido cambiada exitosamente!");
                  }
                else
                  {
                    msg("¡No se ha podido cambiar el nombre de usuario!");
                  }
              }
              else{
                msg("Nombre debe tener un mínimo 6 caracteres");
              }
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> changePassword(context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Elegir una nueva contraseña'),
        content: SingleChildScrollView(
          child: IntrinsicHeight(
            child: Column(
              children: [
                TextField(
                  controller: _inputController0,
                  maxLength: 16,
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    fillColor: Colors.white,
                    labelText: 'Contraseña actual',
                  ),
                ),
                TextField(
                  controller: _inputController1,
                  maxLength: 16,
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    fillColor: Colors.white,
                    labelText: 'Nueva contraseña',
                  ),
                ),
                TextField(
                  controller: _inputController2,
                  maxLength: 16,
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    fillColor: Colors.white,
                    labelText: 'Repetir nueva contraseña',
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              _inputController0.clear();
              _inputController1.clear();
              _inputController2.clear();
              Navigator.pop(context, "");
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (_inputController0.text != "" &&
                  _inputController1.text != "" &&
                  _inputController2.text != "") {
                //if (_inputPassword == _inputConfirmpassword) {
                if (_inputController1.text.length >= 6) {
                  if (_inputController1.text == _inputController2.text) {
                    bool test =
                        await Provider.of<AppState>(context, listen: false)
                            .changePassword(
                                _inputController0.text, _inputController1.text);
                    print("test: " + test.toString());
                    if (test) {
                      msg("¡La contraseña ha sido cambiada exitosamente!");
                      Navigator.pop(context);
                      _inputController0.clear();
                      _inputController1.clear();
                      _inputController2.clear();
                    } else {
                      msg("Ocurrio un error al intentar cambiar la contraseña");
                    }
                  } else {
                    msg("Las contraseñas no coinciden");
                  }
                } else {
                  msg("Las contraseña debe tener por lo menos 6 caracteres");
                }
              } else {
                msg("Se deben completar todos los campos");
              }
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

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
          title: 'Cambiar nombre de usuario',
          icon: Icons.person,
          onTap: changeName,
        ),
        ListOpcion(
          title: 'Cambiar contraseña',
          icon: Icons.security_update_outlined,
          onTap: changePassword,
        ),
        /*ListOpcion(
          title: 'Prueba opción',
          icon: Icons.settings_rounded,
          onTap: (){},
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
        ),*/
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
    required this.onTap,
  }) : super(key: key);

  final IconData icon;
  final String title;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: InkWell(
        onTap: () async {
          await onTap(context);
        },
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
      ),
    );
  }
}
