import 'dart:convert';
import 'dart:io';

import 'package:aro_monitoring/domain/core/error/failure.dart';
import 'package:aro_monitoring/domain/core/result/result.dart';
import 'package:aro_monitoring/infrastructure/api_address.dart';
import 'package:aro_monitoring/infrastructure/sql/sql_query.dart';
import 'package:logging/logging.dart';

class ApiRequest {
  final _log = Logger('ApiRequest');
  final ApiAddress _address;
  final SqlQuery _sqlQuery;
  ///
  ApiRequest({
    required ApiAddress address,
    required SqlQuery sqlQuery,
  }) :
    _address = address,
    _sqlQuery = sqlQuery;
  ///
  /// exequtes created sql query to the remote
  /// returns reply if exists
  Future<Result<List<dynamic>>> fetch() async {
    final query = _sqlQuery.build();
    final bytes = utf8.encode(query);
    return Socket.connect(_address.host, _address.port, timeout: const Duration(seconds: 3))
      .then((socket) async {
        socket.add(bytes);
          try {
            final dataList = [];
            await for (final message in socket) {
              dataList.add(message);
            }
            return Result(data: dataList);
          } catch (error) {
            _log.warning('.fetch | socket error: $error');
            await _closeSocket(socket);
            return Result(
              error: Failure.connection(
                message: '.fetch | socket error: $error', 
                stackTrace: StackTrace.current,
              ),
            );
          }
      });
  }
  ///
  Future<void> _closeSocket(Socket? socket) async {
    try {
      await socket?.close();
      socket?.destroy();
    } catch (error) {
      _log.warning('[.close] error: $error');
    }
  }  
}