part of stripe;

class Shipping extends Resource {
  Address get address {
    var value = _dataMap['address'];
    if (value == null) return null;
    else return new Address.fromMap(value);
  }

  String get name => _dataMap['name'];

  String get carrier => _dataMap['carrier'];

  String get phone => _dataMap['phone'];

  String get trackingNumber => _dataMap['tracking_number'];

  Shipping.fromMap(Map dataMap) : super.fromMap(dataMap);
}
