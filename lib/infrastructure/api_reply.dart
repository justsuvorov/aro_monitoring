import 'dart:convert';

import 'package:logging/logging.dart';

class ApiReply {
  final _log = Logger('ApiReply');
  late String _authToken;
  late String _id;
  late String _sql;
  late List<dynamic> _data;
  late List<String> _errors;
  ///
  ApiReply({
    required String authToken,
    required String id,
    required String sql,
    required List<dynamic> data,
    required List<String> errors,
  }) : 
    _authToken = authToken,
    _id = id,
    _sql = sql, 
    _data = data, 
    _errors = errors;
  ///
  ApiReply.fromJson(String jsonString) {
    _log.fine('.fromJson | jsonString: $jsonString');
    final jsonMap = json.decode(jsonString);
    _authToken = jsonMap['auth_token'];
    _id = jsonMap['id'];
    _sql = jsonMap['sql'];
    _data = jsonMap['data'];
    _errors = (jsonMap['errors'] as List<dynamic>).map((e) => '$e').toList();
  }
  ///
  String get authToken => _authToken;
  ///
  String get id => _id;
  ///
  String get sql => _sql;
  ///
  List<dynamic> get data => _data;
  ///
  List<String> get errors => _errors;
  ///
  @override
  String toString() {
    return '''$ApiReply {
\t\tauthToken: $_authToken;
\t\tid: $_id;
\t\tsql: $_sql;
\t\tdata: $_data;
\t\terrors: $_errors;
\t}''';
  }
}

const j = {
    "auth_token": "123zxy456!@#",
    "id": 123,
    "sql": "Some valid sql query",
    "data": [

    ],
    "errors": [

    ],
};
