import 'dart:convert';
import 'dart:io';

import 'package:aro_monitoring/infrastructure/api_address.dart';
import 'package:aro_monitoring/infrastructure/api_request.dart';
import 'package:aro_monitoring/infrastructure/sql/sql_query.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logging/logging.dart';


void main() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time} | ${record.loggerName}${record.message}');
  });
  final log = Logger('ApiRequestTest');
  final apiAddress = ApiAddress(host: '127.0.0.1', port: 1111);// InternetAddress.loopbackIPv4;
  late ServerSocket socketServer;
  // late ApiRequest apiRequest;
  setUp(() async {
    socketServer = await ServerSocket.bind(apiAddress.host, apiAddress.port);
    log.fine('bind result: $socketServer');
  });
  tearDown(() async {
    await socketServer.close();
  });
  test('ApiRequest test', () async {
    socketServer.listen((socket) {
      log.fine('server incoming connection: $socket');
      socket.listen((event) {
        log.fine('Server | message: $event');
        socket.add(
          utf8.encode(replyStr),
        );
        socket.close();
      });
    });
      final apiRequest = ApiRequest(
        address: apiAddress,
        sqlQuery: SqlQuery(
          authToken: 'auth-token-test',
          sql: queryStr,
        ),
      );
      final reply = await apiRequest.fetch();
      log.fine(' | reply: $reply');
    return;
    for (final sql in testSqls) {
      final apiRequest = ApiRequest(
        address: apiAddress,
        sqlQuery: SqlQuery(
          authToken: 'auth-token-test',
          sql: sql,
        ),
      );
      apiRequest.fetch();
    }
    // remains subscription for '/Local/Local.System.Connection' only
    // expect(dsClient.subscriptionsCount, 1);
  });
}


const testSqls = [
  'SELECT * from user;',
  'SELECT * from user1;',
  'SELECT * from user2;',
];

const queryStr = "{\n    \"auth_token\": \"123zxy456!@#\",\n    \"id\": 123,\n    \"sql\": \"Some valid sql query\"\n}";
const queryJson = {
    "auth_token": "123zxy456!@#",
    "id": 123,
    "sql": "Some valid sql query",
    "data": [

    ],
    "errors": [

    ],
};

const replyStr = "{\n    \"auth_token\": \"123zxy456!@#\",\n    \"id\": 123,\n    \"sql\": \"Some valid sql query\",\n    \"data\": [\n\n    ],\n    \"errors\": [\n\n    ]\n}";
const replyJson = {
    "auth_token": "123zxy456!@#",
    "id": 123,
    "sql": "Some valid sql query",
};