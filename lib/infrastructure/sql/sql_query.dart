class SqlQuery {
  final String _sql;
  ///
  /// Prapares sql for some database
  const SqlQuery({
    required String sql,
  }) :
    _sql = sql;
  ///
  bool valid() {
    return true;
    /// some simplest sql syntax validation to be implemented
  }
  ///
  String build() {
    return _sql;
  }
}