import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:ofertas_flutter/widgets/labelcheckbox.dart';
import 'package:ofertas_flutter/widgets/formbase.dart';
import 'package:provider/provider.dart';

import '../providers/app_state.dart';

class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _Remember = false;
  RestorableBoolN checkFormBool = RestorableBoolN(false);

  @override
  void initState(){
    super.initState();
    checkLoggedUser();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    checkFormBool.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
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
                  child: Center(child: const FlutterLogo(size: 100.0)),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Correo electrónico',
                        hintText: 'Ejemplo: usuario@correo.cl'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    obscureText: true,
                    controller: passwordController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        fillColor: Colors.white,
                        labelText: 'Contraseña',
                        hintText: 'Ingresa tu contraseña'),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: LabeledCheckbox(
                        label: 'Recuérdame',
                        padding: const EdgeInsets.symmetric(
                          vertical: 10.0,
                          horizontal: 5.0,
                        ),
                        value: _Remember,
                        onChanged: (value) {
                          //TODO RECUERDAME
                          setState() {
                            _Remember = value;
                          }
                        },
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        //TODO CONTRASEÑA OLVIDADA
                      },
                      child: const Text(
                        'Forgot Password',
                        style: TextStyle(color: Colors.indigo, fontSize: 15),
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 50,
                  width: 250,
                  decoration: BoxDecoration(
                      color: Colors.indigo[800],
                      borderRadius: BorderRadius.circular(20)),
                  child: TextButton(
                    onPressed: () async {
                      print("Trying login");
                      await Provider.of<AppState>(context, listen:false).signInWithEmailAndPassword(
                          emailController.text, passwordController.text, (e) {});
                      if (Provider.of<AppState>(context, listen:false).isLogged()) {
                        Navigator.pop(context);
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => _buildPopupDialog(
                              context,
                              "ERROR",
                              "El correo o la contraseña ingresada no son correctos"),
                        );
                      }
                    },
                    child: const Text(
                      'Ingresar',
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  child: const Text(
                    '¿Eres nuevo? Crea una cuenta',
                    style: TextStyle(color: Colors.black, fontSize: 15),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void checkLoggedUser() async{
    var user = await FirebaseAuth.instance.currentUser;
    print("Searching user");
    if(user != null){
      print("User found");
      Navigator.pop(context);
    }
    else
    {
      // log in
      print("User NOT found");
      //Datos por defecto para debug, eliminar para Release
      emailController.text="lostresalgoingenioso@gmail.com";
      passwordController.text="123456";
    }
  }

}



Widget _buildPopupDialog(BuildContext context, String title, String msg) {
  return AlertDialog(
    title: Text(title),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(msg),
      ],
    ),
    actions: <Widget>[
      TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: const Text('Cerrar'),
      ),
    ],
  );
}
