import 'package:reptile_scanner/models/colony.dart';
import 'package:reptile_scanner/models/pet.dart';
import 'package:reptile_scanner/services/database.dart';

class EditColonyBloc {
  final Colony? oldColony;
  final Database database;

  EditColonyBloc({
    this.oldColony,
    required this.database,
  });

  String? databaseID;
  String? colonyName;
  List<Pet> petList = [];

  bool dataChanged = false;

  void initState() {
    if (oldColony != null) {
      Colony colony = oldColony!;
      databaseID = colony.databaseID;
      colonyName = colony.colonyName;
      petList = colony.petList!;
    }
  }

  String? validateForm() {
    String? msg;
    if (petList.isEmpty) {
      msg = 'Must at least have 1 pet in the colony';
    }
    if (colonyName == null || colonyName!.trim() == '') {
      msg = 'Colony name is required';
    }
    return msg;
  }

  void saveColony() {
    Colony newColony = Colony(
      databaseID: databaseID ?? '',
      colonyName: colonyName!,
      petList: petList,
    );
    if (oldColony != null) {
      database.updateColony(newColony);
    } else {
      database.addColony(newColony);
    }
  }
}
