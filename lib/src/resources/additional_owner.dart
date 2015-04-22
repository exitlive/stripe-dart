part of stripe;

class AdditionalOwner extends Resource {
  Address get address => new Address.fromMap(_dataMap['address']);

  Date get dateOfBirth => new Date.fromMap(_dataMap['dob']);

  Verification get verification => new Verification.fromMap(_dataMap['verification']);

  String get firstName => _dataMap['first_name'];

  String get lastName => _dataMap['last_name'];

  AdditionalOwner.fromMap(Map dataMap) : super.fromMap(dataMap);
}
