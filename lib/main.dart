import 'package:aro_monitoring/app_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


List companies = ['Все ДО', 'ГПН-Восток', 'ГПН-ННГ', 'ГПН-Оренбург', 'ГПН-Хантос', 'Мессояха', 'СН-МНГ'];
void main() {
  runApp(const MyApp());
}



class MonitoringTable {
  late final int id;
  late final String name;
  late final int age;
  late final int distancefromsun;
  ///
  MonitoringTable({
    required this.id,
    required this.name,
    required this.age,
    required this.distancefromsun,
  });
  ///
  MonitoringTable.fromMap(Map<String, dynamic> result)
      : id = result["id"],
        name = result["name"],
        age = result["age"],
        distancefromsun = result["distancefromsun"];
  Map<String, Object> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'distancefromsun': distancefromsun
    };
  }
}

