import 'package:aro_monitoring/app_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:logging/logging.dart';


List companies = ['Все ДО', 'ГПН-Восток', 'ГПН-ННГ', 'ГПН-Оренбург', 'ГПН-Хантос', 'Мессояха', 'СН-МНГ'];
void main() {
  Logger.root.level = Level.INFO;  
  runApp(const MyApp());
}
