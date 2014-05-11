part of stripe;

/**
 * A discount represents the actual application of a coupon to a particular
 * customer. It contains information about when the discount began and when it
 * will end.
 */
class Discount extends Resource {

  String get id => _dataMap["id"];

  final String objectName = "discount";

  static String _path = "discount";

  /// Hash describing the coupon applied to create this discount
  Coupon get coupon {
    var value = _dataMap["coupon"];
    if (value == null) return null;
    else return new Coupon.fromMap(value);
  }


  String get customer => _dataMap["customer"];

  /// Date that the coupon was applied
  int get start => _dataMap["start"];

  /// If the coupon has a duration of once or repeating, the date that this
  /// discount will end. If the coupon used has a forever duration,
  /// this attribute will be null.
  int get end => _dataMap["end"];

  /// The subscription that this coupon is applied to, if it is applied to
  /// a particular subscription
  String get subscription => _dataMap["subscription"];

  Discount.fromMap(Map dataMap) : super.fromMap(dataMap);

}