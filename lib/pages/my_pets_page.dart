import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reptile_scanner/models/pet.dart';
import 'package:reptile_scanner/models/species.dart';
import 'package:reptile_scanner/pages/edit_pet_page.dart';
import 'package:reptile_scanner/pages/error_screen.dart';
import 'package:reptile_scanner/pages/pet_detail_page.dart';
import 'package:reptile_scanner/services/database.dart';
import 'package:reptile_scanner/services/edit_pet_bloc.dart';
import 'package:reptile_scanner/widgets/app_drawer.dart';

class MyPetsPage extends StatelessWidget {
  static const routeName = '/my-pets';
  const MyPetsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(routeName: routeName),
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Provider(
                            create: (context) => EditPetBloc(
                              database:
                                  Provider.of<Database>(context, listen: false),
                            ),
                            child: const EditPetPage(),
                          )));
            },
          ),
        ],
      ),
      body: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    Database database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<Pet>>(
        stream: database.myPetsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              List<Pet> petList = snapshot.data!;
              return ListView.builder(
                itemCount: petList.length,
                itemBuilder: (context, index) {
                  Pet pet = petList[index];
                  return ListTile(
                    leading: const CircleAvatar(),
                    title: Text(pet.petName),
                    subtitle: FutureBuilder<Species>(
                        future: database.speciesFuture(pet.speciesID),
                        builder: (context, snapshot) {
                          String speciesName = '';
                          if (snapshot.hasData) {
                            Species species = snapshot.data!;
                            speciesName = species.commonName;
                          }
                          return Text(speciesName);
                        }),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PetDetailPage(pet: pet),
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Center(child: Text('No pet yet, add some'));
            }
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          return const ErrorScreen();
        });
  }
}
