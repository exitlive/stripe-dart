part of stripe;

/**
 * A discount represents the actual application of a coupon to a particular
 * customer. It contains information about when the discount began and when it
 * will end.
 *
 *
 */
class Discount extends Resource {
  int end;
  String id;
  int start;
  Coupon coupon;
  String customer;

  Discount.fromMap(Map json) : super.fromMap(json) {

  }

}