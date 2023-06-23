import 'package:aro_monitoring/infrastructure/api_address.dart';
import 'package:aro_monitoring/infrastructure/dep_objects.dart';
import 'package:aro_monitoring/infrastructure/sql/sql_query.dart';
import 'package:aro_monitoring/presentation/home/home_page.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Мониторинг АРО',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(
        title: 'Мониторинг АРО',
        depObjects: DepObjects(
          address: ApiAddress(host: '127.0.0.1', port: 8899),
          sqlQuery: SqlQuery(
            authToken: 'auth-token-test',
            sql: 'SELECT * FROM dep-objects',
          ),
        ),
      ),
    );
  }
}
