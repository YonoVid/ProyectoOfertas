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
          PreguntaCard(
            question: '¿Cómo filtrar ofertas?',
            answer: 'Debe apretar el simbolo del embudo el cual lo llevará a los filtros. '
                'Escoja la categoría que desee ver y ajuste el precio que desee. Luego de esto aprete el boton "Aplicar filtros". '
                'Si desea quitar los filtros seleccionados aprete el botón "Eliminar filtros".',
            imagen: Image.asset('assets/filtros.png'),
          ),
          PreguntaCard(
            question: '¿Cómo buscar ofertas?',
            answer: 'Para realizar la búsqueda de un producto en oferta debe presionar en "Buscar término", luego ingrese el nombre del producto '
                'que desea buscar y este aparecera en la pantalla. Presione la "X" para eliminar la búsqueda y ver todas las ofertas',
            imagen: Image.asset('assets/buscador.png'),
          ),
          PreguntaCard(
            question: '¿Cómo guardar una oferta?',
            answer: 'Para guardar una oferta debe apretar el botón en forma de corazón que se encuentra al lado derecho de la oferta. Una vez que '
                'el botón cambie de color a rojo significa que ha quedado guardada.',
            imagen: Image.asset('assets/guardar_Preferencias.png'),
          ),
          PreguntaCard(
            question: '¿Cómo ver ofertas guardadas?',
            answer: ' Para acceder a sus preferencias puede seleccionar el corazón en la parte superior de la pantalla Ofertas'
                ' o desde el menú ir a "Ofertas Guardadas".',
            imagen: Image.asset('assets/encontrar_Ofertas.png'),
          ),
          PreguntaCard(
            question: '¿Cómo reportar una oferta sospechosa?',
            answer: ' Si usted ve una oferta sospechosa debe presionar el botón de exclamación que esta a la derecha.'
                'Escoja la razón del reporte junto con su comentario del porque la oferta le resulta sospechosa.',
            imagen: Image.asset('assets/reportar.png'),
          ),
          PreguntaCard(
            question: '¿Te gustan las galletas?',
            answer: 'No',
            imagen: Image.asset('assets/galletas.png'),
          ),
          PreguntaCard(
            question: '¿Te gustan las marraquetas?',
            answer: 'Sipi',
            imagen: Image.asset('assets/marraqueta.png'),
          ),
          PreguntaCard(
            question: '¿Son reales estos descuentos tan hermosos?',
            answer: 'Asies',
            imagen: Image.asset('assets/ofertas.png'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/soporte');
        },
        label: Text("Nueva consulta"),
        icon: const Icon(Icons.call),
      ),
      drawer: NavDrawer(
        username: 'Nombre de usuario',
        email: 'Correo',
      ),
    );
  }
}

class PreguntaCard extends StatelessWidget {
  const PreguntaCard({Key? key, required this.question, required this.answer, required this.imagen})
      : super(key: key);

  final String question;
  final String answer;
  final Image imagen;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
      color: Colors.brown[50],
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        child: Column(
          children: [
            Text(
              question,
              textAlign: TextAlign.center,
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
            Container(
              child: imagen,
            ),
          ],
        ),
      ),
    );
  }
}
