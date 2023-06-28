import 'dart:math';
import 'package:aro_monitoring/infrastructure/do_data.dart';
import 'package:aro_monitoring/presentation/core/widgets/drop_down_container.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:responsive_table/responsive_table.dart';
import 'package:logging/logging.dart';

///
class MonitoringBody extends StatefulWidget {
  final DoData _doData;


  ///
  const MonitoringBody({Key? key,
   required DoData doData,}) : 
  _doData = doData,
  super(key: key);
  @override
  State<MonitoringBody> createState() => _MonitoringPageState(doData: _doData,);
}
///
///
class _MonitoringPageState extends State<MonitoringBody> {
    final log = Logger('_MonitoringListState');
    final DoData _doData;
  // late List<DatatableHeader> _headers;
  
  final List<int> _perPages = [10, 20, 50, 100];
  int _total = 100;
  int? _currentPerPage = 10;
  List<bool>? _expanded;
  String? _searchKey = "id";

  int _currentPage = 1;
  bool _isSearch = false;
  final List<Map<String, dynamic>> _sourceOriginal = [];
  List<Map<String, dynamic>> _sourceFiltered = [];
  List<Map<String, dynamic>> _source = [];
  List<Map<String, dynamic>> _selecteds = [];
  // ignore: unused_field
  final String _selectableKey = "id";

  String? _sortColumn;
  bool _sortAscending = true;
  bool _isLoading = true;
  final bool _showSelect = true;
  final random = Random();

  _MonitoringPageState({
    required DoData doData,
  }) :
    _doData = doData;

  Future<void> _initializeData() async {
    log.fine('._initializeData ...');
    _isLoading = true;
    if (mounted) {
      setState(() {return;});
    }
    _expanded = List.generate(_currentPerPage!, (index) => false);
    return _doData.all().then((result) {
      log.fine('._initializeData._doData.all | result: $result');
      result.fold(
        onData: (doData) {
          _sourceOriginal.clear();
          _sourceOriginal.addAll(
            doData,
          );
          _sourceFiltered = _sourceOriginal;
          _total = _sourceFiltered.length;
          _source = _sourceFiltered.getRange(0, _currentPerPage!).toList();
        }, 
        onError: (
          (error) {
            log.warning('._initializeData | error: $error');
          }
        ),
      );
    }).whenComplete(() {
      _isLoading = false;
      if (mounted) {
        setState(() {return;});
      }
    });
  }

