import 'package:reptile_scanner/models/activity/activity.dart';

class HealthCheck extends Activity {
  static const activityTitle = 'Health Check';
  final String petID;
  final String? veterinarian;
  final String? medicineName;
  final String? medicineDose;
  HealthCheck({
    required this.petID,
    this.veterinarian,
    this.medicineName,
    this.medicineDose,
    String? note,
  }) : super(
          activityType: ActivityType.healthCheck,
          title: HealthCheck.activityTitle,
          note: note,
        );

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = super.toMap();
    map.addAll({
      'petID': petID,
      'veterinarian': veterinarian,
      'medicine': medicineName,
      'doses': medicineDose,
    });
    return map;
  }

  factory HealthCheck.fromMap(Map<String, dynamic> data) {
    return HealthCheck(
      petID: data['petID'],
      veterinarian: data['veterinarian'],
      medicineName: data['medicine'],
      medicineDose: data['doses'],
      note: data['note'],
    );
  }
}
