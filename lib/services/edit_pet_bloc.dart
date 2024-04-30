import 'package:intl/intl.dart';
import 'package:reptile_scanner/models/pet.dart';
import 'package:reptile_scanner/services/database.dart';

class EditPetBloc {
  final Pet? oldPet;
  final Database database;

  EditPetBloc({
    this.oldPet,
    required this.database,
  });

  bool isEdit = false;

  String? databaseID;
  String? petName; //could be ID
  String? speciesID;
  String? colonyID;
  String? genetic;
  Sex sex = Sex.unknown;
  DateTime? dateOfBirth;
  int? weight;
  int? length;
  String? feedID;
  int feedAmount = 1;
  Duration? feedSchedule; //once every x hour
  bool selfProduced = false;
  DateTime? dateAcquired;
  String? breederInformation;
  double? purchasePrice;
  String? sireID;
  String? damID;
  String? sireGenetics;
  String? damGenetics;
  AnimalStatus status = AnimalStatus.owned;
  String? note;

  int feedingIntervalDays = 1;
  List<String> feedingDays = [];
  bool customSchedule = false;

  void initState() {
    if (oldPet != null) {
      Pet pet = oldPet!;
      databaseID = pet.databaseID;
      petName = pet.petName; //could be ID
      speciesID = pet.speciesID;
      colonyID = pet.colonyID;
      genetic = pet.genetic;
      sex = pet.sex;
      dateOfBirth = pet.dateOfBirth;
      weight = pet.weight;
      length = pet.length;
      feedID = pet.feedID;
      feedAmount = pet.feedAmount;
      feedingIntervalDays = pet.feedingInterval;
      customSchedule = pet.customFeedDay;
      feedingDays = pet.feedingDays ?? [];
      selfProduced = pet.selfProduced;
      dateAcquired = pet.dateAcquired;
      breederInformation = pet.breederInformation;
      purchasePrice = pet.purchasePrice;
      sireID = pet.sireID;
      damID = pet.damID;
      sireGenetics = pet.sireGenetics;
      damGenetics = pet.damGenetics;
      status = pet.status;
      note = pet.note;
    }
  }

  String? validateForm() {
    String? msg;
    if (!customSchedule && feedingIntervalDays == 0) {
      msg = 'Feeding day interval must not be 0';
    }
    if (customSchedule && feedingDays.isEmpty) {
      msg = 'Feeding day is required';
    }
    if (feedID == null) {
      msg = 'Feeder is required';
    }
    if (speciesID == null) {
      msg = 'Species is required';
    }
    if (petName == null) {
      msg = 'Pet name is required';
    }
    return msg;
  }

  void savePet() {
    List<String>? feedDays;
    if (customSchedule) {
      feedDays = feedingDays;
    }
    Pet newPet = Pet(
      databaseID: databaseID ?? '',
      petName: petName!,
      speciesID: speciesID!,
      feedID: feedID!,
      colonyID: colonyID,
      sex: sex,
      genetic: genetic,
      dateOfBirth: dateOfBirth,
      selfProduced: selfProduced,
      dateAcquired: dateAcquired,
      weight: weight,
      length: length,
      customFeedDay: customSchedule,
      feedAmount: feedAmount,
      feedingDays: feedDays,
      feedingInterval: feedingIntervalDays,
      breederInformation: breederInformation,
      purchasePrice: purchasePrice,
      sireID: sireID,
      damID: damID,
      sireGenetics: sireGenetics,
      damGenetics: damGenetics,
      status: status,
      note: note,
    );
    if (oldPet != null) {
      database.updatePet(newPet);
    } else {
      database.addPet(newPet);
    }
  }
}
