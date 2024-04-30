import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:reptile_scanner/models/activity/activity.dart';
import 'package:reptile_scanner/models/activity/feeding.dart';
import 'package:reptile_scanner/models/colony.dart';
import 'package:reptile_scanner/models/feeder.dart';
import 'package:reptile_scanner/models/pet.dart';
import 'package:reptile_scanner/models/species.dart';
import 'package:reptile_scanner/models/user_data.dart';
import 'package:reptile_scanner/services/api_path.dart';

abstract class Database extends ChangeNotifier {
  Future<void> testInputData();

  Stream<UserData> userDataStream();
  Future<void> updateUserData(UserData userData);

  Stream<Pet> petStream(String petID);
  Future<Pet> petFuture(String petID);
  Stream<List<Pet>> myPetsStream();
  Stream<List<Pet>> parentPetStream(Species species, bool isSire);
  Future<void> addPet(Pet pet);
  Future<void> updatePet(Pet pet);
  Future<void> deletePet(Pet pet);

  Future<Species> speciesFuture(String speciesID);
  Stream<List<Species>> speciesStream();
  Future<void> addSpecies(Species species);
  Future<void> updateSpecies(Species species);
  Future<void> deleteSpecies(Species species);

  Future<Feed> feederFuture(String feedID);
  Stream<List<Feed>> feederStream();
  Future<void> addFeeder(Feed feed);
  Future<void> updateFeeder(Feed feed);
  Future<void> deleteFeeder(Feed feed);

  Future<Colony> colonyFuture(String colonyID);
  Stream<List<Colony>> colonyStream();
  Future<void> addColony(Colony colony);
  Future<void> updateColony(Colony colony);
  Future<void> deleteColony(Colony colony);

  Future<void> logActivity(Activity activity);
}

class FirestoreDatabase extends ChangeNotifier implements Database {
  final apiPath = APIPath();
  final String? uid;

  FirestoreDatabase({
    this.uid,
  });

  FirebaseFirestore get _firebase {
    return FirebaseFirestore.instance;
  }

  @override
  Future<void> testInputData() async {
    final path = apiPath.userSpeciesList(uid!);

    CollectionReference pets = _firebase.collection(path);
    pets.add({
      'uid': uid,
      'name': 'test name',
      'DOB': DateTime.now().toIso8601String(),
      'weight': 1200,
      'length': 120,
    }).catchError((error) => print('error: $error'));
  }

  @override
  Stream<UserData> userDataStream() {
    final path = apiPath.userDataPath(uid!);
    DocumentReference<Map<String, dynamic>> doc = _firebase.doc(path);
    return doc
        .snapshots()
        .map((event) => UserData.fromMap(event.id, event.data()!));
  }

  @override
  Future<void> updateUserData(UserData userData) {
    final path = apiPath.userDataPath(uid!);
    DocumentReference doc = _firebase.doc(path);
    return doc.set(userData.toMap());
  }

  @override
  Stream<List<Pet>> myPetsStream() {
    final path = apiPath.userPetList(uid!);
    return _collectionStream(path, (data, id) => Pet.fromMap(id, data));
  }

  @override
  Stream<List<Pet>> parentPetStream(Species? species, bool isSire) {
    //TODO cloud function filter stream pet based on sex and species
    return myPetsStream();
  }

  @override
  Future<Pet> petFuture(String petID) async {
    final path = apiPath.userPetPath(uid!, petID);
    DocumentReference<Map<String, dynamic>> doc = _firebase.doc(path);
    var petData = await doc.get();
    return Pet.fromMap(petID, petData.data()!);
  }

  @override
  Stream<Pet> petStream(String petID) {
    final path = apiPath.userPetPath(uid!, petID);
    DocumentReference<Map<String, dynamic>> doc = _firebase.doc(path);
    return doc.snapshots().map((event) => Pet.fromMap(event.id, event.data()!));
  }

  @override
  Future<void> addPet(Pet pet) {
    final path = apiPath.userPetList(uid!);
    return addDoc(path, pet.toMap());
  }

  @override
  Future<void> updatePet(Pet pet) {
    final path = apiPath.userPetPath(uid!, pet.databaseID);
    return updateDoc(path, pet.toMap());
  }

  @override
  Future<void> deletePet(Pet pet) {
    final path = apiPath.userPetPath(uid!, pet.databaseID);
    return deleteDoc(path);
  }

  @override
  Stream<List<Species>> speciesStream() {
    final path = apiPath.userSpeciesList(uid!);
    return _collectionStream(path, (data, id) => Species.fromMap(id, data));
  }

