part of stripe;

class LegalEntity extends Resource {
  Address get address {
    var value = _dataMap['address'];
    if (value == null)
      return null;
    else
      return new Address.fromMap(value);
  }

  Date get dateOfBirth {
    var value = _dataMap['dob'];
    if (value == null)
      return null;
    else
      return new Date.fromMap(value);
  }

  Address get personalAddress {
    var value = _dataMap['personal_address'];
    if (value == null)
      return null;
    else
      return new Address.fromMap(value);
  }

  Verification get verification {
    var value = _dataMap['verification'];
    if (value == null)
      return null;
    else
      return new Verification.fromMap(value);
  }

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
