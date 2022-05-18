import 'package:flutter/material.dart';

class FormBase extends StatelessWidget {
  const FormBase({
    Key? key,
    required this.children,
  }) : super(key: key);

  final List<Widget> children;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
          color: Colors.brown[50],
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: children
        ),
      ),
    );
  }
}
