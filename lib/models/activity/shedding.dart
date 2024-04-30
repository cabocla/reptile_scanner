import 'package:reptile_scanner/models/activity/activity.dart';

enum ShedCondition {
  preShed,
  inShed,
  doneShed,
  badShed,
}

class Shedding extends Activity {
  static const activityTitle = 'Shedding';

  final ShedCondition shedCondition;
  final String petID;
  Shedding({
    required this.petID,
    required this.shedCondition,
    String? note,
  }) : super(
          activityType: ActivityType.shedding,
          title: Shedding.activityTitle,
          note: note,
        );

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = super.toMap();
    map.addAll({
      'shedCondition': shedCondition.toString(),
      'petID': petID,
    });
    return map;
  }

  factory Shedding.fromMap(Map<String, dynamic> data) {
    return Shedding(
      petID: data['petID'],
      shedCondition: ShedCondition.values.firstWhere(
        (element) => element == data['shedCondition'],
        orElse: () => ShedCondition.doneShed,
      ),
    );
  }

  static const Map<ShedCondition, String> shedString = {
    ShedCondition.preShed: 'Pre-shed',
    ShedCondition.inShed: 'In shed',
    ShedCondition.doneShed: 'Done shed',
    ShedCondition.badShed: 'Bad shed',
  };
}
