import 'package:reptile_scanner/models/feeder.dart';
import 'package:reptile_scanner/services/database.dart';

class EditFeederBloc {
  final Feed? oldFeed;
  final Database database;

  EditFeederBloc({this.oldFeed, required this.database});

  String? feedID;
  String? feedName;
  String? size;
  int weight = 0; //gram
  int amount = 1;
  double? cost;
  String currency = 'USD';

  bool dataChanged = false;

  void initState() {
    if (oldFeed != null) {
      Feed feed = oldFeed!;
      feedID = feed.feedID;
      feedName = feed.feedName;
      weight = feed.weight;
      size = feed.size;
      cost = feed.cost;
      amount = feed.amount;
      currency = feed.currency;
    }
  }

  void saveFeeder() {
    Feed newFeed = Feed(
      feedID: feedID,
      feedName: feedName!,
      size: size!,
      weight: weight,
      amount: amount,
      cost: cost ?? 0.0,
      currency: currency,
    );
    if (oldFeed != null) {
      database.updateFeeder(newFeed);
    } else {
      database.addFeeder(newFeed);
    }
  }

  String? validateForm() {
    String? message;
    if (size == null || size!.trim() == '') {
      message = 'Size is required';
    }
    if (feedName == null || feedName!.trim() == '') {
      message = 'Feed name is required';
    }
    return message;
  }
}
