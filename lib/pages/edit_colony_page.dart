import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:reptile_scanner/models/pet.dart';
import 'package:reptile_scanner/services/edit_colony_bloc.dart';
import 'package:reptile_scanner/widgets/qr_icon_button.dart';

class EditColonyPage extends StatelessWidget {
  const EditColonyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    EditColonyBloc bloc = Provider.of<EditColonyBloc>(context, listen: false);
    return WillPopScope(
      onWillPop: () {
        if (bloc.dataChanged) {
          return _onWIllPop(context);
        } else {
          return Future.value(!bloc.dataChanged);
        }
      },
      child: Scaffold(
        appBar: AppBar(actions: [
          TextButton(
            child: const Text(
              'Save',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              String? msg = bloc.validateForm();
              if (msg == null) {
                bloc.saveColony();
              } else {
                Fluttertoast.showToast(
                  gravity: ToastGravity.TOP,
                  msg: msg,
                  backgroundColor: Colors.red,
                );
              }
            },
          ),
        ]),
        body: _buildContent(context),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    EditColonyBloc bloc = Provider.of<EditColonyBloc>(context, listen: false);
    return ListView(
      shrinkWrap: true,
      children: [
        const ListTile(
          title: Text('Colony information'),
        ),
        ListTile(
          title: TextFormField(
            initialValue: bloc.colonyName,
            decoration: InputDecoration(
              labelText: 'Colony Name',
              hintText: 'ex: Rack-01',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            onChanged: (text) {
              bloc.colonyName = text;
              bloc.dataChanged = true;
            },
          ),
        ),
        ListTile(
          title: const Text('Pet list'),
          trailing: QRIconButton(
            onPressed: () {
              bloc.dataChanged = true;
            },
          ),
        ),
        ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: bloc.petList.length,
            itemBuilder: (context, index) {
              Pet pet = bloc.petList[index];
              return ListTile(
                leading: const CircleAvatar(),
                title: Text(pet.petName),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    bloc.dataChanged = true;
                  },
                ),
              );
            }),
      ],
    );
  }

  Future<bool> _onWIllPop(BuildContext context) async {
    bool? pop = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Left without saving?'),
              content: const Text('Changes will be discarded'),
              actions: [
                TextButton(
                  child: const Text('Discard'),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                ),
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
              ],
            ));
    return pop ?? false;
  }
}
