import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:responsive_table/responsive_table.dart';

Map <String, String> company_names = {'Арчинское': 'ГПН-Восток',
        'Западно-Лугинецкое': 'ГПН-Восток',
        'Крапивинское': 'ГПН-Восток',
        'Кулгинское': 'ГПН-Восток',
        'Нижнелугинецкое': 'ГПН-Восток',
        'Смоляное': 'ГПН-Восток',
        'Урманское': 'ГПН-Восток',
        'Шингинское': 'ГПН-Восток',
        'Южно-Табаганское': 'ГПН-Восток',
        'Аганское': 'СН-МНГ',
        'Аригольское': 'СН-МНГ',
        'Ачимовское': 'СН-МНГ',
        'Ватинское': 'СН-МНГ',
        'Восточно-Охтеурское': 'СН-МНГ',
        'Западно-Асомкинское': 'СН-МНГ',
        'Западно-Усть-Балыкское': 'СН-МНГ',
        'Западно-Чистинное': 'СН-МНГ',
        'Ининское': 'СН-МНГ',
        'Кетовское': 'СН-МНГ',
        'Кысомское': 'СН-МНГ',
        'Луговое': 'СН-МНГ',
        'Максимкинское': 'СН-МНГ',
        'Мегионское': 'СН-МНГ',
        'Мыхпайское': 'СН-МНГ',
        'Ново-Покурское': 'СН-МНГ',
        'Островное': 'СН-МНГ',
        'Покамасовское': 'СН-МНГ',
        'Северо-Ореховское': 'СН-МНГ',
        'Северо-Островное': 'СН-МНГ',
        'Северо-Покурское': 'СН-МНГ',
        'Тайлаковское': 'СН-МНГ',
        'Узунское': 'СН-МНГ',
        'Чистинное': 'СН-МНГ',
        'Южно-Аганское': 'СН-МНГ',
        'Южно-Островное': 'СН-МНГ',
        'Южно-Покамасовское': 'СН-МНГ',
        'Восточно-Мессояхское': 'Мессояха',
        'Валынтойское': 'ГПН-ННГ',
        'Восточно-Пякутинское': 'ГПН-ННГ',
        'Вынгаяхинское': 'ГПН-ННГ',
        'Еты-Пуровское': 'ГПН-ННГ',
        'Крайнее': 'ГПН-ННГ',
        'Муравленковское': 'ГПН-ННГ',
        'Пякутинское': 'ГПН-ННГ',
        'Романовское': 'ГПН-ННГ',
        'Северо-Пямалияхское': 'ГПН-ННГ',
        'Северо-Янгтинское': 'ГПН-ННГ',
        'Сугмутское': 'ГПН-ННГ',
        'Суторминское': 'ГПН-ННГ',
        'Умсейское+Южно-Пурпейское': 'ГПН-ННГ',
        'Вынгапуровское': 'ГПН-ННГ',
        'Западно-Чатылькинское': 'ГПН-ННГ',
        'Карамовское': 'ГПН-ННГ',
        'Новогоднее': 'ГПН-ННГ',
        'Отдельное': 'ГПН-ННГ',
        'Пограничное': 'ГПН-ННГ',
        'Спорышевское': 'ГПН-ННГ',
        'Средне-Итурское': 'ГПН-ННГ',
        'Холмистое': 'ГПН-ННГ',
        'Холмогорское': 'ГПН-ННГ',
        'Чатылькинское': 'ГПН-ННГ',
        'Южно-Ноябрьское': 'ГПН-ННГ',
        'Ярайнерское': 'ГПН-ННГ',
        'Балейкинское': 'ГПН-Оренбург',
        'Землянское': 'ГПН-Оренбург',
        'Капитоновское': 'ГПН-Оренбург',
        'Новозаринское': 'ГПН-Оренбург',
        'Новосамарское': 'ГПН-Оренбург',
        'Оренбургское': 'ГПН-Оренбург',
        'Рощинское': 'ГПН-Оренбург',
        'Царичанское+Филатовское': 'ГПН-Оренбург',
        'Зимнее': 'ГПН-Хантос',
        'Им. Александра Жагрина': 'ГПН-Хантос',
        'Красноленинское': 'ГПН-Хантос',
        'Орехово-Ермаковское': 'ГПН-Хантос',
        'Приобское': 'ГПН-Хантос',
        'Южное': 'ГПН-Хантос',
        'Южно-Киняминское': 'ГПН-Хантос',
        'Новопортовское': 'ГПН-Хантос'};

