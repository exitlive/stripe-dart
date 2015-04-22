part of stripe;

class LegalEntity extends Resource {
  Address get address => new Address.fromMap(_dataMap['address']);

  Date get dateOfBirth => new Date.fromMap(_dataMap['dob']);

  Address get personalAddress => new Address.fromMap(_dataMap['personal_address']);

  Verification get verification => new Verification.fromMap(_dataMap['verification']);

  List<AdditionalOwner> get additionalOwners {
    var list = [];
    if (!_dataMap.containsKey('additional_owners') || !(_dataMap['additional_owners'] is List)) return null;
    for (Map value in _dataMap['additional_owners']) {
      list.add(new AdditionalOwner.fromMap(value));
    }
    return list;
  }

  String get businessName => _dataMap['business_name'];

  String get firstName => _dataMap['first_name'];

  String get lastName => _dataMap['last_name'];

  String get type => _dataMap['type'];

  LegalEntity.fromMap(Map dataMap) : super.fromMap(dataMap);
}
