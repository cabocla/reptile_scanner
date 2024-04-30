import 'package:flutter/material.dart';
import 'package:reptile_scanner/models/breeding_plan.dart';
import 'package:reptile_scanner/models/clutch.dart';
import 'package:reptile_scanner/models/colony.dart';
import 'package:reptile_scanner/models/feeder.dart';
import 'package:reptile_scanner/models/pet.dart';

class QRImagePage extends StatelessWidget {
  final Pet? pet;
  final Feed? feeder;
  final Colony? colony;
  final Clutch? clutch;
  final BreedingPlan? breedingPlan;

  const QRImagePage({
    Key? key,
    this.pet,
    this.feeder,
    this.colony,
    this.clutch,
    this.breedingPlan,
  })  : assert(
          (feeder == null &&
                  colony == null &&
                  clutch == null &&
                  breedingPlan == null) ||
              (pet == null &&
                  colony == null &&
                  clutch == null &&
                  breedingPlan == null) ||
              (pet == null &&
                  feeder == null &&
                  clutch == null &&
                  breedingPlan == null) ||
              (pet == null &&
                  feeder == null &&
                  colony == null &&
                  breedingPlan == null) ||
              (pet == null &&
                  feeder == null &&
                  clutch == null &&
                  colony == null),
          'Can only take 1 parameter',
        ),
        assert(
          pet != null ||
              feeder != null ||
              colony != null ||
              clutch != null ||
              breedingPlan != null,
          'Require at least 1 parameter',
        ),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    //TODO generate QR image
    return Container();
  }
}