List companies = ['Все ДО', 'ГПН-Восток', 'ГПН-ННГ', 'ГПН-Оренбург', 'ГПН-Хантос', 'Мессояха', 'СН-МНГ'];
void main() {
  runApp(const MyApp());
}
const List<String> list = <String>['Все ДО', 'ГПН-Восток', 'ГПН-ННГ', 'ГПН-Оренбург', 'ГПН-Хантос', 'Мессояха', 'СН-МНГ'];
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Мониторинг АРО',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MyHomePage(title: 'Мониторинг АРО',),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  
  String dropdownValue = list.first;
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
  
  void _updateButtonClick(){

    
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(widget.title, style: const TextStyle(fontFamily: 'GPN_DIN', fontSize: 32),),
        actions: <Widget>[IconButton(
            icon: const Icon(Icons.home),
            tooltip: 'Главная страница',
            onPressed: () {
              
            })],
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
                        SizedBox(width: 100),
                       DropdownButton<String>(value: dropdownValue,
                                        icon: const Icon(Icons.arrow_downward),         
                                        selectedItemBuilder: (BuildContext context) {
                                          return list.map((String value) {
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
                                        items: list.map<DropdownMenuItem<String>>((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value, style: TextStyle(fontFamily: 'GPN_DIN')),
                                            );
                                          }).toList()),]
                                          ),
                                        const SizedBox(height: 50),
                                          ElevatedButton(
                   onPressed: (){Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  MonitoringList()),
                    );},  
                  style: buttonStyle,
                  child: Text('Просмотр таблицы нерентабельных объектов', style: textStyle,),
                  
                  ),
        
      
                ]
              )
              ],
          ),
      ),
       // This trailing comma makes auto-formatting nicer for build methods.
    backgroundColor: Color.fromARGB(255, 28, 33, 37),);
  }
}


class MonitoringTable {
late final int id;
  late final String name;
  late final int age;
  late final int distancefromsun;
 
  MonitoringTable({
    required this.id,
    required this.name,
    required this.age,
    required this.distancefromsun,
  });
  
  MonitoringTable.fromMap(Map<String, dynamic> result)
      : id = result["id"],
        name = result["name"],
        age = result["age"],
        distancefromsun = result["distancefromsun"];
  Map<String, Object> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'distancefromsun': distancefromsun
    };
  }
}

class DataPage extends StatefulWidget {
  DataPage({Key? key}) : super(key: key);
  @override
  _DataPageState createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  late List<DatatableHeader> _headers;

  List<int> _perPages = [10, 20, 50, 100];
  int _total = 100;
  int? _currentPerPage = 10;
  List<bool>? _expanded;
  String? _searchKey = "id";

  int _currentPage = 1;
  bool _isSearch = false;
  List<Map<String, dynamic>> _sourceOriginal = [];
  List<Map<String, dynamic>> _sourceFiltered = [];
  List<Map<String, dynamic>> _source = [];
  List<Map<String, dynamic>> _selecteds = [];
  // ignore: unused_field
  String _selectableKey = "id";

  String? _sortColumn;
  bool _sortAscending = true;
  bool _isLoading = true;
  bool _showSelect = true;
  var random = new Random();

