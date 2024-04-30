import 'package:reptile_scanner/models/activity/activity.dart';
import 'package:reptile_scanner/models/feeder.dart';

class Feeding extends Activity {
  static const activityTitle = 'Feeding';
  final Feed feed;
  final int amount;
  final String petID;
  final bool refuseFeed;
  Feeding({
    ActivityType activityType = ActivityType.feeding,
    String? note,
    required this.feed,
    required this.petID,
    this.amount = 1,
    this.refuseFeed = false,
  }) : super(
          activityType: activityType,
          title: Feeding.activityTitle,
          note: note,
        );

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = super.toMap();
    map.addAll(feed.toMap());
    map.addAll({
      'petID': petID,
      'feedID': feed.feedID,
      'amount': amount,
      'refuseFeed': refuseFeed,
    });
    return map;
  }

  factory Feeding.fromMap(Map<String, dynamic> data) {
    Feed feed = Feed.fromMap(data['feedID'], data);
    return Feeding(
      feed: feed,
      petID: data['petID'],
      amount: data['amount'],
      refuseFeed: data['refuseFeed'],
      note: data['note'],
    );
  }
}
