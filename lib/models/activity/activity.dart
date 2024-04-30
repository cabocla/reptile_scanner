import 'package:reptile_scanner/models/activity/breeding.dart';
import 'package:reptile_scanner/models/activity/feed_restock.dart';
import 'package:reptile_scanner/models/activity/feeding.dart';
import 'package:reptile_scanner/models/activity/health_check.dart';
import 'package:reptile_scanner/models/activity/measure.dart';
import 'package:reptile_scanner/models/activity/shedding.dart';

enum ActivityType {
  feeding,
  regurgitate,
  // supplement,
  shedding,
  healthCheck,
  measure,
  brumating,
  defecation,
  cleaning,
  // grooming,
  breeding,
  hatching,
  feedRestock,
  other,
}

class Activity {
  //tambah input data buat weight, ovulating, breeding, suplement, dll
  final ActivityType activityType;
  final String title;
  final String? note;

  Activity({
    required this.activityType,
    required this.title,
    this.note,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'type': activityType.toString(),
      'note': note,
    };
  }

  factory Activity.fromMap(Map<String, dynamic> data) {
    ActivityType type = ActivityType.values.firstWhere(
      (element) => element.toString() == data['type'],
      orElse: () => ActivityType.other,
    );
    return Activity(
      activityType: type,
      title: data['title'],
      note: data['note'],
    );
  }

  static const Map<ActivityType, String> titleByActivityType = {
    ActivityType.feeding: Feeding.activityTitle,
    ActivityType.regurgitate: 'Regurgitate',
    ActivityType.shedding: Shedding.activityTitle,
    ActivityType.healthCheck: HealthCheck.activityTitle,
    ActivityType.measure: Measure.activityTitle,
    ActivityType.brumating: 'Brumating',
    ActivityType.defecation: 'Defacate',
    ActivityType.cleaning: 'Cleaning',
    ActivityType.breeding: Breeding.activityTitle,
    ActivityType.hatching: 'Hatching',
    ActivityType.feedRestock: FeedRestock.activityTitle,
  };

  static const List<String> dayName = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];
}
