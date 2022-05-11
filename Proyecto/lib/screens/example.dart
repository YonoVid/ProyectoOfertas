import 'package:flutter/material.dart';

class Example extends StatefulWidget {
  Example({Key? key}) : super(key: key);

  @override
  State<Example> createState() => _ExampleState();
}

class _ExampleState extends State<Example> {

  List<String> data = [
    "Example 1",
    "Example 2",
    "Example 3",
    "Example 4",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[200],
      body:Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  color: Colors.amberAccent,
                  child: Text("1"),
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.redAccent,
                  child: Text("2"),
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.indigoAccent,
                  child: Text("3"),
                ),
              ),
            ],
          ),
          Column(
            children: data.map((line) => Text(line)).toList(),
          )
        ],
      ),
    );
  }
}