  _resetData({start = 0}) async {
    setState(() => _isLoading = true);
    var expandedLen =
        _total - start < _currentPerPage! ? _total - start : _currentPerPage;
    Future.delayed(const Duration(seconds: 0)).then((value) {
      _expanded = List.generate(expandedLen as int, (index) => false);
      _source.clear();
      _source = _sourceFiltered.getRange(start, start + expandedLen).toList();
      setState(() => _isLoading = false);
    });
  }
  ///
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
      var rangeTop = _total < _currentPerPage! ? _total : _currentPerPage!;
      _expanded = List.generate(rangeTop, (index) => false);
      _source = _sourceFiltered.getRange(0, rangeTop).toList();
    } catch (e) {
      log.warning('._filterData | error: $e');
    }
    setState(() => _isLoading = false);
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
    _initializeData();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                  label: const Text("new item", style: TextStyle(fontFamily:  'GPN_DIN'),),
                ),
                reponseScreenSizes: const [ScreenSize.xs],
                actions: [
                  if (_isSearch)
                    Expanded(
                        child: TextField(
                        decoration: InputDecoration(
                            hintText: 'Enter search term based on ${_searchKey!
                                    .replaceAll(RegExp('[\\W_]+'), ' ')
                                    .toUpperCase()}',
                            prefixIcon: IconButton(
                                icon: const Icon(Icons.cancel),
                                onPressed: () {
                                  setState(() {
                                    _isSearch = false;
                                  });
                                  _initializeData();
                                },),
                            suffixIcon: IconButton(
                                icon: const Icon(Icons.search), onPressed: () {
                                  // TODO onPressed to be implemented...
                                },
                            ),
                        ),
                        onSubmitted: (value) {
                          _filterData(value);
                        },
                      ),
                    )
                  else
                    const Expanded(child: SizedBox.shrink()),
                  if (!_isSearch)
                    IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          setState(() {
                            _isSearch = true;
                          });
                        },
                      ),
                  if (!_isLoading)
                    IconButton(
                      onPressed: _initializeData, 
                      icon: const Icon(Icons.replay),
                    )
                  else 
                    const Icon(Icons.replay),

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
                  // print(value);
                  // print(header);
                  // TODO onChangedRow to be implemented
                  return;
                },
                onSubmittedRow: (value, header) {
                  // print(value);
                  // print(header);
                  // TODO onChangedRow to be implemented
                  return;
                },
                onTabRow: (data) {
                  log.fine('.build..onTabRow | data: $data');
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
                  log.fine('.build..onSelect | value: $value  item: $item ');
                  if (value!) {
                    setState(() => _selecteds.add(item));
                  } else {
                    setState(
                        () => _selecteds.removeAt(_selecteds.indexOf(item)),);
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
                            var nextSet = _currentPage + _currentPerPage!;

                            setState(() {
                              _currentPage = nextSet < _total
                                  ? nextSet
                                  : _total - _currentPerPage!;
                              _resetData(start: nextSet - 1);
                            });
                          },
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                  ),
                ],
                headerDecoration: const BoxDecoration(
                    color: Colors.grey,
                    border: Border(
                        bottom: BorderSide(color: Colors.red, width: 1),
                    ),
                ),
                selectedDecoration: BoxDecoration(
                  border: Border(
                      bottom:
                          BorderSide(color: Colors.green[300]!, width: 1),
                  ),
                  color: Colors.green,
                ),
                headerTextStyle: const TextStyle(color: Colors.white, fontFamily: 'GPN_DIN'),
                rowTextStyle: const TextStyle(color: Colors.green, fontFamily: 'GPN_DIN'),
                selectedTextStyle: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


final _headers = [
  DatatableHeader(
    text: "№",
    value: "id",
    show: true,
    sortable: true,
    textAlign: TextAlign.center,
  ),
  DatatableHeader(
    text: "id АРО",
    value: "id_aro",
    show: true,
    sortable: true,
    textAlign: TextAlign.center,
  ),
  DatatableHeader(
    text: "Тип объекта",
    value: "obj_type",
    show: true,
    flex: 2,
    sortable: true,
    textAlign: TextAlign.center,
  ),
  DatatableHeader(
    text: "Скважина",
    value: "well_name",
    show: true,
    sortable: true,
    textAlign: TextAlign.center,
  ),
  DatatableHeader(
    text: "Куст",
    value: "well_group_name",
    show: true,
    sortable: true,
    textAlign: TextAlign.center,
  ),
  DatatableHeader(
    text: "Объект подготовки",
    value: "preparation_obj_name",
    show: true,
    sortable: true,
    textAlign: TextAlign.center,
  ),
  DatatableHeader(
    text: "Месторождение",
    value: "field_name",
    show: true,
    sortable: true,
    textAlign: TextAlign.center,
  ),
  DatatableHeader(
    text: "ДО",
    value: "compnay_name",
    show: true,
    sortable: true,
    textAlign: TextAlign.center
  ),
  DatatableHeader(
    text: "Дата внесения",
    value: "date_creation",
    show: true,
    editable: false,
    sortable: false,
    textAlign: TextAlign.center,
    
  ),
  DatatableHeader(
    text: "Статус",
    value: "status",
    show: true,
    editable: false,
    sortable: false,
    textAlign: TextAlign.center,
    
  ),
  DatatableHeader(
    text: "Статус МЭР",
    value: "status_mer",
    show: true,
    editable: false,
    sortable: false,
    textAlign: TextAlign.center,
  ),
];

