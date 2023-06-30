import 'dart:convert';

import 'package:uuid/uuid.dart';

class SqlQuery {
  final String _authToken;
  late String _id;
  final String _database;
  final String _sql;
  ///
  /// Prapares sql for some database
  SqlQuery({
    required String authToken,
    required String database,
    required String sql,
  }) :
    _authToken = authToken,
    _database = database,
    _sql = sql;
  ///
  bool valid() {
    return true;
    /// some simplest sql syntax validation to be implemented
  }
  ///
  String buildJson() {
    _id = const Uuid().v1();
    final jsonString = json.encode({
      'auth_token': _authToken,
      'id': _id,
      'sql': {
        'database': _database,
        'sql': _sql,
      },
    });
    return jsonString;
  }
  ///
  String get authToken => _authToken;
  ///
  String get id => _id;
  ///
  String get database => _database;
}