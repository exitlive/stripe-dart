part of stripe;

class Address extends Resource {
  String get line1 => _dataMap['line1'];

  String get line2 => _dataMap['line2'];

  String get city => _dataMap['city'];

  String get state => _dataMap['state'];

  String get postalCode => _dataMap['postal_code'];

  String get country => _dataMap['country'];

  Address.fromMap(Map dataMap) : super.fromMap(dataMap);
}
