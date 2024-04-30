import 'package:reptile_scanner/models/activity/activity.dart';
import 'package:reptile_scanner/models/activity/breeding.dart';
import 'package:reptile_scanner/models/activity/feed_restock.dart';
import 'package:reptile_scanner/models/activity/feeding.dart';
import 'package:reptile_scanner/models/activity/health_check.dart';
import 'package:reptile_scanner/models/activity/measure.dart';
import 'package:reptile_scanner/models/activity/shedding.dart';

class ActivityRecord {
  final String? id;
  final Activity activity;
  final DateTime dateTime;
  final String? imagePath;

  ActivityRecord({
    this.id,
    required this.activity,
    required this.dateTime,
    this.imagePath,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = activity.toMap();
    map.addAll({
      'dateTime': dateTime.toIso8601String(),
      'imagePath': imagePath,
    });
    return map;
  }

  factory ActivityRecord.fromMap(String id, Map<String, dynamic> data) {
    String dateString = data['dateTime'];
    DateTime dateTime = DateTime.parse(dateString);
    Activity activity = Activity.fromMap(data);
    ActivityType activityType = ActivityType.values.firstWhere(
      (element) => element.toString() == data['type'],
      orElse: () => ActivityType.other,
    );
    if (activityType == ActivityType.feeding) {
      activity = Feeding.fromMap(data);
    } else if (activityType == ActivityType.feedRestock) {
      activity = FeedRestock.fromMap(data);
    } else if (activityType == ActivityType.breeding) {
      activity = Breeding.fromMap(data);
    } else if (activityType == ActivityType.measure) {
      activity = Measure.fromMap(data);
    } else if (activityType == ActivityType.healthCheck) {
      activity = HealthCheck.fromMap(data);
    } else if (activityType == ActivityType.shedding) {
      activity = Shedding.fromMap(data);
    }
    return ActivityRecord(
      activity: activity,
      dateTime: dateTime,
      imagePath: data['imagePath'],
    );
  }
}
