import 'package:intl/intl.dart';

enum Sex {
  male,
  female,
  unknown,
}

enum AnimalStatus {
  owned,
  forSale,
  sold,
  archived,
}

class Pet {
  final String databaseID;
  final String? colonyID;
  final String petName; //could be ID
  final String speciesID;
  final String? genetic;
  final Sex sex;
  final DateTime? dateOfBirth;
  final int? weight;
  final int? length;
  final String feedID;
  final int feedAmount;
  final bool customFeedDay;
  final int feedingInterval;
  final DateTime? lastFed;
  final List<String>? feedingDays;
  final bool selfProduced;
  final DateTime? dateAcquired;
  final String? breederInformation;
  final double? purchasePrice;
  final String? sireID;
  final String? damID;
  final String? sireGenetics;
  final String? damGenetics;
  final AnimalStatus status;
  final String? note;

  Pet({
    required this.databaseID,
    required this.petName,
    required this.speciesID,
    required this.feedID,
    this.colonyID,
    this.genetic,
    this.sex = Sex.unknown,
    this.dateOfBirth,
    this.weight,
    this.length,
    this.feedAmount = 1,
    this.customFeedDay = false,
    this.feedingDays,
    this.feedingInterval = 1,
    this.lastFed, //TODO make cloud function to update this when logged feed activity
    this.selfProduced = false,
    this.dateAcquired,
    this.breederInformation,
    this.purchasePrice,
    this.sireID,
    this.damID,
    this.sireGenetics,
    this.damGenetics,
    this.status = AnimalStatus.owned,
    this.note,
  });

  String dateTimeString(DateTime dateTime) {
    return DateFormat('d MMMM yyyy').format(dateTime);
  }

  Map<String, dynamic> toMap() {
    // Map<String, dynamic> map = species.toMap();
    Map<String, dynamic> map = {};

    if (dateOfBirth != null) {
      map.addAll({
        'dob': dateOfBirth!.toIso8601String(),
      });
    }
    if (colonyID != null) {
      map.addAll({'colonyID': colonyID});
    }
    if (lastFed != null) {
      map.addAll({
        'lastFed': lastFed!.toIso8601String(),
      });
    }
    if (weight != null) {
      map.addAll({'weight': weight});
    }
    if (length != null) {
      map.addAll({'length': length});
    }
    if (dateAcquired != null) {
      map.addAll({'dateAcquired': dateAcquired!.toIso8601String()});
    }
    if (breederInformation != null) {
      map.addAll({'breederInfo': breederInformation});
    }
    if (purchasePrice != null) {
      map.addAll({'purchasePrice': purchasePrice});
    }
    if (sireID != null) {
      map.addAll({'sireID': sireID});
    }
    if (damID != null) {
      map.addAll({'damID': damID});
    }
    if (sireGenetics != null) {
      map.addAll({'sireGene': sireGenetics});
    }
    if (damGenetics != null) {
      map.addAll({'damGene': damGenetics});
    }
    if (note != null) {
      map.addAll({'note': note});
    }
    map.addAll({
      'petName': petName,
      'speciesID': speciesID,
      'feedID': feedID,
      'genetic': genetic,
      'sex': sex.toString(),
      'feedAmount': feedAmount,
      'status': status.toString(),
      'selfProduced': selfProduced,
      'customFeedDay': customFeedDay,
      'feedingInterval': feedingInterval,
      'feedingDays': feedingDays,
    });

    return map;
  }

  factory Pet.fromMap(String id, Map<String, dynamic> data) {
    DateTime? dateOfBirth;
    if (data['dob'] != null) {
      dateOfBirth = DateTime.parse(data['dob']);
    }
    DateTime? dateAcquired;
    if (data['dateAcquired'] != null) {
      dateAcquired = DateTime.parse(data['dateAcquired']);
    }
    DateTime? lastFed;
    if (data['lastFed'] != null) {
      lastFed = DateTime.parse(data['lastFed']);
    }
    String petName = data['petName'];
    String speciesID = data['speciesID'];
    String feedID = data['feedID'];
    String? colonyID = data['colonyID'];
    Sex sex = Sex.values.firstWhere(
        (element) => element.toString() == data['sex'],
        orElse: () => Sex.unknown);
    String genetic = data['genetic'];
    bool selfProduced = data['selfProduced'] ?? false;
    int? weight = data['weight'];
    int? length = data['length'];
    int feedAmount = data['feedAmount'] ?? 1;
    List<String>? feedingDays = List<String>.from(data['feedingDays'] ?? []);
    int feedingInterval = data['feedingInterval'];
    bool customFeedDay = data['customFeedDay'] ?? feedingDays.isNotEmpty;
    String? breederInformation = data['breederInfo'];
    double? purchasePrice = data['purchasePrice'];
    String? sireID = data['sireID'];
    String? damID = data['damID'];
    String? sireGenetics = data['sireGene'];
    String? damGenetics = data['damGene'];
    AnimalStatus status = AnimalStatus.values.firstWhere(
      (element) => element.toString() == data['status'],
      orElse: () => AnimalStatus.owned,
    );

    String? note = data['note'];

    Pet pet = Pet(
      databaseID: id,
      colonyID: colonyID,
      petName: petName,
      speciesID: speciesID,
      feedID: feedID,
      sex: sex,
      genetic: genetic,
      dateOfBirth: dateOfBirth,
      selfProduced: selfProduced,
      dateAcquired: dateAcquired,
      weight: weight,
      length: length,
      feedAmount: feedAmount,
      customFeedDay: customFeedDay,
      feedingDays: feedingDays,
      feedingInterval: feedingInterval,
      lastFed: lastFed,
      breederInformation: breederInformation,
      purchasePrice: purchasePrice,
      sireID: sireID,
      damID: damID,
      sireGenetics: sireGenetics,
      damGenetics: damGenetics,
      status: status,
      note: note,
    );
    // print(data.toString());
    // print(id);
    // print(petName);
    // print(speciesID);
    // print(feedID);
    // print(note);
    // print(status);
    // print(damGenetics);
    // print(sireGenetics);
    // print(damID);
    // print(sireID);
    // print(purchasePrice);
    // print(breederInformation);
    // print(feedingInterval);
    // print(feedingDays);
    // print(customFeedDay);
    // print(feedAmount);
    // print(length);
    // print(weight);
    // print(dateAcquired!.toIso8601String());
    // print(selfProduced);
    // print(dateOfBirth!.toIso8601String());
    // print(genetic);
    // print(sex.toString());
    return pet;
  }
}
