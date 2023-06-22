import 'package:aro_monitoring/infrastructure/sql/sql_query.dart';

class ApiRequest {
  final SqlQuery _sqlQuery;
  ApiRequest({
    required SqlQuery sqlQuery,
  }) :
    _sqlQuery = sqlQuery;
  ///
  /// exequtes created sql query to the remote
  /// returns reply if exists
  Future<void> fetch() {

  }
}