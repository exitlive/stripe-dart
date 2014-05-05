part of stripe;

/**
 * A coupon contains information about a percent-off discount you might want to
 * apply to a customer.
 *
 * Coupons only apply to invoices created for recurring subscriptions and
 * invoice items; they do not apply to one-off charges.
 */
class Coupon extends ApiResource {

  String objectName = "coupon";

  static String path = "coupons";


  Coupon.fromMap(Map json) : super.fromMap(json) {

  }

  DateTime get created => _getDateTimeFromMap("created");

  int get percentOff => _dataMap["percent_off"];

  int get amountOff => _dataMap["amount_off"];

  String get currency => _dataMap["currency"];

  String get duration => _dataMap["duration"];

  String get id => _dataMap["id"];

  bool get livemode => _dataMap["livemode"];

  int get durationInMonths => _dataMap["duration_in_months"];

  int get maxRedemptions => _dataMap["max_redemptions"];

  int get redeemBy => _dataMap["redeem_by"];

  int get timesRedeemed => _dataMap["times_redeemed"];

  bool get valid => _dataMap["valid"];

  Map<String, String> get metadata => _dataMap["metadata"];

}