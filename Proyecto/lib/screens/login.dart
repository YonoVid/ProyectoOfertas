import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:ofertas_flutter/widgets/labelcheckbox.dart';

class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();

}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    bool _Remember = false;

      return Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 150.0,
                  width: 190.0,
                  padding: EdgeInsets.only(top: 40),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(200),
                  ),
                  child: Center(
                    child: Image.asset('assets/logoTemp.png'),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Correo electrónico',
                        hintText: 'Ejemplo: usuario@correo.cl'),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        fillColor: Colors.white,
                        labelText: 'Constraseña',
                        hintText: 'Ingrese su contraseña'),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: LabeledCheckbox(
                        label: 'Recuerdame',
                        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0,),
                        value: false,
                        onChanged: (value){
                          //TODO RECUERDAME
                          setState(){
                            _Remember = !_Remember;
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
                      color: Colors.indigo[800], borderRadius: BorderRadius.circular(20)),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Login',
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
      );
    }
}