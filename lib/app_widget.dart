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
      home: const HomePage(
        title: 'Мониторинг АРО',
        depObjects: DepObjects(
          sqlQuery: SqlQuery(sql: 'Some real sql query to get required data'),
        ),
      ),
    );
  }
}
