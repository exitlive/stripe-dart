part of stripe;

class AdditionalOwner extends Resource {
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

  Verification get verification {
    var value = _dataMap['verification'];
    if (value == null)
      return null;
    else
      return new Verification.fromMap(value);
  }

  String get firstName => _dataMap['first_name'];

  String get lastName => _dataMap['last_name'];

  AdditionalOwner.fromMap(Map dataMap) : super.fromMap(dataMap);
}
