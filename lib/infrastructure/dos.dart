import 'package:aro_monitoring/infrastructure/sql/sql_query.dart';

///
class DepObjects {
  final SqlQuery _sqlQuery;
  ///
  DepObjects({
    required SqlQuery sqlQuery,
  }) :
    _sqlQuery = sqlQuery;
  ///
  /// returns all stored D.. Objects
  List<String> all() {
    if (_sqlQuery.valid()) {
      _sqlQuery.build();
      // TODO request to the sql source to be implemented...
    }
    return _doList;
  }  
}

/// 
/// temporary representations of the databases data
/// TODO to be deleted after database is connected
const List<String> _doList = [
  'Все ДО',
  'ГПН-Восток',
  'ГПН-ННГ',
  'ГПН-Оренбург',
  'ГПН-Хантос',
  'Мессояха',
  'СН-МНГ',
];
