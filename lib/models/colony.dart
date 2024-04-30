import 'package:reptile_scanner/models/pet.dart';

class Colony {
  final String? databaseID;
  final String colonyName;
  final List<Pet>? petList;

  Colony({
    this.databaseID,
    required this.colonyName,
    this.petList,
  });

  Map<String, dynamic> toMap() {
    List<String> petIDList = [];
    if (petList != null || petList!.isNotEmpty) {
      petList!.map((e) => e.databaseID).toList();
    }
    return {
      'colonyName': colonyName,
      'petIDList': petIDList,
    };
  }

  factory Colony.fromMap(String colonyID, Map<String, dynamic> data,
      {List<Pet>? petList}) {
    String name = data['colonyName'];
    return Colony(
      databaseID: colonyID,
      colonyName: name,
      petList: petList ?? [],
    );
  }
}
