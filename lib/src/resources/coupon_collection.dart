part of stripe;

class CouponCollection extends ResourceCollection {

  Coupon getInstanceFromMap(map) => new Coupon.fromMap(map);

  CouponCollection.fromMap(Map map) : super.fromMap(map);

}