  List<Map<String, dynamic>> _generateData({int n = 10}) {
    
    return [{"id": 213,
        "name": "Cкважина",
        "well": "1512",
        "pad": "12",
        "prep_object": "ДНС-2 Еты-Пуровского",
        "field": "Еты-Пуровское",
        "company": "ГПН-ННГ",
        "activity": "",
        "comment": "",
        "date_planning": "",
        "date_fact": "",
        "date_creation": "01.04.2023",
        "responsible_person": "",
        "obj_status": "",
        "failure": "",},

        {"id": 214,
        "name": "Cкважина",
        "well": "1557",
        "pad": "22А",
        "prep_object": "ДНС-2 Еты-Пуровского",
        "field": "Еты-Пуровское",
        "company": "ГПН-ННГ",
        "activity": "",
        "comment": "",
        "date_planning": "",
        "date_fact": "",
        "date_creation": "01.04.2023",
        "responsible_person": "",
        "obj_status": "",
        "failure": "",},
        
        {"id": 215,
        "name": "Cкважина",
        "well": "3100",
        "pad": "251Б",
        "prep_object": "ДНС-2 Еты-Пуровского",
        "field": "Еты-Пуровское",
        "company": "ГПН-ННГ",
        "activity": "",
        "comment": "",
        "date_planning": "",
        "date_fact": "",
        "date_creation": "01.04.2023",
        "responsible_person": "",
        "obj_status": "",
        "failure": "",},
        {"id": 216,
        "name": "Cкважина",
        "well": "3101",
        "pad": "263Б",
        "prep_object": "ДНС-2 Еты-Пуровского",
        "field": "Еты-Пуровское",
        "company": "ГПН-ННГ",
        "activity": "",
        "comment": "",
        "date_planning": "",
        "date_fact": "",
        "date_creation": "01.04.2023",
        "responsible_person": "",
        "obj_status": "",
        "failure": "",},
        {"id": 217,
        "name": "Cкважина",
        "well": "3133",
        "pad": "250",
        "prep_object": "ДНС-2 Еты-Пуровского",
        "field": "Еты-Пуровское",
        "company": "ГПН-ННГ",
        "activity": "",
        "comment": "",
        "date_planning": "",
        "date_fact": "",
        "date_creation": "01.04.2023",
        "responsible_person": "",
        "obj_status": "",
        "failure": "",},
        {"id": 218,
        "name": "Cкважина",
        "well": "4141",
        "pad": "266",
        "prep_object": "ДНС-2 Еты-Пуровского",
        "field": "Еты-Пуровское",
        "company": "ГПН-ННГ",
        "activity": "",
        "comment": "",
        "date_planning": "",
        "date_fact": "",
        "date_creation": "01.04.2023",
        "responsible_person": "",
        "obj_status": "",
        "failure": "",},
        {"id": 261,
        "name": "Cкважина",
        "well": "1406г",
        "pad": "11",
        "prep_object": "ДНС-2 Еты-Пуровского",
        "field": "Еты-Пуровское",
        "company": "ГПН-ННГ",
        "activity": "",
        "comment": "",
        "date_planning": "",
        "date_fact": "",
        "date_creation": "01.04.2023",
        "responsible_person": "",
        "obj_status": "",
        "failure": "",},
         {"id": 262,
        "name": "Cкважина",
        "well": "1426",
        "pad": "11",
        "prep_object": "ДНС-2 Еты-Пуровского",
        "field": "Еты-Пуровское",
        "company": "ГПН-ННГ",
        "activity": "",
        "comment": "",
        "date_planning": "",
        "date_fact": "",
        "date_creation": "01.04.2023",
        "responsible_person": "",
        "obj_status": "",
        "failure": "",},
        {"id": 263,
        "name": "Cкважина",
        "well": "1716",
        "pad": "33",
        "prep_object": "ДНС-2 Еты-Пуровского",
        "field": "Еты-Пуровское",
        "company": "ГПН-ННГ",
        "activity": "",
        "comment": "",
        "date_planning": "",
        "date_fact": "",
        "date_creation": "01.04.2023",
        "responsible_person": "",
        "obj_status": "",
        "failure": "",},
        {"id": 264,
        "name": "Cкважина",
        "well": "266ПО",
        "pad": "251Б",
        "prep_object": "ДНС-2 Еты-Пуровского",
        "field": "Еты-Пуровское",
        "company": "ГПН-ННГ",
        "activity": "",
        "comment": "",
        "date_planning": "",
        "date_fact": "",
        "date_creation": "01.04.2023",
        "responsible_person": "",
        "obj_status": "",
        "failure": "",},
        {"id": 302,
        "name": "Cкважина",
        "well": "1721",
        "pad": "178",
        "prep_object": "ДНС-1 Еты-Пуровского",
        "field": "Еты-Пуровское",
        "company": "ГПН-ННГ",
        "activity": "",
        "comment": "",
        "date_planning": "",
        "date_fact": "",
        "date_creation": "01.04.2023",
        "responsible_person": "",
        "obj_status": "",
        "failure": "",},
        {"id": 303,
        "name": "Cкважина",
        "well": "1722",
        "pad": "178",
        "prep_object": "ДНС-1 Еты-Пуровского",
        "field": "Еты-Пуровское",
        "company": "ГПН-ННГ",
        "activity": "",
        "comment": "",
        "date_planning": "",
        "date_fact": "",
        "date_creation": "01.04.2023",
        "responsible_person": "",
        "obj_status": "",
        "failure": "",},
        {"id": 304,
        "name": "Cкважина",
        "well": "1816",
        "pad": "17",
        "prep_object": "ДНС-1 Еты-Пуровского",
        "field": "Еты-Пуровское",
        "company": "ГПН-ННГ",
        "activity": "",
        "comment": "",
        "date_planning": "",
        "date_fact": "",
        "date_creation": "01.04.2023",
        "responsible_person": "",
        "obj_status": "",
        "failure": "",},
        {"id": 305,
        "name": "Cкважина",
        "well": "2020",
        "pad": "1Б",
        "prep_object": "ДНС-1 Еты-Пуровского",
        "field": "Еты-Пуровское",
        "company": "ГПН-ННГ",
        "activity": "",
        "comment": "",
        "date_planning": "",
        "date_fact": "",
        "date_creation": "01.04.2023",
        "responsible_person": "",
        "obj_status": "",
        "failure": "",},
        {"id": 306,
        "name": "Cкважина",
        "well": "2062",
        "pad": "17",
        "prep_object": "ДНС-1 Еты-Пуровского",
        "field": "Еты-Пуровское",
        "company": "ГПН-ННГ",
        "activity": "",
        "comment": "",
        "date_planning": "",
        "date_fact": "",
        "date_creation": "01.04.2023",
        "responsible_person": "",
        "obj_status": "",
        "failure": "",},
        {"id": 307,
        "name": "Cкважина",
        "well": "2063",
        "pad": "17",
        "prep_object": "ДНС-1 Еты-Пуровского",
        "field": "Еты-Пуровское",
        "company": "ГПН-ННГ",
        "activity": "",
        "comment": "",
        "date_planning": "",
        "date_fact": "",
        "date_creation": "01.04.2023",
        "responsible_person": "",
        "obj_status": "",
        "failure": "",}
    
    ];
  }

