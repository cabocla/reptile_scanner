import 'package:reptile_scanner/models/pet.dart';

class Clutch {
  final Pet sire;
  final Pet dam;
  final int goodEggCount;
  final int badEggCount;
  final DateTime layDate;
  final DateTime expectedHatchDate;

  Clutch({
    required this.sire,
    required this.dam,
    required this.goodEggCount,
    required this.badEggCount,
    required this.layDate,
    required this.expectedHatchDate,
  });

  int get totalEggCount {
    return goodEggCount + badEggCount;
  }
}
