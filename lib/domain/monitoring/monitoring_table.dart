class MonitoringTable {
  late final int id;
  late final String name;
  late final int age;
  late final int distancefromsun;
  ///
  MonitoringTable({
    required this.id,
    required this.name,
    required this.age,
    required this.distancefromsun,
  });
  ///
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
      'distancefromsun': distancefromsun,
    };
  }
}