  _initializeData() async {
    _mockPullData();
  }

  _mockPullData() async {
    _expanded = List.generate(_currentPerPage!, (index) => false);

    setState(() => _isLoading = true);
    Future.delayed(Duration(seconds: 3)).then((value) {
      _sourceOriginal.clear();
      _sourceOriginal.addAll(_generateData(n: 15));
      _sourceFiltered = _sourceOriginal;
      _total = _sourceFiltered.length;
      _source = _sourceFiltered.getRange(0, _currentPerPage!).toList();
      setState(() => _isLoading = false);
    });
  }

  _resetData({start = 0}) async {
    setState(() => _isLoading = true);
    var _expandedLen =
        _total - start < _currentPerPage! ? _total - start : _currentPerPage;
    Future.delayed(Duration(seconds: 0)).then((value) {
      _expanded = List.generate(_expandedLen as int, (index) => false);
      _source.clear();
      _source = _sourceFiltered.getRange(start, start + _expandedLen).toList();
      setState(() => _isLoading = false);
    });
  }

  _filterData(value) {
    setState(() => _isLoading = true);

    try {
      if (value == "" || value == null) {
        _sourceFiltered = _sourceOriginal;
      } else {
        _sourceFiltered = _sourceOriginal
            .where((data) => data[_searchKey!]
                .toString()
                .toLowerCase()
                .contains(value.toString().toLowerCase()))
            .toList();
      }

      _total = _sourceFiltered.length;
      var _rangeTop = _total < _currentPerPage! ? _total : _currentPerPage!;
      _expanded = List.generate(_rangeTop, (index) => false);
      _source = _sourceFiltered.getRange(0, _rangeTop).toList();
    } catch (e) {
      print(e);
    }
    setState(() => _isLoading = false);
  }

