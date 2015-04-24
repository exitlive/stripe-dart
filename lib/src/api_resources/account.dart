part of stripe;

/// [Account](https://stripe.com/docs/api/curl#account)
class Account extends ApiResource {
  String get id => _dataMap['id'];

  final String object = 'account';

  static var _pathSingle = 'account';

  static var _pathMultiple = 'accounts';

  bool get chargesEnabled => _dataMap['charges_enabled'];

  String get country => _dataMap['country'];

  List<String> get currenciesSupported => _dataMap['currencies_supported'];

  String get defaultCurrency => _dataMap['default_currency'];

  bool get detailsSubmitted => _dataMap['details_submitted'];

  bool get transfersEnabled => _dataMap['transfers_enabled'];

  String get displayName => _dataMap['display_name'];

  String get email => _dataMap['email'];

  String get statementDescriptor => _dataMap['statement_descriptor'];

  String get timezone => _dataMap['timezone'];

  String get businessName => _dataMap['business_name'];

  String get businessUrl => _dataMap['business_url'];

  Map<String, String> get metadata => _dataMap['metadata'];

  String get supportPhone => _dataMap['support_phone'];

  bool get managed => _dataMap['managed'];

  BankAccountCollection get bankAccounts {
    Map value = _dataMap['bank_accounts'];
    assert(value != null);
    return new BankAccountCollection.fromMap(value);
  }

  bool get debitNegativeBalances => _dataMap['debit_negative_balances'];

  LegalEntity get legalEntity {
    var value = _dataMap['legal_entity'];
    if (value == null) return null;
    else return new LegalEntity.fromMap(value);
  }

  String get productDescription => _dataMap['product_description'];

  TosAcceptance get tosAcceptance {
    var value = _dataMap['tos_acceptance'];
    if (value == null) return null;
    else return new TosAcceptance.fromMap(value);
  }

  TransferSchedule get transferSchedule {
    var value = _dataMap['transfer_schedule'];
    if (value == null) return null;
    else return new TransferSchedule.fromMap(value);
  }

  Verification get verification {
    var value = _dataMap['verification'];
    if (value == null) return null;
    else return new Verification.fromMap(value);
  }

  Map get keys => _dataMap['keys'];

  Account.fromMap(Map dataMap) : super.fromMap(dataMap);

  /// [Retrieve account details](https://stripe.com/docs/api/curl#retrieve_account)
  static Future<Account> retrieve({String accountId}) async {
    var parameters = [Account._pathSingle];
    if (accountId != null) parameters.add(accountId);
    var dataMap = await StripeService.retrieve(parameters);
    return new Account.fromMap(dataMap);
  }

  /// [List all connected accounts](https://stripe.com/docs/api/curl#list_accounts)
  static Future<AccountCollection> list({int limit, String startingAfter, String endingBefore}) async {
    var data = {};
    if (endingBefore != null) data['ending_before'] = endingBefore;
    if (limit != null) data['limit'] = limit;
    if (startingAfter != null) data['starting_after'] = startingAfter;
    if (data == {}) data = null;
    var dataMap = await StripeService.list([Account._pathMultiple], data: data);
    return new AccountCollection.fromMap(dataMap);
  }
}

/// [Create an account](https://stripe.com/docs/api/curl#create_account)
class AccountCreation extends ResourceRequest {
  set managed(String managed) => _setMap('managed', managed);

  set country(String country) => _setMap('country', country);

  set email(String email) => _setMap('email', email);

  set businessName(String businessName) => _setMap('business_name', businessName);

  set businessUrl(String businessUrl) => _setMap('business_url', businessUrl);

  set supportPhone(String supportPhone) => _setMap('support_phone', supportPhone);

  set bankAccount(BankAccount bankAccount) => _setMap('bank_account', bankAccount);

  set debitNegativeBalances(bool debitNegativeBalances) => _setMap('debit_negative_balances', debitNegativeBalances);

  set defaultCurrency(String defaultCurrency) => _setMap('default_currency', defaultCurrency);

  set legalEntity(LegalEntity legalEntity) => _setMap('legal_entity', legalEntity);

  set productDescription(String productDescription) => _setMap('product_description', productDescription);

  set statementDescriptor(String statementDescriptor) => _setMap('statement_descriptor', statementDescriptor);

  set tosAcceptance(TosAcceptance tosAcceptance) => _setMap('tos_acceptance', tosAcceptance);

  set transferSchedule(TransferSchedule transferSchedule) => _setMap('transfer_schedule', transferSchedule);

  set metadata(Map metadata) => _setMap('metadata', metadata);

  Future<Account> create() async {
    var dataMap = await StripeService.create([Account._pathMultiple], _getMap());
    return new Account.fromMap(dataMap);
  }
}

/// [Update an account](https://stripe.com/docs/api/curl#update_account)
class AccountUpdate extends ResourceRequest {
  set businessName(String businessName) => _setMap('business_name', businessName);

  set businessUrl(String businessUrl) => _setMap('business_url', businessUrl);

  set supportPhone(String supportPhone) => _setMap('support_phone', supportPhone);

  set bankAccount(BankAccount bankAccount) => _setMap('bank_account', bankAccount.toMap());

  set debitNegativeBalances(bool debitNegativeBalances) => _setMap('debit_negative_balances', debitNegativeBalances);

  set defaultCurrency(String defaultCurrency) => _setMap('default_currency', defaultCurrency);

  set email(String email) => _setMap('email', email);

  set legalEntity(LegalEntity legalEntity) => _setMap('legal_entity', legalEntity);

  set productDescription(String productDescription) => _setMap('product_description', productDescription);

  set statementDescriptor(String statementDescriptor) => _setMap('statement_descriptor', statementDescriptor);

  set tosAcceptance(TosAcceptance tosAcceptance) => _setMap('tos_acceptance', tosAcceptance);

  set transferSchedule(TransferSchedule transferSchedule) => _setMap('transfer_schedule', transferSchedule);

  set metadata(Map metadata) => _setMap('metadata', metadata);

  Future<Account> update(String accountId) async {
    var dataMap = await StripeService.update([Account._pathMultiple, accountId], _getMap());
    return new Account.fromMap(dataMap);
  }
}

class AccountCollection extends ResourceCollection {
  Account _getInstanceFromMap(map) => new Account.fromMap(map);

  AccountCollection.fromMap(Map map) : super.fromMap(map);
}
