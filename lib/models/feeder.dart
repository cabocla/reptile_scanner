enum FeedType {
  rat,
  mice,
  africanSoftFur,
  guineaPig,
  rabbit,
  piglet,
  chicken,
  quail,
  egg,
  cricket,
  roach,
  mealworm,
  silkworm,
  hornworm,
  superworm,
  phoenixworm,
  veggies,
  fruit,
  pellet,
  other,
}

enum FeedSize {
  pinkies,
  fuzzy,
  hopperPup,
  weaned,
  small,
  medium,
  large,
  jumbo,
  xs,
  s,
  m,
  l,
  xl,
}

class Feed {
  final String? feedID;
  final String feedName;
  final String size;
  final int weight; //gram
  final int amount; //inventory stock
  final double cost;
  final String currency;

  Feed({
    this.feedID,
    required this.feedName,
    required this.size,
    this.amount = 1,
    this.weight = 0,
    this.cost = 0.00,
    this.currency = 'USD',
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'feedName': feedName,
      'size': size,
      'amount': amount,
      'weight': weight,
      'cost': cost,
      'currency': currency,
    };
    return map;
  }

  factory Feed.fromMap(String id, Map<String, dynamic> data) {
    String feedName = data['feedName'];
    String size = data['size'];
    int amount = data['amount'];
    int weight = data['weight'];
    String currency = data['currency'];
    double cost = data['cost'];
    Feed feedData = Feed(
      feedID: id,
      feedName: feedName,
      size: size,
      amount: amount,
      weight: weight,
      cost: cost,
      currency: currency,
    );
    return feedData;
  }
}
