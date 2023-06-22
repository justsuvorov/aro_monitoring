class ApiAddress {
  final String _host;
  final int _port;
  ///
  ApiAddress({
    required String host,
    required int port,
  }) : 
    _host = host,
    _port = port;
  ///
  String get host => _host;
  ///
  int get port => _port;
}