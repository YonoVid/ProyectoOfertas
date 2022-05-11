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

  @override
  Widget build(BuildContext context) {
    final drawerHeader = UserAccountsDrawerHeader(
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
        padding: const EdgeInsets.fromLTRB(0.0,0.0,125.0,0.0),
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
                  Navigator.pushNamedAndRemoveUntil(context, '/', (Route<dynamic> route) => route.isFirst );
                },
              ),
              ListTile(
                title: Text(
                  "Ofertas",
                ),
                leading: const Icon(Icons.monetization_on_rounded),
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/ofertas');
                },
              ),
              ListTile(
                title: Text("Ofertas guardadas"),
                leading: const Icon(Icons.favorite),
                onTap: () {
                  Navigator.pop(context);
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
                  Navigator.pushNamedAndRemoveUntil(context, '/soporte', (Route<dynamic> route) => route.isFirst );
                },
              ),
              ListTile(
                title: Text("Preguntas frecuentes"),
                leading: const Icon(Icons.question_answer_rounded),
                onTap: () {
                  Navigator.pushNamedAndRemoveUntil(context, '/preguntas', (Route<dynamic> route) => route.isFirst );
                },
              ),
              ListTile(
                title: Text("Cerrar sesión"),
                leading: const Icon(Icons.person_pin),
                onTap: () {
                  Navigator.pushNamedAndRemoveUntil(context, '/login', (Route<dynamic> route) => route.isFirst );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
