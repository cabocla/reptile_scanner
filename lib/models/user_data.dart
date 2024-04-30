enum WeightUnit {
  g,
  kg,
  lb,
  oz,
}

enum LengthUnit {
  cm,
  m,
  inch,
  ft,
}

class UserData {
  final String uid;
  final String userName;
  final String currency;
  final WeightUnit weightUnit;
  final LengthUnit lengthUnit;
  final int exp;

  UserData({
    required this.uid,
    required this.userName,
    required this.currency,
    required this.weightUnit,
    required this.lengthUnit,
    required this.exp,
  });

  UserData updateCurency(String newCurrency) {
    return UserData(
      uid: uid,
      userName: userName,
      currency: newCurrency,
      weightUnit: weightUnit,
      lengthUnit: lengthUnit,
      exp: exp,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userName': userName,
      'currency': currency,
      'weightUnit': weightUnit.toString(),
      'lengthUnit': lengthUnit.toString(),
      'exp': exp,
    };
  }

  factory UserData.fromMap(String uid, Map<String, dynamic> data) {
    WeightUnit weightUnit = WeightUnit.values.firstWhere(
      (element) => element.toString() == data['weightUnit'],
      orElse: () => WeightUnit.g,
    );
    LengthUnit lengthUnit = LengthUnit.values.firstWhere(
      (element) => element.toString() == data['lengthUnit'],
      orElse: () => LengthUnit.cm,
    );
    return UserData(
      uid: uid,
      userName: data['userName'],
      currency: data['currency'],
      weightUnit: weightUnit,
      lengthUnit: lengthUnit,
      exp: data['exp'],
    );
  }

  String get getWeightUnit {
    return weightUnitString[weightUnit] ?? 'g';
  }

  String get getLengthUnit {
    return lengthUnitString[lengthUnit] ?? 'cm';
  }

  static const Map<WeightUnit, String> weightUnitString = {
    WeightUnit.g: 'g',
    WeightUnit.kg: 'Kg',
    WeightUnit.lb: 'Lb',
    WeightUnit.oz: 'Oz',
  };
  static const Map<LengthUnit, String> lengthUnitString = {
    LengthUnit.cm: 'Cm',
    LengthUnit.m: 'M',
    LengthUnit.inch: 'Inch',
    LengthUnit.ft: 'Ft',
  };
}
