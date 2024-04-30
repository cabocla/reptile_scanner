import 'package:chips_choice_null_safety/chips_choice_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:reptile_scanner/models/activity/activity.dart';
import 'package:reptile_scanner/models/activity/shedding.dart';
import 'package:reptile_scanner/models/feeder.dart';
import 'package:reptile_scanner/models/pet.dart';
import 'package:reptile_scanner/models/user_data.dart';
import 'package:reptile_scanner/pages/pet_detail_page.dart';
import 'package:reptile_scanner/services/database.dart';
import 'package:reptile_scanner/services/log_activity_bloc.dart';

class PetActivityForm extends StatefulWidget {
  const PetActivityForm({Key? key}) : super(key: key);

  @override
  State<PetActivityForm> createState() => _PetActivityFormState();
}

class _PetActivityFormState extends State<PetActivityForm> {
  late Stream<List<Feed>> feedStream;
  late Database database;
  final Map<ActivityType, String> activityTypeList = {
    ActivityType.feeding: 'Feeding',
    ActivityType.shedding: 'Shedding',
    ActivityType.healthCheck: 'Health',
    ActivityType.measure: 'Measure',
    // ActivityType.brumating: 'Brumation',
    ActivityType.defecation: 'Defecate',
    // ActivityType.regurgitate: 'Regurgitate',
    ActivityType.cleaning: 'Cleaning',
    ActivityType.other: 'Other',
  };
  @override
  void initState() {
    database = Provider.of<Database>(context, listen: false);
    feedStream = database.feederStream();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    LogActivityBloc bloc = Provider.of<LogActivityBloc>(context, listen: false);
    Pet pet = bloc.pet!;
    return ListView(
      children: [
        ListTile(
          leading: const CircleAvatar(), //TODO change to imagecircleavatar
          title: Text(pet.petName),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PetDetailPage(
                  pet: pet,
                ),
              ),
            );
          },
        ),
        ChipsChoice<ActivityType>.single(
          wrapped: true,
          value: bloc.activityType,
          onChanged: (value) {
            bloc.activityType = value;
            setState(() {});
          },
          choiceItems: C2Choice.listFrom(
            source: activityTypeList.keys.toList(),
            value: (i, value) {
              return activityTypeList.keys.toList()[i];
            },
            label: (i, value) => activityTypeList[value]!,
            style: (i, type) => const C2ChoiceStyle(
              color: Colors.grey,
              showCheckmark: false,
            ),
            activeStyle: (i, type) => const C2ChoiceStyle(
              color: Colors.grey,
              showCheckmark: false,
            ),
          ),
          choiceStyle: const C2ChoiceStyle(
            color: Colors.grey,
            showCheckmark: false,
          ),
        ),
        _activityForm(context),
        // ExpansionPanelList(
        //   children: [
        //     ExpansionPanel(
        //       isExpanded: bloc.activityType == ActivityType.feeding,
        //       headerBuilder: (context, isOpen) {
        //         return const Padding(
        //           padding: EdgeInsets.all(20),
        //           child: Text('Feeding'),
        //         );
        //       },
        //       body: ListView(
        //         shrinkWrap: true,
        //         physics: const NeverScrollableScrollPhysics(),
        //         children: [
        //           ListTile(
        //             leading: const Text('Feeder'),
        //             title: TextFormField(),
        //           ),
        //           ListTile(
        //             leading: const Text('Amount'),
        //             title: TextFormField(),
        //           ),
        //           ListTile(
        //             leading: const Text('Date'),
        //             title: TextFormField(),
        //           ),
        //           ListTile(
        //             leading: const Text('Refuse feed'),
        //             title: TextFormField(),
        //           ),
        //           ListTile(
        //             leading: const Text('Note'),
        //             title: TextFormField(),
        //           ),
        //         ],
        //       ),
        //     ),
        //     ExpansionPanel(
        //       isExpanded: bloc.activityType == ActivityType.shedding,
        //       headerBuilder: (context, isOpen) {
        //         return const Padding(
        //           padding: EdgeInsets.all(20),
        //           child: Text('Shedding'),
        //         );
        //       },
        //       body: _activityForm(),
        //     ),
        //     ExpansionPanel(
        //       isExpanded: bloc.activityType == ActivityType.healthCheck,
        //       headerBuilder: (context, isOpen) {
        //         return const Padding(
        //           padding: EdgeInsets.all(20),
        //           child: Text('Health check'),
        //         );
        //       },
        //       body: _activityForm(),
        //     ),
        //     ExpansionPanel(
        //       isExpanded: bloc.activityType == ActivityType.measure,
        //       headerBuilder: (context, isOpen) {
        //         return const Padding(
        //           padding: EdgeInsets.all(20),
        //           child: Text('Measure'),
        //         );
        //       },
        //       body: _activityForm(),
        //     ),
        //     ExpansionPanel(
        //       isExpanded: bloc.activityType == ActivityType.cleaning,
        //       headerBuilder: (context, isOpen) {
        //         return const Padding(
        //           padding: EdgeInsets.all(20),
        //           child: Text('Cleaning'),
        //         );
        //       },
        //       body: _activityForm(),
        //     ),
        //     ExpansionPanel(
        //       isExpanded: bloc.activityType == ActivityType.other,
        //       headerBuilder: (context, isOpen) {
        //         return const Padding(
        //           padding: EdgeInsets.all(20),
        //           child: Text('Other'),
        //         );
        //       },
        //       body: _activityForm(),
        //     ),
        //   ],
        //   expansionCallback: (index, isOpen) {
        //     bloc.activityType = activityTypeList.keys.toList()[index];
        //     print(bloc.activityType.toString());
        //     setState(() {});
        //   },
        // ),
      ],
    );
  }

  Widget _activityForm(BuildContext context) {
    LogActivityBloc bloc = Provider.of<LogActivityBloc>(context, listen: false);

    return ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          ..._listviewChildren(context),
          ListTile(
            leading: const Text('Date'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(LogActivityBloc.dateTimeString(bloc.dateTime)),
                const Icon(Icons.event),
              ],
            ),
            onTap: () async {
              bloc.dateTime = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1945),
                    lastDate: DateTime.now(),
                  ) ??
                  DateTime.now();
              setState(() {});
            },
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
        ]);
  }

  List<Widget> _listviewChildren(BuildContext context) {
    LogActivityBloc bloc = Provider.of<LogActivityBloc>(context, listen: false);
    UserData userData = Provider.of<UserData>(context, listen: false);
    ActivityType type = bloc.activityType;
    if (type == ActivityType.feeding) {
      return [
        ListTile(
          leading: const Text('Feeder'),
          title: StreamBuilder<List<Feed>>(
              stream: feedStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Feed> feedList = snapshot.data!;
                  bloc.feedItem = feedList.firstWhere(
                    (element) => element.feedID == bloc.pet!.feedID,
                    orElse: () => feedList[0],
                  );
                  return DropdownButton<Feed>(
                      value: bloc.feedItem,
                      items: feedList
                          .map(
                            (e) => DropdownMenuItem<Feed>(
                              value: e,
                              child: Text('${e.feedName} - ${e.size}'),
                            ),
                          )
                          .toList(),
                      onChanged: (feed) {
                        bloc.feedItem = feed;
                        bloc.feedCostPerItem = feed!.cost * bloc.feedAmount;
                        setState(() {});
                      });
                }
                return const CircularProgressIndicator();
              }),
        ),
        ListTile(
          leading: const Text('Amount'),
          title: Row(
            // mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: () {
                  if (bloc.feedAmount > 0) {
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
                    hintText: '"1"',
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
          title: TextFormField(
            key: Key(bloc.feedCostPerItem.toString()),
            initialValue: bloc.feedCostPerItem.toString(),
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Cost per feed item',
              hintText: 'ex: 10.00',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            onChanged: (text) {
              bloc.feedCostPerItem =
                  double.tryParse(text.replaceAll(',', '.')) ??
                      bloc.feedCostPerItem;
            },
          ),
          trailing: Tooltip(
              message: 'You can change the currency in Settings',
              child: Text(userData.currency)),
        ),
        ListTile(
          leading: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Refuse feed'),
              Switch(
                  value: bloc.refuseFeed,
                  onChanged: (refuseFeed) {
                    bloc.refuseFeed = refuseFeed;
                    setState(() {});
                  }),
            ],
          ),
        ),
      ];
    } else if (type == ActivityType.healthCheck) {
      // String? veterinarian;
      // String? medicineName;
      // String? medicineDose;

      return [
        ListTile(
          title: TextFormField(
            initialValue: bloc.veterinarian,
            decoration: InputDecoration(
              labelText: 'Veterinarian',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            onChanged: (text) {
              bloc.veterinarian = text;
            },
          ),
        ),
        ListTile(
          title: TextFormField(
            initialValue: bloc.medicineName,
            decoration: InputDecoration(
              labelText: 'Medicine',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            onChanged: (text) {
              bloc.medicineName = text;
            },
          ),
        ),
        ListTile(
          title: TextFormField(
            initialValue: bloc.medicineDose,
            decoration: InputDecoration(
              labelText: 'Doses',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            onChanged: (text) {
              bloc.medicineDose = text;
            },
          ),
        ),
      ];
    } else if (type == ActivityType.measure) {
      return [
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
      ];
    } else if (type == ActivityType.shedding) {
      return [
        ListTile(
          leading: const Text('Shed condition'),
          title: DropdownButton<ShedCondition>(
            value: bloc.shedCondition,
            items: ShedCondition.values
                .map(
                  (e) => DropdownMenuItem<ShedCondition>(
                    value: e,
                    child: Text(
                      Shedding.shedString[e]!,
                    ),
                  ),
                )
                .toList(),
            onChanged: (condition) {
              bloc.shedCondition = condition ?? bloc.shedCondition;
              setState(() {});
            },
          ),
        ),
      ];
    } else {
      if (type == ActivityType.other) {
        return [
          ListTile(
            title: TextFormField(
              initialValue: bloc.title,
              decoration: InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onChanged: (text) {
                bloc.title = text;
              },
            ),
          ),
        ];
      }
      return [];
    }
  }
}
