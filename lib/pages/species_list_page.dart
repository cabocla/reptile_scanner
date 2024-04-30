import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reptile_scanner/models/species.dart';
import 'package:reptile_scanner/models/species_library.dart';
import 'package:reptile_scanner/pages/edit_species_page.dart';
import 'package:reptile_scanner/services/database.dart';
import 'package:reptile_scanner/services/edit_species_bloc.dart';

class SpeciesListPage extends StatelessWidget {
  static const routeName = '/species-list';
  const SpeciesListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Database database = Provider.of<Database>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            child: const Text(
              '+ New Species',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Provider(
                      create: (context) => EditSpeciesBloc(database: database),
                      child: const EditSpeciesPage()),
                ),
              );
            },
          ),
        ],
      ),
      body: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    Database database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<Species>>(
        stream: database.speciesStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Species> speciesList = snapshot.data!;
            speciesList.addAll(speciesLibrary);
            return ListView.builder(
              itemCount: speciesList.length,
              itemBuilder: (context, index) {
                Species species = speciesList[index];
                return ListTile(
                  title: Text(species.commonName),
                  subtitle: Text(species.scientificName),
                  // trailing: TextButton(
                  //   child: const Text('Genetics'),
                  //   onPressed: () {
                  //     showDialog(
                  //         context: context,
                  //         builder: (context) => AlertDialog(
                  //               title: const Text('Add Genetics'),
                  //               content: SizedBox(
                  //                 height: double.maxFinite,
                  //                 width: double.maxFinite,
                  //                 child: ListView(
                  //                   shrinkWrap: true,
                  //                   children: [
                  //                     ListTile(),
                  //                   ],
                  //                 ),
                  //               ),
                  //               actions: [
                  //                 TextButton(
                  //                   child: const Text('Close'),
                  //                   onPressed: () {},
                  //                 ),
                  //                 TextButton(
                  //                   child: const Text('Save'),
                  //                   onPressed: () {},
                  //                 ),
                  //               ],
                  //             ));
                  //   },
                  // ),

                  // onTap: () {
                  //   Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //         builder: (context) =>
                  //             SpeciesDetailPage(species: species),
                  //       ));
                  // },
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Provider(
                            create: (context) => EditSpeciesBloc(
                              oldSpecies: species,
                              database: database,
                            ),
                            child: const EditSpeciesPage(),
                          ),
                        ));
                  },
                );
              },
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          } else {
            return const Center(
              child: Text('No species yet, add some'),
            );
          }
        });
  }
}