  @override
  void initState() {
    super.initState();

    /// set headers
    _headers = [
      DatatableHeader(
          text: "№",
          value: "id",
          show: true,
          sortable: true,
          textAlign: TextAlign.center),
      DatatableHeader(
          text: "Тип объекта",
          value: "name",
          show: true,
          flex: 2,
          sortable: true,
          textAlign: TextAlign.left,),
      DatatableHeader(
          text: "Скважина",
          value: "well",
          show: true,
          sortable: true,
          textAlign: TextAlign.center),
      DatatableHeader(
          text: "Куст",
          value: "pad",
          show: true,
          sortable: true,
          textAlign: TextAlign.left),
      DatatableHeader(
          text: "Объект подготовки",
          value: "prep_object",
          show: true,
          sortable: true,
          textAlign: TextAlign.left),
      DatatableHeader(
          text: "Месторождение",
          value: "field",
          show: true,
          sortable: true,
          textAlign: TextAlign.left),
      DatatableHeader(
          text: "ДО",
          value: "company",
          show: true,
          sortable: true,
          textAlign: TextAlign.left),
      DatatableHeader(
          text: "Мероприятие",
          value: "activity",
          show: true,
          editable: true,
          sortable: true,
          textAlign: TextAlign.left),
      DatatableHeader(
          text: "Комментарии к мероприятию",
          value: "comment",
          show: true,
          sortable: false,
          editable: true,
          textAlign: TextAlign.center),
      DatatableHeader(
          text: "Дата выполнения",
          value: "date_fact",
          show: true,
          editable: true,
          sortable: false,
          textAlign: TextAlign.center),
      DatatableHeader(
          text: "Планируемая дата",
          value: "date_planning",
          show: true,
          editable: true,
          sortable: false,
          textAlign: TextAlign.center),     
      DatatableHeader(
          text: "Дата направления мероприятия",
          value: "date_creation",
          show: true,
          editable: true,
          sortable: false,
          textAlign: TextAlign.center),
      DatatableHeader(
          text: "Ответственный",
          value: "responsible_person",
          show: true,
          editable: true,
          sortable: false,
          textAlign: TextAlign.center),    
      DatatableHeader(
          text: "Отказ. Да/Нет",
          value: "failure",
          show: true,
          editable: true,
          sortable: false,
          textAlign: TextAlign.center,        
          ),
      DatatableHeader(
          text: "Статус объекта. В работе/остановлен",
          value: "obj_status",
          show: true,
          editable: true,
          sortable: false,
          textAlign: TextAlign.center),
    ];

    _initializeData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Форма заполнения мероприятий"),
        actions: [
          IconButton(
            onPressed: _initializeData,
            icon: Icon(Icons.refresh_sharp),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              leading: Icon(Icons.home),
              title: Text("home"),
              onTap: () {Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const MyHomePage(title: 'Мониторинг АРО',)),
  );},
            ),
            ListTile(
              leading: Icon(Icons.storage),
              title: Text("data"),
              onTap: () {},
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
            Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(0),
              constraints: BoxConstraints(
                maxHeight: 700,
              ),
              child: Card(
                elevation: 1,
                shadowColor: Colors.black,
                clipBehavior: Clip.none,
                child: ResponsiveDatatable(
                  title: TextButton.icon(
                    onPressed: () => {},
                    icon: Icon(Icons.add),
                    label: Text("new item"),
                  ),
                  reponseScreenSizes: [ScreenSize.xs],
                  actions: [
                    if (_isSearch)
                      Expanded(
                          child: TextField(
                        decoration: InputDecoration(
                            hintText: 'Enter search term based on ' +
                                _searchKey!
                                    .replaceAll(new RegExp('[\\W_]+'), ' ')
                                    .toUpperCase(),
                            prefixIcon: IconButton(
                                icon: Icon(Icons.cancel),
                                onPressed: () {
                                  setState(() {
                                    _isSearch = false;
                                  });
                                  _initializeData();
                                }),
                            suffixIcon: IconButton(
                                icon: Icon(Icons.search), onPressed: () {})),
                        onSubmitted: (value) {
                          _filterData(value);
                        },
                      )),
                    if (!_isSearch)
                      IconButton(
                          icon: Icon(Icons.search),
                          onPressed: () {
                            setState(() {
                              _isSearch = true;
                            });
                          })
                  ],
                  headers: _headers,
                  source: _source,
                  selecteds: _selecteds,
                  showSelect: _showSelect,
                  autoHeight: false,
                  dropContainer: (data) {
                    if (int.tryParse(data['id'].toString())!.isEven) {
                      return Text("is Even");
                    }
                    return _DropDownContainer(data: data);
                  },
                  onChangedRow: (value, header) {
                    /// print(value);
                    /// print(header);
                  },
                  onSubmittedRow: (value, header) {
                    /// print(value);
                    /// print(header);
                  },
                  onTabRow: (data) {
                    print(data);
                  },
                  onSort: (value) {
                    setState(() => _isLoading = true);

                    setState(() {
                      _sortColumn = value;
                      _sortAscending = !_sortAscending;
                      if (_sortAscending) {
                        _sourceFiltered.sort((a, b) =>
                            b["$_sortColumn"].compareTo(a["$_sortColumn"]));
                      } else {
                        _sourceFiltered.sort((a, b) =>
                            a["$_sortColumn"].compareTo(b["$_sortColumn"]));
                      }
                      var _rangeTop = _currentPerPage! < _sourceFiltered.length
                          ? _currentPerPage!
                          : _sourceFiltered.length;
                      _source = _sourceFiltered.getRange(0, _rangeTop).toList();
                      _searchKey = value;

                      _isLoading = false;
                    });
                  },
                  expanded: _expanded,
                  sortAscending: _sortAscending,
                  sortColumn: _sortColumn,
                  isLoading: _isLoading,
                  onSelect: (value, item) {
                    print("$value  $item ");
                    if (value!) {
                      setState(() => _selecteds.add(item));
                    } else {
                      setState(
                          () => _selecteds.removeAt(_selecteds.indexOf(item)));
                    }
                  },
                  onSelectAll: (value) {
                    if (value!) {
                      setState(() => _selecteds =
                          _source.map((entry) => entry).toList().cast());
                    } else {
                      setState(() => _selecteds.clear());
                    }
                  },
                  footers: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Text("Rows per page:"),
                    ),
                    if (_perPages.isNotEmpty)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: DropdownButton<int>(
                          value: _currentPerPage,
                          items: _perPages
                              .map((e) => DropdownMenuItem<int>(
                                    child: Text("$e"),
                                    value: e,
                                  ))
                              .toList(),
                          onChanged: (dynamic value) {
                            setState(() {
                              _currentPerPage = value;
                              _currentPage = 1;
                              _resetData();
                            });
                          },
                          isExpanded: false,
                        ),
                      ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child:
                          Text("$_currentPage - $_currentPerPage of $_total"),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios,
                        size: 16,
                      ),
                      onPressed: _currentPage == 1
                          ? null
                          : () {
                              var _nextSet = _currentPage - _currentPerPage!;
                              setState(() {
                                _currentPage = _nextSet > 1 ? _nextSet : 1;
                                _resetData(start: _currentPage - 1);
                              });
                            },
                      padding: EdgeInsets.symmetric(horizontal: 15),
                    ),
                    IconButton(
                      icon: Icon(Icons.arrow_forward_ios, size: 16),
                      onPressed: _currentPage + _currentPerPage! - 1 > _total
                          ? null
                          : () {
                              var _nextSet = _currentPage + _currentPerPage!;

                              setState(() {
                                _currentPage = _nextSet < _total
                                    ? _nextSet
                                    : _total - _currentPerPage!;
                                _resetData(start: _nextSet - 1);
                              });
                            },
                      padding: EdgeInsets.symmetric(horizontal: 15),
                    )
                  ],
                  headerDecoration: BoxDecoration(
                      color: Colors.grey,
                      border: Border(
                          bottom: BorderSide(color: Colors.red, width: 1))),
                  selectedDecoration: BoxDecoration(
                    border: Border(
                        bottom:
                            BorderSide(color: Colors.green[300]!, width: 1)),
                    color: Colors.green,
                  ),
                  headerTextStyle: TextStyle(color: Colors.white),
                  rowTextStyle: TextStyle(color: Colors.green),
                  selectedTextStyle: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ])),
    );
  }
}

