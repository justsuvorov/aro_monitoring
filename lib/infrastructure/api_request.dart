import 'dart:convert';
import 'dart:io';

import 'package:aro_monitoring/infrastructure/api_address.dart';
import 'package:aro_monitoring/infrastructure/sql/sql_query.dart';

class ApiRequest {
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
  Future<void> fetch() async {
    final query = _sqlQuery.build();
    final bytes = utf8.encode(query);
    Socket.connect(_address.host, _address.port, timeout: const Duration(seconds: 3))
      .then((socket) {
        socket.add(bytes);
      });
  }
}