import 'package:aro_monitoring/infrastructure/dep_objects.dart';
import 'package:aro_monitoring/infrastructure/do_data.dart';
import 'package:aro_monitoring/infrastructure/sql/sql_query.dart';
import 'package:aro_monitoring/presentation/data/widgets/data_body.dart';
import 'package:aro_monitoring/presentation/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:responsive_table/responsive_table.dart';

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
                    builder: (context) => const HomePage(
                      title: 'Мониторинг АРО',
                      depObjects: DepObjects(
                        sqlQuery: SqlQuery(sql: 'Some real sql query to get required data'),
                      ),
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


final _headers = [
  DatatableHeader(
    text: "№",
    value: "id",
    show: true,
    sortable: true,
    textAlign: TextAlign.center,
  ),
  DatatableHeader(
    text: "Тип объекта",
    value: "name",
    show: true,
    flex: 2,
    sortable: true,
    textAlign: TextAlign.left,
  ),
  DatatableHeader(
    text: "Скважина",
    value: "well",
    show: true,
    sortable: true,
    textAlign: TextAlign.center,
  ),
  DatatableHeader(
    text: "Куст",
    value: "pad",
    show: true,
    sortable: true,
    textAlign: TextAlign.left,
  ),
  DatatableHeader(
    text: "Объект подготовки",
    value: "prep_object",
    show: true,
    sortable: true,
    textAlign: TextAlign.left,
  ),
  DatatableHeader(
    text: "Месторождение",
    value: "field",
    show: true,
    sortable: true,
    textAlign: TextAlign.left,
  ),
  DatatableHeader(
    text: "ДО",
    value: "company",
    show: true,
    sortable: true,
    textAlign: TextAlign.left,
  ),
  DatatableHeader(
    text: "Мероприятие",
    value: "activity",
    show: true,
    editable: true,
    sortable: true,
    textAlign: TextAlign.left,
  ),
  DatatableHeader(
    text: "Комментарии к мероприятию",
    value: "comment",
    show: true,
    sortable: false,
    editable: true,
    textAlign: TextAlign.center,
  ),
  DatatableHeader(
    text: "Дата выполнения",
    value: "date_fact",
    show: true,
    editable: true,
    sortable: false,
    textAlign: TextAlign.center,
  ),
  DatatableHeader(
    text: "Планируемая дата",
    value: "date_planning",
    show: true,
    editable: true,
    sortable: false,
    textAlign: TextAlign.center,
  ),
  DatatableHeader(
    text: "Дата направления мероприятия",
    value: "date_creation",
    show: true,
    editable: true,
    sortable: false,
    textAlign: TextAlign.center,
  ),
  DatatableHeader(
    text: "Ответственный",
    value: "responsible_person",
    show: true,
    editable: true,
    sortable: false,
    textAlign: TextAlign.center,
  ),
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
    textAlign: TextAlign.center,
  ),
];
