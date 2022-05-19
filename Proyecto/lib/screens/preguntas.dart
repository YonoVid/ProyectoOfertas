import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:ofertas_flutter/screens/navigationDrawer.dart';

class Preguntas extends StatelessWidget {
  const Preguntas({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PREGUNTAS FRECUENTES'),
      ),
      body: ListView(
        children: [
          PreguntaCard(question: '¿Te gustan las galletas?', answer: 'No'),
          PreguntaCard(question: '¿Te gustan las marraquetas?', answer: 'Sipi'),
          PreguntaCard(question: '¿Son reales estos descuentos tan hermosos?', answer: 'Asies'),
        ],
      ),
      drawer: NavDrawer(
        username: 'Nombre de usuario',
        email: 'Correo',
      ),
    );
  }
}

class PreguntaCard extends StatelessWidget {
  const PreguntaCard({Key? key, required this.question, required this.answer})
      : super(key: key);

  final String question;
  final String answer;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
      color: Colors.brown[50],
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Column(
          children: [
            Text(
              question,
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                    answer,
                    style: TextStyle(
                      fontSize: 16
                    ),
                )),
          ],
        ),
      ),
    );
  }
}
