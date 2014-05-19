part of stripe;


/**
 * [Balance](https://stripe.com/docs/api/curl#balance)
 */
class Recipient extends Resource {

  String get id => _dataMap['id'];

  String objectName = 'recipient';

  static String _path = 'recipients';

  bool get livemode => _dataMap['livemode'];

  DateTime get created => _getDateTimeFromMap('created');

  String get type => _dataMap['type'];

  BankAccount get activeAccount {
    var value = _dataMap['active_account'];
    if (value == null) return null;
    else return new BankAccount.fromMap(value);
  }

  String get description => _dataMap['description'];

  String get email => _dataMap['email'];

  Map<String, String> get metadata => _dataMap['metadata'];

  String get name => _dataMap['name'];

  Recipient.fromMap(Map dataMap) : super.fromMap(dataMap);

  /**
   * [Retrieve a balance](https://stripe.com/docs/api/curl#retrieve_balance)
   */
  static Future<Balance> retrieve() {
    return StripeService.get([Balance._path])
        .then((Map json) => new Balance.fromMap(json));
  }

}

class BankAccount {

  Map _dataMap;

  String objectName = 'bank_account';

  String get id => _dataMap['id'];

  String get bankName => _dataMap['bank_name'];

  String get country => _dataMap['country'];

  String get currency => _dataMap['currency'];

  String get last4 => _dataMap['last4'];

  bool get disabled => _dataMap['disabled'];

  String get fingerprint => _dataMap['fingerprint'];

  bool get validated => _dataMap['validated'];

  BankAccount.fromMap(this._dataMap);

}