part of stripe;


/**
 * [Coupons](https://stripe.com/docs/api/curl#coupons)
 */
class Coupon extends ApiResource {

  String get id => _dataMap["id"];

  String objectName = "coupon";

  static String _path = "coupons";

  bool get livemode => _dataMap["livemode"];

  DateTime get created => _getDateTimeFromMap("created");

  String get duration => _dataMap["duration"];

  int get amountOff => _dataMap["amount_off"];

  String get currency => _dataMap["currency"];

  int get durationInMonths => _dataMap["duration_in_months"];

  int get maxRedemptions => _dataMap["max_redemptions"];

  Map<String, String> get metadata => _dataMap["metadata"];

  int get percentOff => _dataMap["percent_off"];

  int get redeemBy => _dataMap["redeem_by"];

  int get timesRedeemed => _dataMap["times_redeemed"];

  bool get valid => _dataMap["valid"];

  Coupon.fromMap(Map dataMap) : super.fromMap(dataMap);

  /**
   * [Retrieving a Coupon](https://stripe.com/docs/api/curl#retrieve_coupon)
   */
  static Future<Coupon> retrieve(String id) {
    return StripeService.retrieve([Coupon._path, id])
        .then((Map json) => new Coupon.fromMap(json));
  }

  /**
   * [List all Coupons](https://stripe.com/docs/api/curl#list_coupons)
   */
  static Future<CouponCollection> list({int limit, String startingAfter, String endingBefore}) {
    Map data = {};
    if (limit != null) data["limit"] = limit;
    if (startingAfter != null) data["starting_after"] = startingAfter;
    if (endingBefore != null) data["ending_before"] = endingBefore;
    if (data == {}) data = null;
    return StripeService.list([Coupon._path], data: data)
        .then((Map json) => new CouponCollection.fromMap(json));
  }

  /**
   * [Deleting a coupon](https://stripe.com/docs/api/curl#delete_coupon)
   */
  static Future delete(String id) => StripeService.delete([Coupon._path, id]);

}


/**
 * [Creating coupons](https://stripe.com/docs/api/curl#create_coupon)
 */
class CouponCreation extends ResourceRequest {

  set id (String id) => _setMap("id", id);

  @required
  set duration (String duration) => _setMap("duration", duration);

  set amountOff (int amountOff) => _setMap("amount_off", amountOff);

  set currency (String currency) => _setMap("currency", currency);

  set durationInMonths (int durationInMonths) => _setMap("duration_in_months", durationInMonths);

  set maxRedemptions (int maxRedemptions) => _setMap("max_redemptions", maxRedemptions);

  set metadata (Map metadata) => _setMap("metadata", metadata);

  set percentOff (int percentOff) => _setMap("percent_off", percentOff);

  set redeemBy (int redeemBy) => _setMap("redeem_by", redeemBy);

  Future<Coupon> create() {
    return StripeService.create([Coupon._path], _getMap())
      .then((Map json) => new Coupon.fromMap(json));
  }

}
