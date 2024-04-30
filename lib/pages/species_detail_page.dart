import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reptile_scanner/models/species.dart';
import 'package:reptile_scanner/pages/edit_species_page.dart';
import 'package:reptile_scanner/services/database.dart';
import 'package:reptile_scanner/services/edit_species_bloc.dart';

class SpeciesDetailPage extends StatelessWidget {
  final Species species;
  const SpeciesDetailPage({
    Key? key,
    required this.species,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Database database = Provider.of<Database>(context, listen: false);
    return Scaffold(
      appBar: AppBar(actions: [
        TextButton(
          child: const Text(
            'Edit',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
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
        ),
      ]),
    );
  }
}
