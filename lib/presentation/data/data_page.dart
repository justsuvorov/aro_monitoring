import 'package:aro_monitoring/infrastructure/api_address.dart';
import 'package:aro_monitoring/infrastructure/dep_objects.dart';
import 'package:aro_monitoring/infrastructure/do_data.dart';
import 'package:aro_monitoring/infrastructure/config_data.dart';
import 'package:aro_monitoring/infrastructure/api_query_type/sql_query.dart';
import 'package:aro_monitoring/presentation/data/widgets/config_data_body.dart';
import 'package:aro_monitoring/presentation/data/widgets/data_body.dart';
import 'package:aro_monitoring/presentation/home/home_page.dart';
import 'package:flutter/material.dart';

///
class DataPage extends StatelessWidget {
  final String _title;
  final DoData _doData;
  ///
  const DataPage({
    Key? key,
    required String title,
    required DoData doData,
  }) : 
    _title = title, 
    _doData = doData,
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
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(
                      title: 'OutboxML'
                    ),
                  ),
                );
              },
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
      body: DataBody(
        doData: _doData,
      ),
    );
  }
}


class ConfigPage extends StatelessWidget {
  final String _title;
  final ConfigData _configData;
  ///
  const ConfigPage({
    Key? key,
    required String title,
    required ConfigData configData,
  }) : 
    _title = title, 
    _configData = configData,
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
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(
                      title: 'OutboxML',
                   
                    ),
                  ),
                );
              },
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
      body: ConfigDataBody(
        configData: _configData,
      ),
    );
  }
}