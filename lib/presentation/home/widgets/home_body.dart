import 'package:aro_monitoring/infrastructure/api_address.dart';
import 'package:aro_monitoring/infrastructure/api_query_type/fast_api_query.dart';
import 'package:aro_monitoring/infrastructure/dep_objects.dart';
import 'package:aro_monitoring/infrastructure/do_data.dart';
import 'package:aro_monitoring/infrastructure/config_data.dart';
import 'package:aro_monitoring/infrastructure/api_query_type/sql_query.dart';
import 'package:aro_monitoring/presentation/data/data_page.dart';
import 'package:aro_monitoring/presentation/monitoring/monitoring_page.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

class HomeBody extends StatefulWidget {
  final DepObjects depObjects;
  ///
  const HomeBody({
    super.key, 
    required this.depObjects,
  });
  ///
  @override
  State<HomeBody> createState() => _HomePageState(
    depObjects: depObjects,
  );
}

///
class _HomePageState extends State<HomeBody> {
  final log = Logger('_HomePageState');
  final DepObjects _depObjects;
  static const _dropdownEmptyValue = 'По всем';
  final List<String> _depList = [_dropdownEmptyValue];
  int dropdownValue = 0;
  bool _isLoading = false;
  ///
  _HomePageState({
    required DepObjects depObjects,
  }) : 
    _depObjects = depObjects;
  ///
  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _depObjects.all().then((result) {
      result.fold(
        onData: (depList) {
          if (depList.isNotEmpty) {
            _depList.clear();
            _depList.add(_dropdownEmptyValue);
            _depList.addAll(depList);
            dropdownValue = 0;
          }
        }, 
        onError: (
          (error) {
            log.warning('._initializeData | error: $error');
          }
        ),
      );
    }).whenComplete(() {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    });
  }
  ///
  void _updateButtonClick() {
     Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ConfigPage(
                        title: "AutoMLConfig",
                        configData: ConfigData(fastAPIQuery: FastApiQuery(baseUrl: 'http://127.0.0.1:8000')
                        ),
                      )),
                    );
  }

   void _monitoringButtonClick() {
    
    // TODO method to be implemented...
  }
  void _exploringResultsButtonClick() {
    
    // TODO method to be implemented...
  }
  void _exportResultsButtonClick() {
    
    // TODO method to be implemented...
  }
  ///
  @override
  Widget build(BuildContext context) {
    var buttonStyle = const ButtonStyle(
      backgroundColor: MaterialStatePropertyAll<Color>(Color.fromARGB(255, 2, 108, 189)),
      minimumSize: MaterialStatePropertyAll<Size>(Size(800, 80)),
    // maximumSize: MaterialStatePropertyAll<Size>(Size(500, 80)),
      );
    var textStyle = const TextStyle(
      fontSize: 20,
      fontFamily: 'GPN_DIN',
      color: Colors.white,
    );
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Center(
        child: Wrap(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _updateButtonClick,
                  style: buttonStyle, 
                  child: Text(
                    'Обучение моделей', 
                    style: textStyle,
                  ),
                ),
                
                const SizedBox(height: 50),
                ElevatedButton(
                  onPressed: _monitoringButtonClick, 
                  style: buttonStyle,
                  child: Text('Мониторинг моделей и данных', style: textStyle,),
                  
                ),
                const SizedBox(height: 100),
               
                ElevatedButton(
                  onPressed: _exploringResultsButtonClick,
                  style: buttonStyle,
                  child: Text('Просмотр результатов',style: textStyle,),
                ),
                const SizedBox(height: 50),
                
                ElevatedButton(
                  onPressed: _exportResultsButtonClick,
                  style: buttonStyle,
                  child: Text('Экспорт результатов', style: textStyle,),
                ),
              ],
            ),
          ],
        ),
      );
    }
  }
}
