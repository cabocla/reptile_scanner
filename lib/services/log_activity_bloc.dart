import 'package:intl/intl.dart';
import 'package:reptile_scanner/models/activity/activity.dart';
import 'package:reptile_scanner/models/activity/feeding.dart';
import 'package:reptile_scanner/models/activity/health_check.dart';
import 'package:reptile_scanner/models/activity/measure.dart';
import 'package:reptile_scanner/models/activity/shedding.dart';
import 'package:reptile_scanner/models/breeding_plan.dart';
import 'package:reptile_scanner/models/clutch.dart';
import 'package:reptile_scanner/models/colony.dart';
import 'package:reptile_scanner/models/feeder.dart';
import 'package:reptile_scanner/models/pet.dart';
import 'package:reptile_scanner/services/database.dart';

class LogActivityBloc {
  final Database database;
  final Pet? pet;
  final Feed? feeder;
  final Colony? colony;
  final Clutch? clutch;
  final BreedingPlan? breedingPlan;

  LogActivityBloc({
    required this.database,
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
        );

  late ActivityType activityType;

//Actvivity feeding
  Feed? feedItem;
  int feedAmount = 1;
  bool refuseFeed = false;
  double feedCostPerItem = 0;

//Activity health check
  String? veterinarian;
  String? medicineName;
  String? medicineDose;

//Activity measure
  int? weight;
  int? length;

  //Activity shedding
  ShedCondition shedCondition = ShedCondition.doneShed;

  String? title;
  DateTime dateTime = DateTime.now();
  String? note;

  void initState() {
    if (pet != null || colony != null) {
      activityType = ActivityType.feeding;
      if (pet != null) {
        Pet petData = pet!;
        feedAmount = petData.feedAmount;
      }
    } else if (feeder != null) {
      activityType = ActivityType.feedRestock;
    } else if (clutch != null) {
      activityType = ActivityType.hatching;
    } else if (breedingPlan != null) {
      activityType = ActivityType.breeding;
    } else {
      activityType = ActivityType.other;
    }
  }

  String? validateForm() {
    String? msg;
    if (activityType == ActivityType.feeding) {
      if (feedAmount == 0) {
        msg = 'Feed amount can\'t be 0';
      } else if (feedItem == null) {
        msg = 'Feed item is required';
      }
    } else if (activityType == ActivityType.measure) {
      if (weight == null || length == null) {
        msg = 'Require at least 1 data';
      }
    } else if (activityType == ActivityType.other) {
      if (title == null || title!.trim() == '') {
        msg = 'Title must not be empty';
      }
    }
    return msg;
  }

  void saveActivity() {
    dynamic activity;
    if (activityType == ActivityType.feeding) {
      Feed feed = Feed(
        feedName: feedItem!.feedName,
        size: feedItem!.size,
        cost: feedCostPerItem,
        feedID: feedItem!.feedID,
        amount: feedAmount,
        weight: feedItem!.weight,
        currency: feedItem!.currency,
      );
      activity = Feeding(
        feed: feed,
        petID: pet!.databaseID,
        amount: feedAmount,
        refuseFeed: refuseFeed,
        note: note,
      );
    } else if (activityType == ActivityType.healthCheck) {
      activity = HealthCheck(
        petID: pet!.databaseID,
        veterinarian: veterinarian,
        medicineName: medicineName,
        medicineDose: medicineDose,
        note: note,
      );
    } else if (activityType == ActivityType.measure) {
      activity = Measure(
        petID: pet!.databaseID,
        weight: weight,
        length: length,
        note: note,
      );
    } else if (activityType == ActivityType.shedding) {
      activity = Shedding(
        petID: pet!.databaseID,
        shedCondition: shedCondition,
        note: note,
      );
    }
    // brumating,
    // breeding,
    // hatching,
    // feedRestock,

    else {
      activity = Activity(
        activityType: activityType,
        title: Activity.titleByActivityType[activityType] ?? title!,
        note: note,
      );
    }
    // database.logActivity(activity);
    print(activity.toMap());
  }

  static String dateTimeString(DateTime dateTime) {
    return DateFormat('d MMMM yyyy').format(dateTime);
  }
}
