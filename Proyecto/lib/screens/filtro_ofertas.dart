import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:ofertas_flutter/screens/navigationDrawer.dart';
import 'package:provider/provider.dart';

import '../providers/app_state.dart';

class FiltroOfertas extends StatefulWidget {
  const FiltroOfertas({Key? key}) : super(key: key);

  @override
  State<FiltroOfertas> createState() => _FiltroOfertas();
}

class _FiltroOfertas extends State<FiltroOfertas> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("FILTROS"),
        centerTitle: true,
        backgroundColor: Colors.indigo[500],
        elevation: 0.0,
      ),
      body: OpcionesLista(),
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
  late RangeValues _priceRangeValues;
  TextEditingController _filterController = TextEditingController();

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_discreteValue, 'discrete_value');
  }

  @override
  void initState()
  {
    super.initState();
    _priceRangeValues = Provider.of<AppState>(context, listen: false).offerFilter.range;
  }

  @override
  void dispose() {
    _discreteValue.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, _) => ListView(
        children: [
          ListOpcion(
            title: Consumer<AppState>(
              builder: (context, appState, _) => Column(
                children: [
                  for(var key in appState.categories.keys)
                      CheckboxListTile(
                        title: Text(appState.categories[key] as String),
                        value: appState.stateCategories[key],
                        onChanged: (state) {
                          setState((){appState.stateCategories[key] = state!;});
                        },
                      ),
                ],
              ),
            ),
            icon: Icons.category_rounded,
          ),
          ListOpcion(
            title: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Rango de precio"),
                ),
                RangeSlider(
                  values: _priceRangeValues,
                  min: 0,
                  max: 100000,
                  divisions: 50,
                  labels: RangeLabels(
                      '\$' + _priceRangeValues.start.round().toString(),
                      '\$' + _priceRangeValues.end.round().toString()),
                  onChanged: (RangeValues newRange) {
                    setState(() {
                      _priceRangeValues = newRange;
                    });
                  },
                ),
              ],
            ),
            icon: Icons.price_check_rounded,
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                      color: Colors.indigo[800],
                      borderRadius: BorderRadius.circular(20)),
                  child: TextButton(
                    onPressed: () {
                      AppState appState = Provider.of<AppState>(context, listen: false);
                      appState.offerFilter.range = _priceRangeValues;
                      for(var key in appState.stateCategories.keys)
                      {
                        String category = appState.categories[key] as String;
                        if(appState.stateCategories[key] as bool)
                          {
                            appState.offerFilter.category.add(category);
                          }
                        else{
                          appState.offerFilter.category.remove(category);
                        }
                      }
                      Provider.of<AppState>(context, listen: false).reloadOffer();
                      print("FILTER:");
                      for(var data in appState.offerFilter.category)
                        {
                          print(data);
                        }
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Aplicar filtros',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                      color: Colors.indigo[800],
                      borderRadius: BorderRadius.circular(20)),
                  child: TextButton(
                    onPressed: () {
                      AppState appState = Provider.of<AppState>(context, listen: false);
                      setState(() {
                        _priceRangeValues = RangeValues(0, 100000);
                        _filterController.clear();
                        Filter filter =
                            Provider.of<AppState>(context, listen: false)
                                .offerFilter;
                        filter.text = "";
                        filter.range = RangeValues(0, 100000);
                        filter.category = {};
                        for(var key in appState.stateCategories.keys)
                          {
                            appState.stateCategories[key] = false;
                          }
                      });
                      appState.reloadOffer();
                    },
                    child: const Text(
                      'Eliminar filtros',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
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
  }) : super(key: key);

  final IconData icon;
  final Widget title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height / 10,
        ),
        color: Colors.brown[100],
        margin: EdgeInsets.all(1.0),
        padding: EdgeInsets.symmetric(horizontal: 30.0),
        child: Stack(
          children: [
            Positioned(
              top: 20.0,
              child: Center(
                child: Icon(icon),
              ),
            ),
            Center(child: Padding(
              padding: const EdgeInsets.fromLTRB(40.0,10.0,0.0,0.0),
              child: title,
            )),
          ],
        ),
      ),
    );
  }
}
