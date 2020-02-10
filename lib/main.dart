import 'package:concourze/screens/pipelines.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Concourze',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: Pipelines(title: 'Concourze'),
    );
  }
}
