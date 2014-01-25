part of stripe;

/**
 * A coupon contains information about a percent-off discount you might want to
 * apply to a customer.
 *
 * Coupons only apply to invoices created for recurring subscriptions and
 * invoice items; they do not apply to one-off charges.
 */
class Coupon extends ApiResource {
  int percentOff;
  int amountOff;
  String currency;
  String duration;
  String id;
  bool livemode;
  int durationInMonths;
  int maxRedemptions;
  int redeemBy;
  int timesRedeemed;

  Coupon.fromMap(Map json) : super.fromMap(json) {

  }

}