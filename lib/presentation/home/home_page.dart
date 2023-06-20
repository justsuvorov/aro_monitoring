import 'package:aro_monitoring/presentation/data/data_page.dart';
import 'package:aro_monitoring/presentation/data/widgets/monitoring_list.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  final String title;
  final List<String> doList;
  ///
  const MyHomePage({
    super.key, 
    required this.title,
    required this.doList,
  });
  ///
  @override
  State<MyHomePage> createState() => _MyHomePageState(
    doList: doList,
  );
}

///
class _MyHomePageState extends State<MyHomePage> {
  final List<String> doList;
  ///
  _MyHomePageState({
    required this.doList,
  });
  ///
  void _updateButtonClick() {
    // TODO method to be implemented...
  }
  ///
  @override
  Widget build(BuildContext context) {
    String dropdownValue = doList.first;
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
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(widget.title, style: const TextStyle(fontFamily: 'GPN_DIN', fontSize: 32),),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.home),
            tooltip: 'Главная страница',
            onPressed: () {
              // TODO route to be implemented
            },
          ),
        ],
      ),
      body: Center(
        child:
          Wrap(children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 50),                
                const SizedBox(height: 50),
                ElevatedButton(
                  onPressed: _updateButtonClick,
                  style: buttonStyle, 
                  child: Text('Обновление базы мониторинга', style: textStyle,),
                  
                  ),
                const SizedBox(height: 50),
                ElevatedButton(
                  onPressed: (){Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  DataPage()),
                    );}, 
                  style: buttonStyle,
                  child: Text('Заполнить форму для ДО',style: textStyle,),
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
                    DropdownButton<String>(
                      value: dropdownValue,
                      icon: const Icon(Icons.arrow_downward),         
                      selectedItemBuilder: (BuildContext context) {
                        return doList.map((String value) {
                          return Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              dropdownValue,
                              style: const TextStyle(color: Colors.white, fontFamily: 'GPN_DIN', fontSize: 20),
                            ),
                          );
                        }).toList();
                      },
                      onChanged: (String? value) {
                                  // This is called when the user selects an item.
                                  setState(() {dropdownValue = value!;});
                                },
                      items: doList.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value, style: const TextStyle(fontFamily: 'GPN_DIN')),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                const SizedBox(height: 50),
                ElevatedButton(
                   onPressed: (){Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  const MonitoringList()),
                    );},  
                  style: buttonStyle,
                  child: Text('Просмотр таблицы нерентабельных объектов', style: textStyle,),
                  
                  ),
                ],
              ),
              ],
          ),
      ),
       // This trailing comma makes auto-formatting nicer for build methods.
    backgroundColor: const Color.fromARGB(255, 28, 33, 37),);
  }
}