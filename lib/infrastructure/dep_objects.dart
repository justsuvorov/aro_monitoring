import 'package:aro_monitoring/domain/core/result/result.dart';
import 'package:aro_monitoring/infrastructure/api_address.dart';
import 'package:aro_monitoring/infrastructure/api_request.dart';
import 'package:aro_monitoring/infrastructure/sql/sql_query.dart';
import 'package:logging/logging.dart';

///
class DepObjects {
  final _log = Logger('DepObjects');
  final ApiAddress _address;
  final SqlQuery _sqlQuery;
  ///
  DepObjects({
    required ApiAddress address,
    required SqlQuery sqlQuery,
  }) :
    _address = address,
    _sqlQuery = sqlQuery;
  ///
  /// returns all stored D.. Objects
  Future<Result<List<String>>> all() {
    if (_sqlQuery.valid()) {
      final apiRequest = ApiRequest(
        address: _address, 
        sqlQuery: _sqlQuery,
      );
      return apiRequest.fetch().then((result) {
        _log.fine('.all | result: $result');
        return result.fold(
          onData: (apiReply) {
            final data = apiReply.data.map((row) {
              _log.fine('.all | row: $row');
              return row.toString();
            });
            return Result(data: data.toList());
          }, 
          onError: (error) {
            return Result(error: error);
          },
        );
      });
    }
    return Future.delayed(const Duration(milliseconds: 1200)).then((_) {
      return const Result(data: _doList);
    });
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
