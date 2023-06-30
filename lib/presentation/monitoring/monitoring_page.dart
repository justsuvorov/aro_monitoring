import 'package:aro_monitoring/infrastructure/api_address.dart';
import 'package:aro_monitoring/infrastructure/dep_objects.dart';
import 'package:aro_monitoring/infrastructure/do_data.dart';
import 'package:aro_monitoring/infrastructure/api_query_type/sql_query.dart';
import 'package:aro_monitoring/presentation/home/home_page.dart';
import 'package:aro_monitoring/presentation/monitoring/widgets/monitoring_body.dart';
import 'package:flutter/material.dart';

///
class MonitoringPage extends StatelessWidget {
  final String _title;
  final DoData doData;
  const MonitoringPage({
    Key? key,
    required String title,
    required DoData doData,
  }) : 
    _title = title,
    doData = doData, 
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
                    address: ApiAddress.localhost(),
                    sqlQuery: SqlQuery(
                      authToken: 'auth-token-test',
                      database: 'database',
                      sql: 'SELECT * FROM dep_objects;',
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
      body: MonitoringBody(doData: doData,),
    );
  }
}
