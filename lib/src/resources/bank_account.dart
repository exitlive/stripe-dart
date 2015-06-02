part of stripe;

class BankAccount extends Resource {
  String get id => _dataMap['id'];

  final String object = 'bank_account';

  String get country => _dataMap['country'];

  String get currency => _dataMap['currency'];

  bool get defaultForCurrency => _dataMap['default_for_currency'];

  String get last4 => _dataMap['last4'];

  String get status => _dataMap['status'];

  String get bankName => _dataMap['bank_name'];

  String get fingerprint => _dataMap['fingerprint'];

  String get routingNumber => _dataMap['routing_number'];

  String get accountNumber => _dataMap['account_number'];

  BankAccount.fromMap(Map dataMap) : super.fromMap(dataMap);
}

class BankAccountCollection extends ResourceCollection {
  BankAccount _getInstanceFromMap(map) => new BankAccount.fromMap(map);

  BankAccountCollection.fromMap(Map map) : super.fromMap(map);
}
