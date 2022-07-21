import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/local_class.dart';
import '../providers/app_state.dart';

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

  void openNamed(context, String name) {
    Navigator.popUntil(context, ModalRoute.withName("/"));
    Navigator.pushNamed(context, name);
  }

  @override
  Widget build(BuildContext context) {
    final drawerHeader = Consumer<AppState>(
      builder: (context, appState, _) => UserAccountsDrawerHeader(
        decoration: BoxDecoration(color: Colors.indigo[600]),
        accountName: Text(
          appState.user.name,
        ),
        accountEmail: Text(
          appState.user.email,
        ),
        currentAccountPicture: const CircleAvatar(
          child: FlutterLogo(size: 42.0),
        ),
      ),
    );
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.85,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 0.0, 100.0, 0.0),
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
                  Navigator.popUntil(
                      context, (Route<dynamic> route) => route.isFirst);
                },
              ),
              ListTile(
                title: Text(
                  "Ofertas",
                ),
                leading: const Icon(Icons.monetization_on_rounded),
                onTap: () {
                  openNamed(context, "/ofertas");
                  Provider.of<AppState>(context, listen: false).tabIndex = 0;
                },
              ),
              ListTile(
                title: Text("Ofertas guardadas"),
                leading: const Icon(Icons.favorite),
                onTap: () {
                  openNamed(context, "/ofertas");
                  Provider.of<AppState>(context, listen: false).tabIndex = 1;
                },
              ),
              const Divider(
                height: 20,
                thickness: 1,
                indent: 20,
                endIndent: 0,
                color: Colors.black,
              ),
              Consumer<AppState>(
                builder: (context, appState, _) {
                  if (appState.userLocal != null) {
                    return ListTile(
                      title: const Text("Gestionar local"),
                      leading: const Icon(Icons.manage_accounts_outlined),
                      onTap: () {
                        appState.hideData();
                        appState.setLocal(appState.userLocal as Local);
                        appState.getOffersOf((appState.userLocal as Local).id);
                        appState.getUserOffersOf();
                        openNamed(context, '/gestionar_local');
                      },
                    );
                  } else {
                    return ListTile(
                      title: const Text("Manejar un local"),
                      leading: const Icon(Icons.support_rounded),
                      onTap: () async{
                        openNamed(context, '/manejo_local');
                      },
                    );
                  }
                },
              ),
              ListTile(
                title: Text("Soporte"),
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
                  Provider.of<AppState>(context, listen: false).signOut();
                  openNamed(context, '/login');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
