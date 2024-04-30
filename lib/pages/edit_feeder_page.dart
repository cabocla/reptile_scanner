import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:reptile_scanner/services/edit_feeder_bloc.dart';
import 'package:reptile_scanner/widgets/edit_feeder_form.dart';

class EditFeederPage extends StatelessWidget {
  const EditFeederPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    EditFeederBloc bloc = Provider.of<EditFeederBloc>(context, listen: false);
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
                bloc.saveFeeder();
                Navigator.pop(context);
              } else {
                Fluttertoast.showToast(
                  gravity: ToastGravity.TOP,
                  msg: message,
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
    return const EditFeederForm();
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
