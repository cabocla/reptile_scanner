import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:reptile_scanner/models/activity/activity.dart';
import 'package:reptile_scanner/models/colony.dart';
import 'package:reptile_scanner/models/feeder.dart';
import 'package:reptile_scanner/models/pet.dart';
import 'package:reptile_scanner/models/species.dart';
import 'package:reptile_scanner/models/user_data.dart';
import 'package:reptile_scanner/pages/edit_feeder_page.dart';
import 'package:reptile_scanner/pages/edit_species_page.dart';
import 'package:reptile_scanner/pages/qr_scan_screen.dart';
import 'package:reptile_scanner/services/database.dart';
import 'package:reptile_scanner/services/edit_feeder_bloc.dart';
import 'package:reptile_scanner/services/edit_pet_bloc.dart';
import 'package:reptile_scanner/services/edit_species_bloc.dart';
import 'package:reptile_scanner/services/log_activity_bloc.dart';
import 'package:reptile_scanner/widgets/qr_icon_button.dart';

class EditPetForm extends StatefulWidget {
  const EditPetForm({
    Key? key,
  }) : super(key: key);

  @override
  State<EditPetForm> createState() => _EditPetFormState();
}

class _EditPetFormState extends State<EditPetForm> {
  late Database database;
  late Stream<List<Species>> speciesStream;
  late Stream<List<Feed>> feederStream;
  late Stream<List<Pet>> parentStream;
  late Stream<List<Colony>> colonyStream;
  @override
  void initState() {
    database = Provider.of<Database>(context, listen: false);
    speciesStream = database.speciesStream();
    feederStream = database.feederStream();
    parentStream = database.myPetsStream();
    colonyStream = database.colonyStream();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    EditPetBloc bloc = Provider.of<EditPetBloc>(context, listen: false);
    UserData userData = Provider.of<UserData>(context, listen: false);
    return ListView(
      children: [
        const ListTile(
          title: Text('Pet information'),
        ),
        ListTile(
          title: TextFormField(
            initialValue: bloc.petName,
            decoration: InputDecoration(
              labelText: 'Pet Name',
              hintText: 'ex: Medusa or BP-01',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            onChanged: (text) {
              bloc.petName = text;
            },
          ),
        ),
        ListTile(
          leading: const Text('Species'),
          title: StreamBuilder<List<Species>>(
            stream: speciesStream,
            builder: (context, snapshot) {
              List<Species> speciesList = [];
              if (snapshot.hasData) {
                speciesList = snapshot.data!;
                // speciesList.addAll(speciesLibrary);
                return DropdownButton<Species>(
                    value: speciesList.firstWhereOrNull(
                        (element) => element.speciesID == bloc.speciesID),
                    items: speciesList
                        .map((e) => DropdownMenuItem(
                              child: Text(e.commonName),
                              value: e,
                            ))
                        .toList(),
                    onChanged: (species) {
                      if (species != null) {
                        bloc.speciesID = species.speciesID;
                      }
                      setState(() {});
                    });
              }
              return Container();
            },
          ),
          trailing: TextButton(
            child: const Text('+ add new'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Provider(
                    create: (context) => EditSpeciesBloc(
                      database: Provider.of<Database>(context, listen: false),
                    ),
                    child: const EditSpeciesPage(),
                  ),
                ),
              );
            },
          ),
        ),
        ListTile(
          title: TextFormField(
            initialValue: bloc.genetic,
            decoration: InputDecoration(
              labelText: 'Genetics',
              hintText: 'ex: Albino',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            onChanged: (text) {
              bloc.genetic = text;
            },
          ),

          // title: TextFieldTags(inputfieldBuilder: (context, tec, fn, error, onChanged, onSubmitted) {
          // },),
        ),
        ListTile(
          leading: const Text('Sex'),
          title: Wrap(
            children: Sex.values
                .map((e) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: _choiceChipSex(bloc, e),
                    ))
                .toList(),
          ),
        ),
        ListTile(
          leading: const Text('Date of birth'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                bloc.dateOfBirth == null
                    ? 'N/A'
                    : LogActivityBloc.dateTimeString(bloc.dateOfBirth!),
              ),
              const Icon(Icons.event),
            ],
          ),
          onTap: () async {
            bloc.dateOfBirth = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1945),
              lastDate: DateTime.now(),
            );
            setState(() {});
          },
        ),
        ListTile(
          leading: Tooltip(
              message: 'Measurement unit can be changed in Settings',
              child: Text('Pet weight (${userData.getWeightUnit})')),
          title: TextFormField(
            key: Key(bloc.weight.toString()),
            textAlign: TextAlign.center,
            initialValue: bloc.weight == null ? '0' : bloc.weight.toString(),
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: '"50"',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
            ],
            onChanged: (text) {
              bloc.weight = int.tryParse(text) ?? bloc.weight;
            },
          ),
        ),
        ListTile(
          leading: Tooltip(
              message: 'Measurement unit can be changed in Settings',
              child: Text('Pet length (${userData.getLengthUnit})')),
          title: TextFormField(
            key: Key(bloc.length.toString()),
            textAlign: TextAlign.center,
            initialValue: bloc.length == null ? '0' : bloc.length.toString(),
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: '"50"',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
            ],
            onChanged: (text) {
              bloc.length = int.tryParse(text) ?? bloc.length;
            },
          ),
        ),
        ListTile(
          leading: const Text('Colony'),
          title: StreamBuilder<List<Colony>>(
            stream: colonyStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Colony> colonyList = snapshot.data!;
                // feederList.addAll(feederLibrary);
                return DropdownButton<Colony>(
                    value: colonyList.firstWhereOrNull(
                        (element) => element.databaseID == bloc.colonyID),
                    items: colonyList
                        .map((e) => DropdownMenuItem(
                              child: Text(e.colonyName),
                              value: e,
                            ))
                        .toList(),
                    onChanged: (colony) {
                      if (colony != null) {
                        bloc.colonyID = colony.databaseID;
                      }
                      setState(() {});
                    });
              }
              return Container();
            },
          ),
          trailing: QRIconButton(
            onPressed: () {
              //TODO scan colony to get colonyID
            },
          ),
        ),
        const Divider(thickness: 5),
        const ListTile(
          title: Text('Pet diet'),
        ),
        ListTile(
          leading: const Text('Feeder'),
          title: StreamBuilder<List<Feed>>(
            stream: feederStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Feed> feederList = snapshot.data!;
                // feederList.addAll(feederLibrary);
                return DropdownButton<Feed>(
                    value: feederList.firstWhereOrNull(
                        (element) => element.feedID == bloc.feedID),
                    items: feederList
                        .map((e) => DropdownMenuItem(
                              child: Text('${e.feedName} - ${e.size}'),
                              value: e,
                            ))
                        .toList(),
                    onChanged: (feed) {
                      if (feed != null) {
                        bloc.feedID = feed.feedID;
                      }
                      setState(() {});
                    });
              }
              return Container();
            },
          ),
          trailing: TextButton(
            child: const Text('+ add new'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Provider(
                    create: (context) => EditFeederBloc(
                      database: Provider.of<Database>(context, listen: false),
                    ),
                    child: const EditFeederPage(),
                  ),
                ),
              );
            },
          ),
        ),
        ListTile(
          leading: const Text('Feed amount'),
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: () {
                  if (bloc.feedAmount > 1) {
                    bloc.feedAmount--;
                    setState(() {});
                  }
                },
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.2,
                child: TextFormField(
                  key: Key(bloc.feedAmount.toString()),
                  textAlign: TextAlign.center,
                  initialValue: bloc.feedAmount.toString(),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: '1',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  onChanged: (text) {
                    bloc.feedAmount = int.tryParse(text) ?? bloc.feedAmount;
                  },
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  bloc.feedAmount++;
                  setState(() {});
                },
              ),
            ],
          ),
        ),
        ListTile(
          leading: const Text('Feed schedule'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Interval'),
              Switch(
                value: bloc.customSchedule,
                onChanged: (value) {
                  bloc.customSchedule = value;
                  setState(() {});
                },
              ),
              const Text('Custom days'),
            ],
          ),
        ),
        bloc.customSchedule
            ? ListTile(
                title: Wrap(
                  children: Activity.dayName
                      .map((e) => Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Switch(
                                  value: bloc.feedingDays.contains(e),
                                  onChanged: (value) {
                                    if (value) {
                                      bloc.feedingDays.add(e);
                                    } else {
                                      bloc.feedingDays.remove(e);
                                    }
                                    setState(() {});
                                  }),
                              Text(e),
                            ],
                          ))
                      .toList(),
                ),
              )
            : ListTile(
                leading: const Text('Feeding days interval'),
                title: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () {
                        if (bloc.feedingIntervalDays > 1) {
                          bloc.feedingIntervalDays--;
                          setState(() {});
                        }
                      },
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.2,
                      child: TextFormField(
                        key: Key(bloc.feedingIntervalDays.toString()),
                        textAlign: TextAlign.center,
                        initialValue: bloc.feedingIntervalDays.toString(),
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: '1',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        onChanged: (text) {
                          bloc.feedingIntervalDays =
                              int.tryParse(text) ?? bloc.feedingIntervalDays;
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        if (bloc.feedingIntervalDays < 7) {
                          bloc.feedingIntervalDays++;
                          setState(() {});
                        }
                      },
                    ),
                  ],
                ),
              ),
        const Divider(thickness: 5),
        ListTile(
          title: const Text('Pet source'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Produced'),
              Switch(
                  value: !bloc.selfProduced,
                  onChanged: (value) {
                    bloc.selfProduced = !value;
                    setState(() {});
                  }),
              const Text('Acquired'),
            ],
          ),
        ),
        bloc.selfProduced
            ? Container()
            : ListTile(
                leading: const Text('Acquired date'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      bloc.dateAcquired == null
                          ? 'N/A'
                          : LogActivityBloc.dateTimeString(bloc.dateAcquired!),
                    ),
                    const Icon(Icons.event),
                  ],
                ),
                onTap: () async {
                  bloc.dateAcquired = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1945),
                    lastDate: DateTime.now(),
                  );
                  setState(() {});
                },
              ),
        bloc.selfProduced
            ? Container()
            : ListTile(
                title: TextFormField(
                  key: Key(bloc.purchasePrice.toString()),
                  initialValue: bloc.purchasePrice != null
                      ? bloc.purchasePrice.toString()
                      : null,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Purchase price',
                    hintText: 'ex: 100.00',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onChanged: (text) {
                    bloc.purchasePrice =
                        double.tryParse(text.replaceAll(',', '.')) ??
                            bloc.purchasePrice;
                  },
                ),
                trailing: Tooltip(
                    message: 'You can change the currency in Settings',
                    child: Text(userData.currency)),
              ),
        bloc.selfProduced
            ? Container()
            : ListTile(
                title: TextFormField(
                  initialValue: bloc.breederInformation,
                  keyboardType: TextInputType.multiline,
                  maxLength: 140,
                  maxLines: 4,
                  onChanged: (text) {
                    bloc.breederInformation = text;
                  },
                  decoration: InputDecoration(
                    labelText: 'Breeder information',
                    hintText: 'ex: breeder name, address, contact, etc',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
        bloc.selfProduced
            ? Tooltip(
                message: 'Animal need to exist in your system.',
                child: ListTile(
                  //sire
                  leading: const Text('Sire'),
                  trailing: IconButton(
                    icon: const Icon(Icons.qr_code),
                    onPressed: () async {
                      //TODO get pet by scanning QR
                      // bloc.sireID = await showQRScanner();
                    },
                  ),
                  title: StreamBuilder<List<Pet>>(
                      stream:
                          parentStream, //TODO: only stream male pet of same species
                      builder: (context, snapshot) {
                        List<Pet> petList = [];
                        if (snapshot.hasData) {
                          petList = snapshot.data!;
                          return DropdownButton<Pet>(
                              value: petList.firstWhereOrNull((element) =>
                                  element.databaseID == bloc.sireID),
                              items: petList
                                  .map((e) => DropdownMenuItem(
                                        child: Text(e.petName),
                                        value: e,
                                      ))
                                  .toList(),
                              onChanged: (pet) {
                                if (pet != null) {
                                  bloc.sireID = pet.databaseID;
                                }
                                setState(() {});
                              });
                        }
                        return Container();
                      }),
                ),
              )
            : ListTile(
                leading: const Text('Sire'),
                title: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Sire genetics',
                    hintText: 'ex: Albino',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onChanged: (text) {
                    bloc.sireGenetics = text;
                  },
                ),
              ),
        bloc.selfProduced
            ? Tooltip(
                message: 'Animal need to exist in your system.',
                child: ListTile(
                    //dam
                    leading: const Text('Dam'),
                    trailing: IconButton(
                      icon: const Icon(Icons.qr_code),
                      onPressed: () async {
                        //TODO get pet by scanning QR
                        // bloc.damID = await showQRScanner();
                      },
                    ),
                    title: StreamBuilder<List<Pet>>(
                        stream:
                            parentStream, //TODO: only stream female pet of same species
                        builder: (context, snapshot) {
                          List<Pet> petList = [];
                          if (snapshot.hasData) {
                            petList = snapshot.data!;
                            return DropdownButton<Pet>(
                                value: petList.firstWhereOrNull((element) =>
                                    element.databaseID == bloc.damID),
                                items: petList
                                    .map((e) => DropdownMenuItem(
                                          child: Text(e.petName),
                                          value: e,
                                        ))
                                    .toList(),
                                onChanged: (pet) {
                                  if (pet != null) {
                                    bloc.damID = pet.databaseID;
                                  }
                                  setState(() {});
                                });
                          }
                          return Container();
                        })),
              )
            : ListTile(
                leading: const Text('Dam'),
                title: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Dam genetics',
                    hintText: 'ex: Albino',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onChanged: (text) {
                    bloc.damGenetics = text;
                  },
                ),
              ),
        const Divider(thickness: 5),
        const ListTile(
          title: Text('Misc'),
        ),
        ListTile(
          leading: const Text('Status'),
          title: DropdownButton<AnimalStatus>(
            value: bloc.status,
            items: AnimalStatus.values
                .map(
                  (e) => DropdownMenuItem(
                    value: e,
                    child: Text(statusLabel[e]!),
                  ),
                )
                .toList(),
            onChanged: (value) {
              if (value == AnimalStatus.archived) {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: const Text('Warning!'),
                          content: const Text(archivedWarningText),
                          actions: [
                            TextButton(
                              child: const Text('Cancel'),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            TextButton(
                              child: const Text('Okay'),
                              onPressed: () {
                                bloc.status = value ?? bloc.status;
                                Navigator.pop(context);
                                setState(() {});
                              },
                            ),
                          ],
                        ));
              } else {
                bloc.status = value ?? bloc.status;
                setState(() {});
              }
            },
          ),
        ),
        ListTile(
          title: TextFormField(
            initialValue: bloc.note,
            keyboardType: TextInputType.multiline,
            maxLength: 140,
            maxLines: 4,
            onChanged: (text) {
              bloc.note = text;
            },
            decoration: InputDecoration(
              labelText: 'Notes',
              hintText: 'Type here...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<String> showQRScanner(BuildContext context) async {
    // Pet pet = await Navigator.of(context).pushNamed(QRScanScreen.routeName);
    return '';
  }

  Map<Sex, String> sexLabel = {
    Sex.male: 'Male',
    Sex.female: 'Female',
    Sex.unknown: 'Unknown',
  };
  Map<AnimalStatus, String> statusLabel = {
    AnimalStatus.owned: 'Owned',
    AnimalStatus.forSale: 'For sale',
    AnimalStatus.sold: 'Sold',
    AnimalStatus.archived: 'Archived',
  };
  Widget _choiceChipSex(EditPetBloc bloc, Sex sex) {
    return ChoiceChip(
      label: Text(sexLabel[sex] ?? ''),
      selected: bloc.sex == sex,
      onSelected: (selected) {
        if (selected) {
          bloc.sex = sex;
          setState(() {});
        }
      },
    );
  }

  static const archivedWarningText =
      'Saving animal as Archived will prevent further edit/changes/activities for this animal. This animal will not be counted for subscription limit but the historical data will be available.';
}
