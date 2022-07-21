import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:ofertas_flutter/widgets/formbase.dart';
import 'package:ofertas_flutter/widgets/labelcheckbox.dart';
import 'package:provider/provider.dart';

import '../providers/app_state.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final TextEditingController _inputName = TextEditingController();
  final TextEditingController _inputEmail = TextEditingController();
  final TextEditingController _inputPassword = TextEditingController();
  final TextEditingController _inputConfirmpassword = TextEditingController();

  void msg(String msg){
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
    ));
  }

  @override
  Widget build(BuildContext context) {
    //bool _Remember = false;

    return Scaffold(
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
                padding: EdgeInsets.all(10),
                child: TextField(
                  maxLength: 30,
                  controller: _inputName,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Nombre de usuario',
                      hintText: 'Mínimo 6 caracteres'),
                ),
              ),
               Padding(
                padding: EdgeInsets.all(10),
                child: TextField(
                  controller: _inputEmail,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Correo electrónico',
                      hintText: 'Ejemplo: usuario@correo.cl'),
                ),
              ),
               Padding(
                padding: EdgeInsets.all(10),
                child: TextField(
                  obscureText: true,
                  maxLength: 16,
                  controller: _inputPassword,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      fillColor: Colors.white,
                      labelText: 'Contraseña',
                      hintText: 'Mínimo 8 caracteres y un símbolo'),
                ),
              ),
               Padding(
                padding: EdgeInsets.all(10),
                child: TextField(
                  obscureText: true,
                  maxLength: 16,
                  controller: _inputConfirmpassword,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      fillColor: Colors.white,
                      labelText: 'Confirmar contraseña'),
                ),
              ),
              Container(
                height: 50,
                width: 250,
                decoration: BoxDecoration(
                    color: Colors.indigo[800],
                    borderRadius: BorderRadius.circular(20)),
                child: TextButton(
                  onPressed: () async {
                    if (_inputName.text != "" && _inputEmail.text != "" && _inputPassword.text != "" && _inputConfirmpassword.text != "") {
                      if (_inputPassword.text == _inputConfirmpassword.text) {
                        if (await Provider.of<AppState>(context, listen: false)
                            .registerAccount(_inputEmail.text, _inputName.text, _inputPassword.text, (e) { })) {
                          Navigator.pop(context);
                          Navigator.pop(context);
                          msg("¡El usuario ha sido registrado exitosamente!, Ya puedes iniciar sesión");
                        } else {
                          msg("Ha ocurrido un error al registrar el usuario");
                        }
                      } else {
                        msg("Las contraseñas no coinciden");
                      }
                    }
                    else{
                      msg("Se deben completar todos los campos");
                    }
                  },
                  child: const Text(
                    'Registrarse',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  //TODO FORGOT PASSWORD SCREEN GOES HERE
                  Navigator.pop(context);
                },
                child: const Text(
                  '¿Ya tienes una cuenta?',
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