class _DropDownContainer extends StatelessWidget {
  final Map<String, dynamic> data;
  const _DropDownContainer({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> _children = data.entries.map<Widget>((entry) {
      Widget w = Row(
        children: [
          Text(entry.key.toString()),
          Spacer(),
          Text(entry.value.toString()),
        ],
      );
      return w;
    }).toList();

    return Container(
      /// height: 100,
      child: Column(
        /// children: [
        ///   Expanded(
        ///       child: Container(
        ///     color: Colors.red,
        ///     height: 50,
        ///   )),
        /// ],
        children: _children,
      ),
    );
  }
}


class MonitoringList extends StatefulWidget {
  MonitoringList({Key? key}) : super(key: key);
  @override
  _MonitoringListState createState() => _MonitoringListState();
}

class _MonitoringListState extends State<MonitoringList> {
  late List<DatatableHeader> _headers;

  List<int> _perPages = [10, 20, 50, 100];
  int _total = 100;
  int? _currentPerPage = 10;
  List<bool>? _expanded;
  String? _searchKey = "id";

  int _currentPage = 1;
  bool _isSearch = false;
  List<Map<String, dynamic>> _sourceOriginal = [];
  List<Map<String, dynamic>> _sourceFiltered = [];
  List<Map<String, dynamic>> _source = [];
  List<Map<String, dynamic>> _selecteds = [];
  // ignore: unused_field
  String _selectableKey = "id";

  String? _sortColumn;
  bool _sortAscending = true;
  bool _isLoading = true;
  bool _showSelect = true;
  var random = new Random();

  List<Map<String, dynamic>> _generateData({int n = 10}) {
    final List source = List.filled(n, 10);
    List<Map<String, dynamic>> temps = [];
    var i = 1;
    print(i);
    // ignore: unused_local_variable
    for (var data in source) {
      temps.add({
        "id": i,
        "id_aro": "230$i",
        "obj_type": "Cкважина",
        "well_name": "10$i",
        "well_group_name": "$i",
        "preparation_obj_name": "ДНС-2 Еты-Пуровское",
        "field_name": "Еты-Пуровское",
        "company_name": "ГПН-ННГ",
        "date_creation": "20.03.2023",
        "status": "Нерентабельная",
        "status_mer": "В работе",

      });
      i++;
    }
    return temps;
  }

  _initializeData() async {
    _mockPullData();
  }

