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
            question: '¿Como Filtrar Ofertas?',
            answer: 'Debe apretar el simbolo del embudo el cual lo llevará a los filtros. '
                'Escoja la categoría que desee ver y ajuste el precio que desee. Luego de esto aprete el boton "Aplicar filtros". '
                'Si desea quitar los filtros seleccionados aprete el botón "Eliminar filtros".',
            imagen: Image.asset('assets/Filtros.png'),
          ),
          PreguntaCard(
            question: '¿Como Buscar Ofertas?',
            answer: 'Para realizar la búsqueda de un producto en oferta debe presionar en "Buscar término", luego ingrese el nombre del producto '
                'que desea buscar y este aparecera en la pantalla. Presione la "X" para eliminar la búsqueda y ver todas las ofertas',
            imagen: Image.asset('assets/Buscador.png'),
          ),
          PreguntaCard(
            question: '¿Como Guardar una Oferta?',
            answer: 'Para guardar una oferta debe apretar el botón en forma de corazón que se encuentra al lado derecho de la oferta. Una vez que '
                'el botón cambie de color a rojo significa que ha quedado guardada.',
            imagen: Image.asset('assets/Guardar_Preferencias.png'),
          ),
          PreguntaCard(
            question: '¿Como Ver Ofertas Guardadas?',
            answer: ' Para acceder a sus preferencias puede seleccionar el corazón en la parte superior de la pantalla Ofertas'
                ' o desde el menú ir a "Ofertas Guardadas".',
            imagen: Image.asset('assets/Encontrar_Ofertas.png'),
          ),
          PreguntaCard(
            question: '¿Como Reportar una Oferta Sospechosa?',
            answer: ' Si usted ve una oferta sospechosa debe presionar el botón de exclamación que esta a la derecha.'
                'Escoja la razón del reporte junto con su comentario del porque le resulta sospechosa.',
            imagen: Image.asset('assets/Reportar.png'),
          ),
          PreguntaCard(
              question: '¿Te gustan las galletas?',
              answer: 'No',
            imagen: Image.asset('assets/Galletas.PNG'),
          ),
          PreguntaCard(
            question: '¿Te gustan las marraquetas?',
            answer: 'Sipi',
            imagen: Image.asset('assets/Marraqueta.PNG'),
          ),
          PreguntaCard(
            question: '¿Son reales estos descuentos tan hermosos?',
            answer: 'Asies',
            imagen: Image.asset('assets/Ofertas.PNG'),
          ),
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
