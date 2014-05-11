part of stripe;

/**
 * A coupon contains information about a percent-off discount you might want to
 * apply to a customer.
 *
 * Coupons only apply to invoices created for recurring subscriptions and
 * invoice items; they do not apply to one-off charges.
 */
class Coupon extends ApiResource {

  String get id => _dataMap["id"];

  String objectName = "coupon";

  static String _path = "coupons";


  Coupon.fromMap(Map dataMap) : super.fromMap(dataMap);


  bool get livemode => _dataMap["livemode"];

  DateTime get created => _getDateTimeFromMap("created");

  /// One of forever, once, and repeating. Describes how long a customer who
  /// applies this coupon will get the discount.
  String get duration => _dataMap["duration"];

  /// Amount (in the currency specified) that will be taken off the subtotal of
  /// any invoices for this customer.
  int get amountOff => _dataMap["amount_off"];

  /// If amount_off has been set, the currency of the amount to take off.
  String get currency => _dataMap["currency"];

  /// If duration is repeating, the number of months the coupon applies.
  /// Null if coupon duration is forever or once.
  int get durationInMonths => _dataMap["duration_in_months"];

  /// Maximum number of times this coupon can be redeemed, in total,
  /// before it is no longer valid.
  int get maxRedemptions => _dataMap["max_redemptions"];

  /// A set of key/value pairs that you can attach to a coupon object.
  /// It can be useful for storing additional information about the coupon in
  /// a structured format.
  Map<String, String> get metadata => _dataMap["metadata"];

  /// Percent that will be taken off the subtotal of any invoices for this
  /// customer for the duration of the coupon. For example, a coupon with
  /// percent_off of 50 will make a $100 invoice $50 instead.
  int get percentOff => _dataMap["percent_off"];

  /// Date after which the coupon can no longer be redeemed
  int get redeemBy => _dataMap["redeem_by"];

  /// Number of times this coupon has been applied to a customer.
  int get timesRedeemed => _dataMap["times_redeemed"];

  /// Taking account of the above properties, whether this coupon can still be
  /// applied to a customer
  bool get valid => _dataMap["valid"];


  /*
   * Retrieves the coupon with the given ID.
   */
  static Future<Coupon> retrieve(String id) {
    return StripeService.retrieve(Coupon._path, id)
        .then((Map json) => new Coupon.fromMap(json));
  }

  /*
   * Returns a [CouponCollection] of your coupons
   */
  static Future<CouponCollection> all({Map<String, dynamic> params: const {}}) {
    return StripeService.list(Coupon._path, params)
        .then((Map json) => new CouponCollection.fromMap(json));
  }

  /*
   * You can delete coupons via the coupon management page of the Stripe
   * dashboard. However, deleting a coupon does not affect any customers who
   * have already applied the coupon; it means that new customers can't redeem
   * the coupon. You can also delete coupons via the API.
   */
  static Future delete(String id) => StripeService.delete(Coupon._path, id);


}

/**
 * Used to create a [Coupon]
 *
 * A coupon has either a percent_off or an amount_off and currency. If you set
 * an amount_off, that amount will be subtracted from any invoice's subtotal.
 * For example, an invoice with a subtotal of $10 will have a final total of $0
 * if a coupon with an amount_off of 2000 is applied to it and an invoice with
 * a subtotal of $30 will have a final total of $10 if a coupon with an
 * amount_off of 2000 is applied to it.
 */
class CouponCreation extends ResourceRequest {

  /// Unique string of your choice that will be used to identify this coupon
  /// when applying it a customer. This is often a specific code you’ll give to
  /// your customer to use when signing up (e.g. FALL25OFF). If you don’t want
  /// to specify a particular code, you can leave the ID blank and we’ll
  /// generate a random code for you.
  set id (String id) => _setMap("id", id);

  /// Specifies how long the discount will be in effect.
  /// Can be forever, once, or repeating.
  @required
  set duration (String duration) => _setMap("duration", duration);

  /// A positive integer representing the amount to subtract from an invoice
  /// total (required if percent_off is not passed)
  set amountOff (int amountOff) => _setMap("amount_off", amountOff);

  // Currency of the amount_off parameter (required if amount_off is passed)
  set currency (String currency) => _setMap("currency", currency);

  /// required only if duration is repeating If duration is repeating,
  /// a positive integer that specifies the number of months the discount will
  /// be in effect
  set durationInMonths (int durationInMonths) => _setMap("duration_in_months", durationInMonths);

  /// A positive integer specifying the number of times the coupon can be
  /// redeemed before it’s no longer valid. For example, you might have a 50%
  /// off coupon that the first 20 readers of your blog can use.
  set maxRedemptions (int maxRedemptions) => _setMap("max_redemptions", maxRedemptions);

  /// A set of key/value pairs that you can attach to a coupon object.
  /// It can be useful for storing additional information about the coupon in
  /// a structured format. This will be unset if you POST an empty value.
  set metadata (Map metadata) => _setMap("metadata", metadata);

  /// A positive integer between 1 and 100 that represents the discount the
  /// coupon will apply (required if amount_off is not passed)
  set percentOff (int percentOff) => _setMap("percent_off", percentOff);

  /// UTC timestamp specifying the last time at which the coupon can be
  /// redeemed. After the redeem_by date, the coupon can no longer be applied
  /// to new customers.
  set redeemBy (int redeemBy) => _setMap("redeem_by", redeemBy);

  /*
   * Uses the values of [CouponCreation] to send a request to the Stripe API.
   * Returns a [Future] with a new [Coupon] from the response.
   */
  Future<Coupon> create() {
    return StripeService.create("${Coupon._path}", _getMap())
      .then((Map json) => new Coupon.fromMap(json));
  }

}
