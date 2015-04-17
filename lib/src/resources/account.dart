part of stripe;

/// [Account](https://stripe.com/docs/api/curl#account)
class Account extends ApiResource {
  String get id => _dataMap['id'];

  final String objectName = 'account';

  static var _path = 'account';

  bool get chargeEnabled => _dataMap['charge_enabled'];

  String get country => _dataMap['country'];

  List<String> get currenciesSupported => _dataMap['currencies_supported'];

  String get defaultCurrency => _dataMap['default_currency'];

  bool get detailsSubmitted => _dataMap['details_submitted'];

  bool get transferEnabled => _dataMap['transfer_enabled'];

  String get displayName => _dataMap['display_name'];

  String get email => _dataMap['email'];

  String get statementDescriptor => _dataMap['statement_descriptor'];

  String get timezone => _dataMap['timezone'];

  Account.fromMap(Map dataMap) : super.fromMap(dataMap);

  /// [Retrieve an account](https://stripe.com/docs/api/curl#retrieve_account)
  static Future<Account> retrieve() async {
    var dataMap = await StripeService.retrieve([Account._path]);
    return new Account.fromMap(dataMap);
  }
}
