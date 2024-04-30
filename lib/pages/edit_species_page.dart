import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:reptile_scanner/services/edit_species_bloc.dart';
import 'package:reptile_scanner/widgets/edit_species_form.dart';

class EditSpeciesPage extends StatelessWidget {
  const EditSpeciesPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    EditSpeciesBloc bloc = Provider.of<EditSpeciesBloc>(context, listen: false);
    bloc.initState();
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
              String? message = bloc.validateForm();
              if (message == null) {
                bloc.saveSpecies();
                Navigator.pop(context);
              } else {
                Fluttertoast.showToast(
                  msg: message,
                  backgroundColor: Colors.red,
                  gravity: ToastGravity.TOP,
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
    return const EditSpeciesForm();
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