  _mockPullData() async {
    _expanded = List.generate(_currentPerPage!, (index) => false);

    setState(() => _isLoading = true);
    Future.delayed(Duration(seconds: 3)).then((value) {
      _sourceOriginal.clear();
      _sourceOriginal.addAll(_generateData(n: 15));
      _sourceFiltered = _sourceOriginal;
      _total = _sourceFiltered.length;
      _source = _sourceFiltered.getRange(0, _currentPerPage!).toList();
      setState(() => _isLoading = false);
    });
  }

  _resetData({start = 0}) async {
    setState(() => _isLoading = true);
    var _expandedLen =
        _total - start < _currentPerPage! ? _total - start : _currentPerPage;
    Future.delayed(Duration(seconds: 0)).then((value) {
      _expanded = List.generate(_expandedLen as int, (index) => false);
      _source.clear();
      _source = _sourceFiltered.getRange(start, start + _expandedLen).toList();
      setState(() => _isLoading = false);
    });
  }

  _filterData(value) {
    setState(() => _isLoading = true);

    try {
      if (value == "" || value == null) {
        _sourceFiltered = _sourceOriginal;
      } else {
        _sourceFiltered = _sourceOriginal
            .where((data) => data[_searchKey!]
                .toString()
                .toLowerCase()
                .contains(value.toString().toLowerCase()))
            .toList();
      }

      _total = _sourceFiltered.length;
      var _rangeTop = _total < _currentPerPage! ? _total : _currentPerPage!;
      _expanded = List.generate(_rangeTop, (index) => false);
      _source = _sourceFiltered.getRange(0, _rangeTop).toList();
    } catch (e) {
      print(e);
    }
    setState(() => _isLoading = false);
  }

