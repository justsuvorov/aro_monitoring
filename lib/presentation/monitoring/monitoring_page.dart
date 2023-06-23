import 'package:aro_monitoring/infrastructure/api_address.dart';
import 'package:aro_monitoring/infrastructure/dep_objects.dart';
import 'package:aro_monitoring/infrastructure/sql/sql_query.dart';
import 'package:aro_monitoring/presentation/home/home_page.dart';
import 'package:aro_monitoring/presentation/monitoring/widgets/monitoring_body.dart';
import 'package:flutter/material.dart';

///
class MonitoringPage extends StatelessWidget {
  final String _title;
  ///
  const MonitoringPage({
    Key? key,
    required String title,
  }) : 
    _title = title, 
    super(key: key);
  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("home"),
              onTap: () {Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => HomePage(
        title: 'Мониторинг АРО',
        depObjects: DepObjects(
          address: ApiAddress(host: '127.0.0.1', port: 8899),
          sqlQuery: SqlQuery(
            authToken: 'auth-token-test',
            sql: 'SELECT * FROM dep-objects',
          ),
        ),
      ),
    ),
  );},
            ),
            ListTile(
              leading: const Icon(Icons.storage),
              title: const Text("data"),
              onTap: () {
                // TODO onTap to be implemented...
              },
            ),
          ],
        ),
      ),
      body: const MonitoringBody(),
    );
  }
}
