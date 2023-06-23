import 'dart:convert';

import 'package:uuid/uuid.dart';

class SqlQuery {
  final String _authToken;
  late String _id;
  final String _sql;
  ///
  /// Prapares sql for some database
  SqlQuery({
    required String authToken,
    required String sql,
  }) :
    _authToken = authToken,
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
      'sql': _sql,
    });
    return jsonString;
  }
}