import 'dart:math';

import 'package:aro_monitoring/infrastructure/dos.dart';
import 'package:aro_monitoring/infrastructure/generated_data.dart';
import 'package:aro_monitoring/presentation/core/widgets/drop_down_container.dart';
import 'package:aro_monitoring/presentation/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:responsive_table/responsive_table.dart';

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
  final random = Random();

  _initializeData() async {
    _mockPullData();
  }

  _mockPullData() async {
    _expanded = List.generate(_currentPerPage!, (index) => false);

    setState(() => _isLoading = true);
    Future.delayed(const Duration(seconds: 3)).then((value) {
      _sourceOriginal.clear();
      _sourceOriginal.addAll(generateData(n: 15));
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
    Future.delayed(const Duration(seconds: 0)).then((value) {
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
        title: const Text("Форма заполнения мероприятий"),
        actions: [
          IconButton(
            onPressed: _initializeData,
            icon: const Icon(Icons.refresh_sharp),
          ),
        ],
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
      builder: (context) => const MyHomePage(
        title: 'Мониторинг АРО',
        doList: doList,
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
      body: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
            Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(0),
              constraints: const BoxConstraints(
                maxHeight: 700,
              ),
              child: Card(
                elevation: 1,
                shadowColor: Colors.black,
                clipBehavior: Clip.none,
                child: ResponsiveDatatable(
                  title: TextButton.icon(
                    onPressed: () => {},
                    icon: const Icon(Icons.add),
                    label: const Text("new item"),
                  ),
                  reponseScreenSizes: const [ScreenSize.xs],
                  actions: [
                    if (_isSearch)
                      Expanded(
                          child: TextField(
                        decoration: InputDecoration(
                            hintText: 'Enter search term based on ${
                              _searchKey!
                                .replaceAll(RegExp('[\\W_]+'), ' ')
                                .toUpperCase()
                            }',
                            prefixIcon: IconButton(
                                icon: const Icon(Icons.cancel),
                                onPressed: () {
                                  setState(() {
                                    _isSearch = false;
                                  });
                                  _initializeData();
                                },),
                            suffixIcon: IconButton(
                                icon: const Icon(Icons.search), 
                                  onPressed: () {
                                    // TODO onPress to be implemented
                                  },
                                ),
                        ),
                        onSubmitted: (value) {
                          _filterData(value);
                        },
                      ),),
                    if (!_isSearch)
                      IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () {
                            setState(() {
                              _isSearch = true;
                            });
                          },),
                  ],
                  headers: _headers,
                  source: _source,
                  selecteds: _selecteds,
                  showSelect: _showSelect,
                  autoHeight: false,
                  dropContainer: (data) {
                    if (int.tryParse(data['id'].toString())!.isEven) {
                      return const Text("is Even");
                    }
                    return DropDownContainer(data: data);
                  },
                  onChangedRow: (value, header) {
                    /// print(value);
                    /// print(header);
                    // TODO onPress to be implemented
                  },
                  onSubmittedRow: (value, header) {
                    /// print(value);
                    /// print(header);
                    // TODO onPress to be implemented
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
                      var rangeTop = _currentPerPage! < _sourceFiltered.length
                          ? _currentPerPage!
                          : _sourceFiltered.length;
                      _source = _sourceFiltered.getRange(0, rangeTop).toList();
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
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: const Text("Rows per page:"),
                    ),
                    if (_perPages.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: DropdownButton<int>(
                          value: _currentPerPage,
                          items: _perPages
                              .map((e) => DropdownMenuItem<int>(
                                    value: e,
                                    child: Text("$e"),
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
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child:
                          Text("$_currentPage - $_currentPerPage of $_total"),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        size: 16,
                      ),
                      onPressed: _currentPage == 1
                          ? null
                          : () {
                              var nextSet = _currentPage - _currentPerPage!;
                              setState(() {
                                _currentPage = nextSet > 1 ? nextSet : 1;
                                _resetData(start: _currentPage - 1);
                              });
                            },
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward_ios, size: 16),
                      onPressed: _currentPage + _currentPerPage! - 1 > _total
                          ? null
                          : () {
                              var nextSet0 = _currentPage + _currentPerPage!;

                              setState(() {
                                _currentPage = nextSet0 < _total
                                    ? nextSet0
                                    : _total - _currentPerPage!;
                                _resetData(start: nextSet0 - 1);
                              });
                            },
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                    )
                  ],
                  headerDecoration: const BoxDecoration(
                      color: Colors.grey,
                      border: Border(
                          bottom: BorderSide(color: Colors.red, width: 1))),
                  selectedDecoration: BoxDecoration(
                    border: Border(
                        bottom:
                            BorderSide(color: Colors.green[300]!, width: 1)),
                    color: Colors.green,
                  ),
                  headerTextStyle: const TextStyle(color: Colors.white),
                  rowTextStyle: const TextStyle(color: Colors.green),
                  selectedTextStyle: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],),),
    );
  }
}


final _headers = [
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