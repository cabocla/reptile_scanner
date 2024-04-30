import 'package:reptile_scanner/models/activity/activity.dart';
import 'package:reptile_scanner/models/breeding_plan.dart';

enum BreedingPhase {
  spermPlug,
  copulation,
  ovulation,
  follicles,
  prelayShed,
  deliver,
  other,
}

class Breeding extends Activity {
  static const activityTitle = 'Breeding';
  final BreedingPlan breedingPlan;
  final BreedingPhase breedingPhase;
  Breeding({
    required this.breedingPlan,
    required this.breedingPhase,
    String? note,
  }) : super(
          activityType: ActivityType.breeding,
          title: Breeding.activityTitle,
          note: note,
        );

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = super.toMap();
    map.addAll(breedingPlan.toMap());
    map.addAll({
      'breedingID': breedingPlan.breedingID,
      'breedingPhase': breedingPhase.toString(),
    });
    return map;
  }

  factory Breeding.fromMap(Map<String, dynamic> data) {
    BreedingPlan breedingPlan = BreedingPlan.fromMap(data['breedingID'], data);
    BreedingPhase phase = BreedingPhase.values.firstWhere(
      (element) => element == data['breedingPhase'],
      orElse: () => BreedingPhase.other,
    );
    return Breeding(
      breedingPhase: phase,
      breedingPlan: breedingPlan,
      note: data['note'],
    );
  }
}