  @override
  void initState() {
    super.initState();

    /// set headers
    _headers = [
      DatatableHeader(
          text: "№",
          value: "id",
          show: true,
          sortable: true,
          textAlign: TextAlign.center),
      DatatableHeader(
          text: "id АРО",
          value: "id_aro",
          show: true,
          sortable: true,
          textAlign: TextAlign.center),
      DatatableHeader(
          text: "Тип объекта",
          value: "obj_type",
          show: true,
          flex: 2,
          sortable: true,
          textAlign: TextAlign.left,),
      DatatableHeader(
          text: "Скважина",
          value: "well_name",
          show: true,
          sortable: true,
          textAlign: TextAlign.center),
      DatatableHeader(
          text: "Куст",
          value: "well_group_name",
          show: true,
          sortable: true,
          textAlign: TextAlign.left),
      DatatableHeader(
          text: "Объект подготовки",
          value: "preparation_obj_name",
          show: true,
          sortable: true,
          textAlign: TextAlign.left),
      DatatableHeader(
          text: "Месторождение",
          value: "field_name",
          show: true,
          sortable: true,
          textAlign: TextAlign.left),
      DatatableHeader(
          text: "ДО",
          value: "company_name",
          show: true,
          sortable: true,
          textAlign: TextAlign.left),
      DatatableHeader(
          text: "Дата внесения",
          value: "date_creation",
          show: true,
          editable: true,
          sortable: false,
          textAlign: TextAlign.center),
     
      DatatableHeader(
          text: "Статус",
          value: "status",
          show: true,
          editable: true,
          sortable: false,
          textAlign: TextAlign.center),    
      DatatableHeader(
          text: "Статус МЭР",
          value: "status_mer",
          show: true,
          editable: true,
          sortable: false,
          textAlign: TextAlign.center,        
          ),
      
    ];

    _initializeData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Форма заполнения мероприятий"),
        actions: [
          IconButton(
            onPressed: _initializeData,
            icon: Icon(Icons.refresh_sharp),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              leading: Icon(Icons.home),
              title: Text("home"),
              onTap: () {Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const MyHomePage(title: 'Мониторинг АРО',)),
  );},
            ),
            ListTile(
              leading: Icon(Icons.storage),
              title: Text("data"),
              onTap: () {},
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
            Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(0),
              constraints: BoxConstraints(
                maxHeight: 700,
              ),
              child: Card(
                elevation: 1,
                shadowColor: Colors.black,
                clipBehavior: Clip.none,
                child: ResponsiveDatatable(
                  title: TextButton.icon(
                    onPressed: () => {},
                    icon: Icon(Icons.add),
                    label: Text("new item"),
                  ),
                  reponseScreenSizes: [ScreenSize.xs],
                  actions: [
                    if (_isSearch)
                      Expanded(
                          child: TextField(
                        decoration: InputDecoration(
                            hintText: 'Enter search term based on ' +
                                _searchKey!
                                    .replaceAll(new RegExp('[\\W_]+'), ' ')
                                    .toUpperCase(),
                            prefixIcon: IconButton(
                                icon: Icon(Icons.cancel),
                                onPressed: () {
                                  setState(() {
                                    _isSearch = false;
                                  });
                                  _initializeData();
                                }),
                            suffixIcon: IconButton(
                                icon: Icon(Icons.search), onPressed: () {})),
                        onSubmitted: (value) {
                          _filterData(value);
                        },
                      )),
                    if (!_isSearch)
                      IconButton(
                          icon: Icon(Icons.search),
                          onPressed: () {
                            setState(() {
                              _isSearch = true;
                            });
                          })
                  ],
                  headers: _headers,
                  source: _source,
                  selecteds: _selecteds,
                  showSelect: _showSelect,
                  autoHeight: false,
                  dropContainer: (data) {
                    if (int.tryParse(data['id'].toString())!.isEven) {
                      return Text("is Even");
                    }
                    return _DropDownContainer(data: data);
                  },
                  onChangedRow: (value, header) {
                    /// print(value);
                    /// print(header);
                  },
                  onSubmittedRow: (value, header) {
                    /// print(value);
                    /// print(header);
                  },
                  onTabRow: (data) {
                    print(data);
                  },
                  onSort: (value) {
                    setState(() => _isLoading = true);

                    setState(() {
                      _sortColumn = value;
                      _sortAscending = !_sortAscending;
                      if (_sortAscending) {
                        _sourceFiltered.sort((a, b) =>
                            b["$_sortColumn"].compareTo(a["$_sortColumn"]));
                      } else {
                        _sourceFiltered.sort((a, b) =>
                            a["$_sortColumn"].compareTo(b["$_sortColumn"]));
                      }
                      var _rangeTop = _currentPerPage! < _sourceFiltered.length
                          ? _currentPerPage!
                          : _sourceFiltered.length;
                      _source = _sourceFiltered.getRange(0, _rangeTop).toList();
                      _searchKey = value;

                      _isLoading = false;
                    });
                  },
                  expanded: _expanded,
                  sortAscending: _sortAscending,
                  sortColumn: _sortColumn,
                  isLoading: _isLoading,
                  onSelect: (value, item) {
                    print("$value  $item ");
                    if (value!) {
                      setState(() => _selecteds.add(item));
                    } else {
                      setState(
                          () => _selecteds.removeAt(_selecteds.indexOf(item)));
                    }
                  },
                  onSelectAll: (value) {
                    if (value!) {
                      setState(() => _selecteds =
                          _source.map((entry) => entry).toList().cast());
                    } else {
                      setState(() => _selecteds.clear());
                    }
                  },
                  footers: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Text("Rows per page:"),
                    ),
                    if (_perPages.isNotEmpty)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: DropdownButton<int>(
                          value: _currentPerPage,
                          items: _perPages
                              .map((e) => DropdownMenuItem<int>(
                                    child: Text("$e"),
                                    value: e,
                                  ))
                              .toList(),
                          onChanged: (dynamic value) {
                            setState(() {
                              _currentPerPage = value;
                              _currentPage = 1;
                              _resetData();
                            });
                          },
                          isExpanded: false,
                        ),
                      ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child:
                          Text("$_currentPage - $_currentPerPage of $_total"),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios,
                        size: 16,
                      ),
                      onPressed: _currentPage == 1
                          ? null
                          : () {
                              var _nextSet = _currentPage - _currentPerPage!;
                              setState(() {
                                _currentPage = _nextSet > 1 ? _nextSet : 1;
                                _resetData(start: _currentPage - 1);
                              });
                            },
                      padding: EdgeInsets.symmetric(horizontal: 15),
                    ),
                    IconButton(
                      icon: Icon(Icons.arrow_forward_ios, size: 16),
                      onPressed: _currentPage + _currentPerPage! - 1 > _total
                          ? null
                          : () {
                              var _nextSet = _currentPage + _currentPerPage!;

                              setState(() {
                                _currentPage = _nextSet < _total
                                    ? _nextSet
                                    : _total - _currentPerPage!;
                                _resetData(start: _nextSet - 1);
                              });
                            },
                      padding: EdgeInsets.symmetric(horizontal: 15),
                    )
                  ],
                  headerDecoration: BoxDecoration(
                      color: Colors.grey,
                      border: Border(
                          bottom: BorderSide(color: Colors.red, width: 1))),
                  selectedDecoration: BoxDecoration(
                    border: Border(
                        bottom:
                            BorderSide(color: Colors.green[300]!, width: 1)),
                    color: Colors.green,
                  ),
                  headerTextStyle: TextStyle(color: Colors.white),
                  rowTextStyle: TextStyle(color: Colors.green),
                  selectedTextStyle: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ])),
    );
  }
}