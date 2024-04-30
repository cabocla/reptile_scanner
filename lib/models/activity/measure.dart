import 'package:reptile_scanner/models/activity/activity.dart';

class Measure extends Activity {
  static const activityTitle = 'Measure';
  final String petID;
  final int? weight;
  final int? length;
  Measure({
    required this.petID,
    this.length,
    this.weight,
    String? note,
  })  : assert(weight != null || length != null,
            'Required at least 1 data parameter'),
        super(
          activityType: ActivityType.measure,
          title: Measure.activityTitle,
          note: note,
        );

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = super.toMap();
    map.addAll({
      'petID': petID,
      'weight': weight,
      'length': length,
    });
    return map;
  }

  factory Measure.fromMap(Map<String, dynamic> data) {
    return Measure(
      petID: data['petID'],
      weight: data['weight'],
      length: data['length'],
      note: data['note'],
    );
  }
}
