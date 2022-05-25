import 'package:flutter/material.dart';

// Press the Navigation Drawer button to the left of AppBar to show
// a simple Drawer with two items.
class NavDrawer extends Drawer {
  const NavDrawer({
    Key? key,
    required this.username,
    required this.email,
  }) : super(key: key);


  final String username;
  final String email;

  void openNamed(context, String name)
  {
    Navigator.popUntil(context, ModalRoute.withName("/"));
    Navigator.pushNamed(context, name);
  }

  @override
  Widget build(BuildContext context) {
    final drawerHeader = UserAccountsDrawerHeader(
      decoration: BoxDecoration(
        color: Colors.indigo[600]
      ),
      accountName: Text(
        username,
      ),
      accountEmail: Text(
        email,
      ),
      currentAccountPicture: const CircleAvatar(
        child: FlutterLogo(size: 42.0),
      ),
    );
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.85,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0.0,0.0,100.0,0.0),
        child: Container(
          color: Colors.brown[50],
          child: ListView(
            children: [
              drawerHeader,
              ListTile(
                title: Text(
                  "Mapa",
                ),
                leading: const Icon(Icons.location_on_rounded),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.popUntil(context, (Route<dynamic> route) => route.isFirst );
                },
              ),
              ListTile(
                title: Text(
                  "Ofertas",
                ),
                leading: const Icon(Icons.monetization_on_rounded),
                onTap: () {
                  openNamed(context, "/ofertas");
                },
              ),
              ListTile(
                title: Text("Ofertas guardadas"),
                leading: const Icon(Icons.favorite),
                onTap: () {
                  openNamed(context, "/ofertas");
                },
              ),
              const Divider(
                height: 20,
                thickness: 1,
                indent: 20,
                endIndent: 0,
                color: Colors.black,
              ),
              ListTile(
                title: Text("Soporte"),
                leading: const Icon(Icons.support_rounded),
                onTap: () {
                  openNamed(context, '/soporte');
                },
              ),
              ListTile(
                title: Text("Preguntas frecuentes"),
                leading: const Icon(Icons.question_answer_rounded),
                onTap: () {
                  openNamed(context, '/preguntas');
                },
              ),
              ListTile(
                title: Text("Opciones"),
                leading: const Icon(Icons.settings_rounded),
                onTap: () {
                  openNamed(context, '/opciones');
                },
              ),
              ListTile(
                title: Text("Cerrar sesión"),
                leading: const Icon(Icons.person_pin),
                onTap: () {
                  Navigator.pushNamedAndRemoveUntil(context, '/login', ModalRoute.withName("/"));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
