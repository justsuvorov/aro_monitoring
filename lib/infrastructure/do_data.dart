import 'package:aro_monitoring/domain/core/error/failure.dart';
import 'package:aro_monitoring/domain/core/result/result.dart';
import 'package:aro_monitoring/infrastructure/api_address.dart';
import 'package:aro_monitoring/infrastructure/api_request.dart';
import 'package:aro_monitoring/infrastructure/sql/sql_query.dart';
import 'package:logging/logging.dart';

class DoData {
  final _log = Logger('DoData');
  final ApiAddress _address;
  final SqlQuery _sqlQuery;
  ///
  DoData({
    required ApiAddress address,
    required SqlQuery sqlQuery,
  }) :
    _address = address,
    _sqlQuery = sqlQuery;
  ///
  /// returns all stored D.. Objects
  Future<Result<List<Map<String, dynamic>>>> all() async {
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
              return row['name'].toString();
            });
            return Result(data: apiReply.data);
          }, 
          onError: (error) {
            return Result(error: error);
          },
        );
      });
    }
    return Future.delayed(const Duration(milliseconds: 100)).then((_) {
      return Result(
        error: Failure(message: '[DoData.all] error: SQL query is empty', stackTrace: StackTrace.current),
      );
    });
  }  
}
