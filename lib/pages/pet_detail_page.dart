import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reptile_scanner/models/feeder.dart';
import 'package:reptile_scanner/models/pet.dart';
import 'package:reptile_scanner/models/species.dart';
import 'package:reptile_scanner/pages/edit_pet_page.dart';
import 'package:reptile_scanner/pages/log_activity_page.dart';
import 'package:reptile_scanner/pages/qr_image_page.dart';
import 'package:reptile_scanner/services/database.dart';
import 'package:reptile_scanner/services/edit_pet_bloc.dart';
import 'package:reptile_scanner/services/log_activity_bloc.dart';

class PetDetailPage extends StatelessWidget {
  final Pet pet;
  const PetDetailPage({
    Key? key,
    required this.pet,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Database database = Provider.of<Database>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton<String>(
            itemBuilder: (context) {
              return <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'edit',
                  child: Text('Edit'),
                ),
                const PopupMenuItem<String>(
                  value: 'delete',
                  child: Text('Delete'),
                ),
              ];
            },
            onSelected: (value) {
              if (value == 'edit') {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Provider<EditPetBloc>(
                          create: (context) =>
                              EditPetBloc(database: database, oldPet: pet),
                          child: const EditPetPage()),
                    ));
              } else if (value == 'delete') {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: const Text('Are you sure?'),
                          content: const Text('Pet will be deleted'),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Cancel')),
                            TextButton(
                                onPressed: () {
                                  database.deletePet(pet);
                                  Navigator.popUntil(
                                      context, (route) => route.isFirst);
                                },
                                child: const Text('Yes')),
                          ],
                        ));
              }
            },
          ),
        ],
      ),
      body: _buildContent(context),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Provider<LogActivityBloc>(
                  create: (context) =>
                      LogActivityBloc(database: database, pet: pet),
                  child: const LogActivityPage(),
                ),
              ));
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    Database database = Provider.of<Database>(context, listen: false);
    double width = MediaQuery.of(context).size.width;
    return StreamBuilder<Pet>(
        stream: database.petStream(pet.databaseID),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Pet petData = snapshot.data!;
            return ListView(
              shrinkWrap: true,
              children: [
                SizedBox(
                  height: width,
                  width: width,
                  child: const Text('image place holder'),
                ),
                ListTile(
                  title: Text(petData.petName),
                  subtitle: FutureBuilder<Species>(
                      future: database.speciesFuture(petData.speciesID),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          Species species = snapshot.data!;
                          return Text(species.commonName);
                        }
                        return Container();
                      }),
                  trailing: IconButton(
                    icon: const Icon(Icons.qr_code),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QRImagePage(pet: petData),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  width: width,
                  height: 100,
                  padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                  child: Card(
                    elevation: 7,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        //dob, sex, hunger level
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Text('Sex'),
                            Icon(Icons.male),
                          ],
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('DOB'),
                            Text(
                              petData.dateOfBirth == null
                                  ? 'N/A'
                                  : petData
                                      .dateTimeString(petData.dateOfBirth!),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Text('Hunger'),
                            Icon(Icons.device_thermostat),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const ListTile(
                  title: Text('Pet information'),
                ),
                ListTile(
                  title: Column(
                    //detail information
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Genetics: ${petData.genetic}'),
                      FutureBuilder<Feed>(
                          future: database.feederFuture(petData.feedID),
                          builder: (context, snapshot) {
                            String feeder = '';
                            if (snapshot.hasData) {
                              Feed feedData = snapshot.data!;
                              feeder =
                                  '${feedData.feedName} - ${feedData.size}';
                            }
                            return Text('Diet: $feeder');
                          }),
                      Text('Weight: ${petData.weight}'),
                      Text('Length: ${petData.length}'),
                    ],
                  ),
                ),
                ListTile(
                  title: const Text('History'),
                  onTap: () {
                    //TODO history activity page
                  },
                ),
              ],
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Container();
        });
  }
}
