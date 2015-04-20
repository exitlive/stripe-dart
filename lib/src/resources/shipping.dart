part of stripe;

class Shipping extends Resource {
  Address get address => new Address.fromMap(_dataMap['address']);

  String get name => _dataMap['name'];

  String get carrier => _dataMap['carrier'];

  String get phone => _dataMap['phone'];

  String get trackingNumber => _dataMap['tracking_number'];

  Shipping.fromMap(Map dataMap) : super.fromMap(dataMap);
}
