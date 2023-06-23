import 'dart:convert';
import 'dart:io';

import 'package:aro_monitoring/domain/core/error/failure.dart';
import 'package:aro_monitoring/domain/core/result/result.dart';
import 'package:aro_monitoring/infrastructure/api_address.dart';
import 'package:aro_monitoring/infrastructure/api_reply.dart';
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
  Future<Result<ApiReply>> fetch() async {
    final query = _sqlQuery.buildJson();
    final bytes = utf8.encode(query);
    return Socket.connect(_address.host, _address.port, timeout: const Duration(seconds: 3))
      .then((socket) async {
        socket.add(bytes);
        try {
          final message = await socket.first;
          _log.fine('.fetch | socket message: $message');
          final reply = ApiReply.fromJson(
            // json.decode(
              utf8.decode(message),
            // ),              
          );
          return Result(data: reply);
        } catch (error) {
          _log.warning('.fetch | socket error: $error');
          await _closeSocket(socket);
          return Result<ApiReply>(
            error: Failure.connection(
              message: '.fetch | socket error: $error', 
              stackTrace: StackTrace.current,
            ),
          );
        }
      })
      .catchError((error) {
          return Result<ApiReply>(
            error: Failure.connection(
              message: '.fetch | socket error: $error', 
              stackTrace: StackTrace.current,
            ),
          );
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