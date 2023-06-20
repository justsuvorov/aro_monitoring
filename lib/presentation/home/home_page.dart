import 'package:aro_monitoring/infrastructure/dep_objects.dart';
import 'package:aro_monitoring/presentation/home/widgets/home_body.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final String _title;
  final DepObjects _depObjects;
  ///
  const HomePage({
    super.key, 
    required String title,
    required DepObjects depObjects,
  }) : 
    _title = title, 
    _depObjects = depObjects;
  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(_title, style: const TextStyle(fontFamily: 'GPN_DIN', fontSize: 32),),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.home),
            tooltip: 'Главная страница',
            onPressed: () {
              // TODO route to be implemented
            },
          ),
        ],
      ),
      body: HomeBody(
        depObjects: _depObjects,
      ),
      backgroundColor: const Color.fromARGB(255, 28, 33, 37),
    );
  }
}