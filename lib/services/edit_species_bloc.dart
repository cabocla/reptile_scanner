import 'package:reptile_scanner/models/species.dart';
import 'package:reptile_scanner/services/database.dart';

class EditSpeciesBloc {
  final Species? oldSpecies;
  final Database database;

  EditSpeciesBloc({this.oldSpecies, required this.database});

  String? commonName;
  String? scientificName;
  String? speciesID;
  AnimalType animalType = AnimalType.snake;
  VenomLevel venom = VenomLevel.non;
  bool dataChanged = false;

  void initState() {
    if (oldSpecies != null) {
      Species species = oldSpecies!;
      commonName = species.commonName;
      scientificName = species.scientificName;
      speciesID = species.speciesID;
      animalType = species.animalType;
      venom = species.venom;
    }
  }

  void saveSpecies() {
    Species newSpecies = Species(
      speciesID: speciesID,
      commonName: commonName!,
      scientificName: scientificName!,
      animalType: animalType,
      venom: venom,
    );
    if (oldSpecies != null) {
      print('update species');
      database.updateSpecies(newSpecies);
    } else {
      print('add new species');
      database.addSpecies(newSpecies);
      // database.testInputData();
    }
  }

  String? validateForm() {
    String? message;
    if (scientificName == null || scientificName!.trim() == '') {
      message = 'Scientific name is required';
    }
    if (commonName == null || commonName!.trim() == '') {
      message = 'Common name is required';
    }
    // if (genusName == null || genusName == '') {
    //   message = 'Genus name is required';
    // }
    // if (speciesName == null || speciesName == '') {
    //   message = 'Species name is required';
    // }
    return message;
  }
}
