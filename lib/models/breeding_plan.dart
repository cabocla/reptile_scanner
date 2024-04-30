class BreedingPlan {
  final String breedingID;
  final bool isActive;
  final String sireID;
  final String damID;
  final String speciesID;
  final DateTime season;
  final bool liveBirth;
  final DateTime? copulation;
  final DateTime? ovulation;
  final DateTime? prelayShed;
  final DateTime? expectedLay;
  final DateTime? deliver;

  BreedingPlan({
    required this.breedingID,
    required this.isActive,
    required this.sireID,
    required this.damID,
    required this.speciesID,
    required this.season,
    this.liveBirth = false,
    this.copulation,
    this.ovulation,
    this.prelayShed,
    this.expectedLay,
    this.deliver,
  });

  Map<String, dynamic> toMap() {
    return {
      'sireID': sireID,
      'damID': damID,
      'speciesID': speciesID,
      'isActive': isActive,
      'season': season.year,
      'liveBirth': liveBirth,
      'copulation': copulation == null ? null : copulation!.toIso8601String(),
      'ovulation': ovulation == null ? null : ovulation!.toIso8601String(),
      'prelayShed': prelayShed == null ? null : prelayShed!.toIso8601String(),
      'expectedLay':
          expectedLay == null ? null : expectedLay!.toIso8601String(),
      'deliver': deliver == null ? null : deliver!.toIso8601String(),
    };
  }

  factory BreedingPlan.fromMap(String id, Map<String, dynamic> data) {
    return BreedingPlan(
      breedingID: id,
      isActive: data['isActive'] ?? true,
      sireID: data['sireID'],
      damID: data['damID'],
      speciesID: data['speciesID'],
      season: DateTime(data['season']),
      liveBirth: data['liveBirth'],
      copulation: data['copulation'] == null
          ? null
          : DateTime.parse(data['copulation']),
      ovulation:
          data['ovulation'] == null ? null : DateTime.parse(data['ovulation']),
      prelayShed: data['prelayShed'] == null
          ? null
          : DateTime.parse(data['prelayShed']),
      expectedLay: data['expectedLay'] == null
          ? null
          : DateTime.parse(data['expectedLay']),
      deliver: data['deliver'] == null ? null : DateTime.parse(data['deliver']),
    );
  }
  // Clutch createClutch() {
  //   return Clutch(
  //     sire: sire,
  //     dam: dam,
  //     goodEggCount: goodEggCount,
  //     badEggCount: badEggCount,
  //     layDate: layEggsOrDeliver,
  //     expectedHatchDate: expectedHatchDate,
  //   );
  // }
}
