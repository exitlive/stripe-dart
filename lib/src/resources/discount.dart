part of stripe;


/**
 * [Discounts](https://stripe.com/docs/api/curl#discounts)
 */
class Discount extends Resource {

  String get id => _dataMap['id'];

  final String objectName = 'discount';

  static String _path = 'discount';

  Coupon get coupon {
    var value = _dataMap['coupon'];
    if (value == null) return null;
    else return new Coupon.fromMap(value);
  }

  String get customer => _dataMap['customer'];

  DateTime get start => _getDateTimeFromMap('start');

  DateTime get end => _getDateTimeFromMap('end');

  String get subscription => _dataMap['subscription'];

  Discount.fromMap(Map dataMap) : super.fromMap(dataMap);

}