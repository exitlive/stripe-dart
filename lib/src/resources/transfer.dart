part of stripe;


/**
 * [Transfers](https://stripe.com/docs/api/curl#transfers)
 */
class Transfer extends ApiResource {

  String get id => _dataMap['id'];

  final String objectName = 'transfer';

  static String _path = 'transfers';

  bool get livemode => _dataMap['livemode'];

  int get amount => _dataMap['amount'];

  DateTime get created => _getDateTimeFromMap('created');

  String get currency => _dataMap['currency'];

  DateTime get date => _getDateTimeFromMap('date');

  String get status => _dataMap['status'];

  String get type => _dataMap['type'];

  String get balanceTransaction {
    var value = _dataMap['balance_transaction'];
    if (value == null) return null;
    else if(value is String) return value;
    else return new BalanceTransaction.fromMap(value).id;
  }

  BalanceTransaction get balanceTransactionExpand {
    var value = _dataMap['balance_transaction'];
    if (value == null) return null;
    else return new BalanceTransaction.fromMap(value);
  }

  String get description => _dataMap['description'];

  Map get metadata => _dataMap['metadata'];

  BankAccount get bankAccount {
    var value = _dataMap['bank_account'];
    if (value == null) return null;
    else return new BankAccount.fromMap(value);
  }

  Card get card {
    var value = _dataMap['card'];
    if (value == null) return null;
    else return new Card.fromMap(value);
  }

  String get recipient => _dataMap['recipient'];

  String get statementDescription => _dataMap['statement_description'];

  Transfer.fromMap(Map dataMap) : super.fromMap(dataMap);

  /**
   * [Retrieving a Transfer](https://stripe.com/docs/api/curl#retrieve_transfer)
   */
  static Future<Transfer> retrieve(String transferId, {final Map data}) {
    return StripeService.retrieve([Transfer._path, transferId], data: data)
        .then((Map json) => new Transfer.fromMap(json));
  }

  /**
   * [Canceling a Transfer](https://stripe.com/docs/api/curl#cancel_transfer)
   */
  static Future<Transfer> cancel(String transferId) {
    return StripeService.post([Transfer._path, transferId, 'cancel'])
        .then((Map json) => new Transfer.fromMap(json));
  }

  /**
   * [List all Transfers](https://stripe.com/docs/api/curl#list_transfers)
   */
  // TODO: implement missing arguments
  static Future<TransferCollection> list({int limit, String startingAfter, String endingBefore, String recipient, String status}) {
    Map data = {};
    if (limit != null) data['limit'] = limit;
    if (startingAfter != null) data['starting_after'] = startingAfter;
    if (endingBefore != null) data['ending_before'] = endingBefore;
    if (recipient != null) data['recipient'] = recipient;
    if (status != null) data['status'] = status;
    if (data == {}) data = null;
    return StripeService.list([Transfer._path], data: data)
        .then((Map json) => new TransferCollection.fromMap(json));
  }

}


class TransferCollection extends ResourceCollection {

  Transfer _getInstanceFromMap(map) => new Transfer.fromMap(map);

  TransferCollection.fromMap(Map map) : super.fromMap(map);

}


/**
 * [Creating a new transfer](https://stripe.com/docs/api/curl#create_transfer)
 */
class TransferCreation extends ResourceRequest {

  @required
  set amount (int amount) => _setMap('amount', amount);

  @required
  set currency (String currency) => _setMap('currency', currency);

  @required
  set recipient (String recipient) => _setMap('recipient', recipient);

  set description (String description) => _setMap('description', description);

  set bankAccount (BankAccountRequest bankAccount) => _setMap('bank_account', bankAccount);

  set card (String card) => _setMap('card', card);

  set statementDescription (String statementDescription) => _setMap('statement_description', statementDescription);

  set metadata (Map metadata) => _setMap('metadata', metadata);

  Future<Transfer> create() {
    return StripeService.create([Transfer._path], _getMap())
        .then((Map json) => new Transfer.fromMap(json));
  }

}


/**
 * [Updating a Transfer](https://stripe.com/docs/api/curl#update_transfer)
 */
class TransferUpdate extends ResourceRequest {

  set description (String description) => _setMap('description', description);

  set metadata (Map metadata) => _setMap('metadata', metadata);

  Future<Transfer> update(String transferId) {
    return StripeService.create([Transfer._path, transferId], _getMap())
        .then((Map json) => new Transfer.fromMap(json));
  }

}