  @override
  Future<Species> speciesFuture(String speciesID) async {
    final path = apiPath.userSpeciesPath(uid!, speciesID);
    DocumentReference<Map<String, dynamic>> doc = _firebase.doc(path);
    var speciesData = await doc.get();
    return Species.fromMap(speciesID, speciesData.data()!);
  }

  @override
  Future<void> addSpecies(Species species) {
    final path = apiPath.userSpeciesList(uid!);
    return addDoc(path, species.toMap());
  }

  @override
  Future<void> updateSpecies(Species species) {
    if (species.speciesID == null || species.speciesID == '') {
      return addSpecies(species);
    } else {
      final path = apiPath.userSpeciesPath(uid!, species.speciesID!);
      return updateDoc(path, species.toMap());
    }
  }

  @override
  Future<void> deleteSpecies(Species species) {
    final path = apiPath.userSpeciesPath(uid!, species.speciesID!);
    return deleteDoc(path);
  }

  @override
  Future<Feed> feederFuture(String feedID) async {
    final path = apiPath.userFeederPath(uid!, feedID);
    DocumentReference<Map<String, dynamic>> doc = _firebase.doc(path);
    var feedData = await doc.get();
    return Feed.fromMap(feedID, feedData.data()!);
  }

  @override
  Stream<List<Feed>> feederStream() {
    final path = apiPath.userFeederList(uid!);
    return _collectionStream(path, (data, id) => Feed.fromMap(id, data));
  }

  @override
  Future<void> addFeeder(Feed feed) {
    final path = apiPath.userFeederList(uid!);
    return addDoc(path, feed.toMap());
  }

  @override
  Future<void> updateFeeder(Feed feed) {
    if (feed.feedID == null || feed.feedID == '') {
      return addFeeder(feed);
    } else {
      final path = apiPath.userFeederPath(uid!, feed.feedID!);
      return updateDoc(path, feed.toMap());
    }
  }

  @override
  Future<void> deleteFeeder(Feed feed) {
    final path = apiPath.userFeederPath(uid!, feed.feedID!);
    return deleteDoc(path);
  }

  @override
  Future<Colony> colonyFuture(String colonyID) async {
    final path = apiPath.userColonyPath(uid!, colonyID);
    DocumentReference<Map<String, dynamic>> doc = _firebase.doc(path);
    var colonyData = await doc.get();
    //TODO filter pet that has the colony ID from cloud function
    //TODO use rx.combineLatest to put pet list in colony
    return Colony.fromMap(colonyID, colonyData.data()!);
  }

  @override
  Stream<List<Colony>> colonyStream() {
    final path = apiPath.userColonyList(uid!);
    //TODO filter pet that has the colony ID from cloud function
    //TODO use rx.combineLatest to put pet list in colony
    return _collectionStream(path, (data, id) => Colony.fromMap(id, data));
  }

  @override
  Future<void> addColony(Colony colony) {
    //TODO cloud function update petID to petIDList in colony when save pet
    final path = apiPath.userColonyList(uid!);
    return addDoc(path, colony.toMap());
  }

  @override
  Future<void> updateColony(Colony colony) {
    if (colony.databaseID == null || colony.databaseID == '') {
      return addColony(colony);
    } else {
      final path = apiPath.userColonyPath(uid!, colony.databaseID!);
      return updateDoc(path, colony.toMap());
    }
  }

  @override
  Future<void> deleteColony(Colony colony) {
    final path = apiPath.userColonyPath(uid!, colony.databaseID!);
    return deleteDoc(path);
  }

  @override
  Future<void> logActivity(Activity activity) {
    final path = apiPath.userActivityList(uid!);
    print(activity.toMap());
    return addDoc(path, activity.toMap());
  }

  Future<void> addDoc(String path, Map<String, dynamic> data) {
    CollectionReference ref = _firebase.collection(path);
    return ref.add(data);
  }

  Future<void> updateDoc(String path, Map<String, dynamic> data) {
    DocumentReference doc = _firebase.doc(path);
    return doc.set(data);
  }

  Future<void> deleteDoc(String path) {
    return _firebase.doc(path).delete();
  }

  Stream<List<T>> _collectionStream<T>(
    String path,
    T Function(Map<String, dynamic> data, String id) builder,
  ) {
    final reference = _firebase.collection(path);
    final snapshots = reference.snapshots();

    return snapshots.map((snapshot) => snapshot.docs
        .map((snapshot) => builder(snapshot.data(), snapshot.id))
        .toList());
  }
}
