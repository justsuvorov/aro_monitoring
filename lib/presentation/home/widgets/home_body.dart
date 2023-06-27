import 'package:aro_monitoring/infrastructure/api_address.dart';
import 'package:aro_monitoring/infrastructure/dep_objects.dart';
import 'package:aro_monitoring/infrastructure/do_data.dart';
import 'package:aro_monitoring/infrastructure/sql/sql_query.dart';
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
                    'Обновление базы мониторинга', 
                    style: textStyle,
                  ),
                ),
                
                const SizedBox(height: 50),
                ElevatedButton(
                  onPressed: _updateButtonClick, 
                  style: buttonStyle,
                  child: Text('Мэппинг объектов с базой МЭР', style: textStyle,),
                  
                ),
                const SizedBox(height: 100),
                Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Выбор ДО", style: textStyle),  
                    const SizedBox(width: 100),
                    DropdownButton<int>(
                      value: dropdownValue,
                      icon: const Icon(Icons.arrow_downward),         
                      selectedItemBuilder: (BuildContext context) {
                        return _depList.map((String value) {
                          return Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              _depList[dropdownValue],
                              style: const TextStyle(color: Colors.white, fontFamily: 'GPN_DIN', fontSize: 20),
                            ),
                          );
                        }).toList();
                      },
                      onChanged: (int? value) {
                        setState(() {dropdownValue = value!;});
                      },
                      items: List<DropdownMenuItem<int>>.generate(_depList.length, (int index) {
                        return DropdownMenuItem<int>(
                          value: index,
                          child: Text(
                            _depList[index], 
                            style: const TextStyle(fontFamily: 'GPN_DIN'),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
                const SizedBox(height: 50),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DataPage(
                        title: "Форма заполнения мероприятий",
                        doData: DoData(
                          address: ApiAddress.localhost(),
                          sqlQuery: SqlQuery(
                            authToken: 'auth-token-test',
                            database: 'database',
                            sql: dropdownValue == 0 
                              ? 'SELECT * FROM do_data'
                              : 'SELECT * FROM do_data WHERE company = \'$dropdownValue\'',
                          ), 
                        ),
                      )),
                    );
                  }, 
                  style: buttonStyle,
                  child: Text('Заполнить форму для ДО',style: textStyle,),
                ),
                const SizedBox(height: 50),
                
                ElevatedButton(
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>  MonitoringPage(
                          title: "Таблица нерентабельных объектов", 
                          doData: DoData(
                            address: ApiAddress.localhost(),
                            sqlQuery: SqlQuery(
                              authToken: 'auth-token-test',
                              database: 'database',
                              sql: dropdownValue == 0 
                                ? 'SELECT * FROM do_data'
                                : 'SELECT * FROM do_data WHERE company = \'$dropdownValue\'',
                              ),
                            ),
                          ),
                      ),
                    );
                  },  
                  style: buttonStyle,
                  child: Text('Просмотр таблицы нерентабельных объектов', style: textStyle,),
                ),
              ],
            ),
          ],
        ),
      );
    }
  }
}
