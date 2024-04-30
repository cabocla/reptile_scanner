import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:reptile_scanner/models/user_data.dart';
import 'package:reptile_scanner/services/edit_feeder_bloc.dart';

class EditFeederForm extends StatefulWidget {
  const EditFeederForm({Key? key}) : super(key: key);

  @override
  State<EditFeederForm> createState() => _EditFeederFormState();
}

class _EditFeederFormState extends State<EditFeederForm> {
  @override
  Widget build(BuildContext context) {
    EditFeederBloc bloc = Provider.of<EditFeederBloc>(context, listen: false);
    UserData userData = Provider.of<UserData>(context, listen: false);
    double width = MediaQuery.of(context).size.width;
    double rowWidth = width / 2;
    return ListView(
      shrinkWrap: true,
      children: [
        const ListTile(
          title: Text('Feeder information'),
        ),
        ListTile(
          title: TextFormField(
            initialValue: bloc.feedName,
            decoration: InputDecoration(
              labelText: 'Feeder Name',
              hintText: 'ex: Mice',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            onChanged: (text) {
              bloc.feedName = text;
              bloc.dataChanged = true;
            },
          ),
        ),
        ListTile(
          title: TextFormField(
            initialValue: bloc.size,
            decoration: InputDecoration(
              labelText: 'Feeder Size',
              hintText: 'ex: Adult',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            onChanged: (text) {
              bloc.size = text;
              bloc.dataChanged = true;
            },
          ),
        ),
        ListTile(
          leading: Tooltip(
              message: 'Measurement unit can be changed in Settings',
              child: Text('Feed weight (${userData.getWeightUnit})')),
          trailing: SizedBox(
            width: rowWidth,
            child: Row(
              // mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    if (bloc.weight > 0) {
                      bloc.weight--;
                      bloc.dataChanged = true;
                      setState(() {});
                    }
                  },
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.2,
                  child: TextFormField(
                    key: Key(bloc.weight.toString()),
                    textAlign: TextAlign.center,
                    initialValue: bloc.weight.toString(),
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
                      bloc.dataChanged = true;
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    bloc.weight++;
                    bloc.dataChanged = true;
                    setState(() {});
                  },
                ),
              ],
            ),
          ),
        ),
        ListTile(
          leading: const Text('Quantity'),
          trailing: SizedBox(
            width: rowWidth,
            child: Row(
              // mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    if (bloc.amount > 0) {
                      bloc.amount--;
                      bloc.dataChanged = true;
                      setState(() {});
                    }
                  },
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.2,
                  child: TextFormField(
                    key: Key(bloc.amount.toString()),
                    textAlign: TextAlign.center,
                    initialValue: bloc.amount.toString(),
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
                      bloc.amount = int.tryParse(text) ?? bloc.amount;
                      bloc.dataChanged = true;
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    bloc.amount++;
                    bloc.dataChanged = true;
                    setState(() {});
                  },
                ),
              ],
            ),
          ),
        ),
        ListTile(
          leading: const Text('Cost per Item'),
          trailing: SizedBox(
            width: rowWidth,
            child: Row(
              // mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Opacity(
                  opacity: 0,
                  child: Text(userData.currency),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.2,
                  child: TextFormField(
                    key: Key(bloc.cost.toString()),
                    initialValue:
                        bloc.cost == null ? null : bloc.cost.toString(),
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: '"1.50"',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    onChanged: (text) {
                      bloc.cost = double.tryParse(text.replaceAll(',', '.')) ??
                          bloc.cost;
                      bloc.dataChanged = true;
                    },
                  ),
                ),
                Tooltip(
                    message: 'You can change the currency in Settings',
                    child: Text(userData.currency)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
