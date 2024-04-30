import 'package:reptile_scanner/models/activity/activity.dart';
import 'package:reptile_scanner/models/feeder.dart';

class FeedRestock extends Activity {
  static const activityTitle = 'Feed Restock';
  final Feed feed;
  final int quantity;

  FeedRestock({
    required this.feed,
    required this.quantity,
    String? note,
  }) : super(
          activityType: ActivityType.feedRestock,
          title: FeedRestock.activityTitle,
          note: note,
        );

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = super.toMap();
    map.addAll(feed.toMap());
    map.addAll({
      'feedID': feed.feedID,
      'quantity': quantity,
    });
    return map;
  }

  factory FeedRestock.fromMap(Map<String, dynamic> data) {
    Feed feed = Feed.fromMap(data['feedID'], data);
    return FeedRestock(
      feed: feed,
      quantity: data['quantity'],
      note: data['note'],
    );
  }
}
