import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reptile_scanner/models/species.dart';
import 'package:reptile_scanner/services/edit_species_bloc.dart';

class EditSpeciesForm extends StatefulWidget {
  const EditSpeciesForm({Key? key}) : super(key: key);

  @override
  State<EditSpeciesForm> createState() => _EditSpeciesFormState();
}

class _EditSpeciesFormState extends State<EditSpeciesForm> {
  @override
  Widget build(BuildContext context) {
    EditSpeciesBloc bloc = Provider.of<EditSpeciesBloc>(context, listen: false);
    return ListView(
      shrinkWrap: true,
      children: [
        const ListTile(
          title: Text('Species information'),
        ),
        ListTile(
          title: TextFormField(
            initialValue: bloc.commonName,
            decoration: InputDecoration(
              hintText: 'Common Name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            onChanged: (text) {
              bloc.commonName = text;
              bloc.dataChanged = true;
            },
          ),
        ),
        ListTile(
          title: TextFormField(
            initialValue: bloc.scientificName,
            decoration: InputDecoration(
              hintText: 'Scientific Name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            onChanged: (text) {
              bloc.scientificName = text;
              bloc.dataChanged = true;
            },
          ),
        ),
        ListTile(
          leading: const Text('Animal type'),
          title: DropdownButton<AnimalType>(
            value: bloc.animalType,
            items: AnimalType.values
                .map((e) => DropdownMenuItem<AnimalType>(
                      child: Text(Species.animalTypeString[e]!),
                      value: e,
                    ))
                .toList(),
            onChanged: (item) {
              if (item != null) {
                bloc.animalType = item;
                setState(() {});
              }
              bloc.dataChanged = true;
            },
          ),
        ),
        ListTile(
          leading: const Text('Venom level'),
          title: DropdownButton<VenomLevel>(
            value: bloc.venom,
            items: VenomLevel.values
                .map((e) => DropdownMenuItem<VenomLevel>(
                      child: Text(Species.venomString[e]!),
                      value: e,
                    ))
                .toList(),
            onChanged: (item) {
              if (item != null) {
                bloc.venom = item;
                setState(() {});
              }
              bloc.dataChanged = true;
            },
          ),
        ),
      ],
    );
  }
}
