import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reptile_scanner/services/log_activity_bloc.dart';
import 'package:reptile_scanner/widgets/clutch_activity_form.dart';
import 'package:reptile_scanner/widgets/colony_activity_form.dart';
import 'package:reptile_scanner/widgets/feeder_activity_form.dart';
import 'package:reptile_scanner/widgets/pet_activity_form.dart';

class LogActivityPage extends StatelessWidget {
  const LogActivityPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LogActivityBloc bloc = Provider.of<LogActivityBloc>(context, listen: false);
    bloc.initState();
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: AppBar(),
      body: _buildContent(context),
      floatingActionButton: FloatingActionButton(
        child: const Text('Log activity'),
        onPressed: () {
          bloc.saveActivity();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildContent(BuildContext context) {
    LogActivityBloc bloc = Provider.of<LogActivityBloc>(context, listen: false);
    if (bloc.pet != null) {
      return const PetActivityForm();
    } else if (bloc.colony != null) {
      return const ColonyActivityForm();
    } else if (bloc.feeder != null) {
      return const FeederActivityForm();
    } else if (bloc.clutch != null) {
      return const ClutchActivityForm();
    } else {
      return const Center(
        child: Text('Something went wrong, please try again'),
      );
    }
  }
}
