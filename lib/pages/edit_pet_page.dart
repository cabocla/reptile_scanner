import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:reptile_scanner/services/edit_pet_bloc.dart';
import 'package:reptile_scanner/widgets/edit_pet_form.dart';

class EditPetPage extends StatelessWidget {
  const EditPetPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    EditPetBloc bloc = Provider.of<EditPetBloc>(context, listen: false);
    bloc.initState();

    return WillPopScope(
      onWillPop: () => _onWIllPop(context),
      child: Scaffold(
        appBar: AppBar(actions: [
          TextButton(
            child: const Text(
              'Save',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onPressed: () {
              String? msg = bloc.validateForm();
              if (msg == null) {
                bloc.savePet();
                Navigator.pop(context);
              } else {
                Fluttertoast.showToast(
                  msg: msg,
                  gravity: ToastGravity.TOP,
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
    return const EditPetForm();
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
