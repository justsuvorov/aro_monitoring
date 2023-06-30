import 'package:aro_monitoring/domain/core/error/failure.dart';
import 'package:aro_monitoring/domain/core/result/result.dart';
import 'package:aro_monitoring/infrastructure/api_address.dart';
import 'package:aro_monitoring/infrastructure/api_reply.dart';
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
  ///
  /// posible implementation: Update By Id
  ///   SQL: UPDATE do_data SET \'$column\' = \'$str\' WHERE id = $id';
  /// 
  Future<Result<ApiReply>> update(String id, String field, String value) async {
    // TODO insert new rec into the database to be implemented
    String sql = 'UPDATE do_data SET \'$column\' = \'$str\' WHERE id = $id';
    final apiRequest = ApiRequest(
      address: _address, 
      sqlQuery: SqlQuery(
        authToken: _sqlQuery. authToken, 
        database: database, 
        sql: sql,
      ),
    );
    return apiRequest.fetch();
  }
  ///
  Future<Result<List<Map<String, dynamic>>>> insert(String sql) async {
    // TODO update rec in the database to be implemented
    return Future.delayed(const Duration(milliseconds: 100));
  }
  ///
  /// depricated method
  /// this functional must be repleced with method insert & update
  Future<Result<List<Map<String, dynamic>>>> loadToDb(String sqlQueryString) async {
    SqlQuery sqlQuery = SqlQuery(
      authToken: 'auth-token-test', 
      database: 'database',
      sql: sqlQueryString,
    );
    if (sqlQuery.valid()) {
      final apiRequest = ApiRequest(
        address: _address, 
        sqlQuery: sqlQuery,
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