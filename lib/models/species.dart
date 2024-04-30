enum AnimalType {
  snake,
  lizard,
  tortoise,
  turtle,
  gecko,
  crocodilia,
  amphibian,
  tarantula,
  anthropod,
  insect,
  mammals,
  fish,
  bird,
  other,
}

enum VenomLevel {
  non,
  low,
  medium,
  high,
}

class Species {
  final String? speciesID;
  final String scientificName;
  final String commonName;
  final AnimalType animalType;
  final VenomLevel venom;

  Species({
    this.speciesID,
    required this.scientificName,
    required this.commonName,
    this.animalType = AnimalType.snake,
    this.venom = VenomLevel.non,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'animalType': animalType.toString(),
      'venom': venom.toString(),
      'commonName': commonName,
      'scientificName': scientificName,
    };
    return map;
  }

  factory Species.fromMap(String id, Map<String, dynamic> data) {
    String commonName = data['commonName'];
    String scientificName = data['scientificName'];

    String? animalTypeString = data['animalType'];
    AnimalType animalType = AnimalType.snake;
    if (animalTypeString != null) {
      animalType = AnimalType.values
          .firstWhere((element) => element.toString() == animalTypeString);
    }

    String? venomString = data['venom'];
    VenomLevel venom = VenomLevel.non;
    if (venomString != null) {
      venom = VenomLevel.values
          .firstWhere((element) => element.toString() == venomString);
    }
    return Species(
      speciesID: id,
      commonName: commonName,
      scientificName: scientificName,
      animalType: animalType,
      venom: venom,
    );
  }

  static const Map<AnimalType, String> animalTypeString = {
    AnimalType.snake: 'Snake',
    AnimalType.lizard: 'Lizard',
    AnimalType.gecko: 'Gecko',
    AnimalType.tortoise: 'Tortoise',
    AnimalType.turtle: 'Turtle',
    AnimalType.amphibian: 'Amphibian',
    AnimalType.mammals: 'Mammals',
    AnimalType.tarantula: 'Tarantula',
    AnimalType.bird: 'Bird',
    AnimalType.fish: 'Fish',
    AnimalType.insect: 'Insect',
    AnimalType.anthropod: 'Anthropod',
    AnimalType.crocodilia: 'Crocodilia',
    AnimalType.other: 'Other',
  };

  static const Map<VenomLevel, String> venomString = {
    VenomLevel.non: 'N/A',
    VenomLevel.low: 'Low',
    VenomLevel.medium: 'Medium',
    VenomLevel.high: 'High',
  };
}
