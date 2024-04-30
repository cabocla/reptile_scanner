class APIPath {
  String get userDataList {
    return 'users';
  }

  String userDataPath(String uid) {
    return 'users/$uid';
  }

  String userPetList(String uid) {
    return 'users/$uid/pets/';
  }

  String userPetPath(String uid, String petID) {
    return 'users/$uid/pets/$petID';
  }

  String userSpeciesList(String uid) {
    return 'users/$uid/species/';
  }

  String userSpeciesPath(String uid, String speciesID) {
    return 'users/$uid/species/$speciesID';
  }

  String userGeneticList(String uid, String speciesID) {
    return 'users/$uid/species/$speciesID/genes/';
  }

  String userGeneticPath(String uid, String speciesId, String geneID) {
    return 'users/$uid/species/$speciesId/genes/$geneID';
  }

  String userFeederList(String uid) {
    return 'users/$uid/feeder/';
  }

  String userFeederPath(String uid, String feederID) {
    return 'users/$uid/feeder/$feederID';
  }

  String userColonyList(String uid) {
    return 'users/$uid/colony/';
  }

  String userColonyPath(String uid, String colonyID) {
    return 'users/$uid/colony/$colonyID';
  }

  String userActivityList(String uid) {
    return 'users/$uid/activity/';
  }

  String userActivityPath(String uid, String activityID) {
    return 'users/$uid/activity/$activityID';
  }
}
