part of stripe;

/// [Transfers](https://stripe.com/docs/api#transfers)
class Transfer extends ApiResource {
  String get id => _dataMap['id'];

  final String object = 'transfer';

  static var _path = 'transfers';

  bool get livemode => _dataMap['livemode'];

  int get amount => _dataMap['amount'];

  DateTime get created => _getDateTimeFromMap('created');

  String get currency => _dataMap['currency'];

  DateTime get date => _getDateTimeFromMap('date');

  TransferReversalCollection get reversals {
    var value = _dataMap['reversals'];
    if (value == null) return null;
    else return new TransferReversalCollection.fromMap(value);
  }

  bool get reversed => _dataMap['reversed'];

  String get status => _dataMap['status'];

  String get type => _dataMap['type'];

  int get amountReversed => _dataMap['amount_reversed'];

  String get balanceTransaction {
    return this._getIdForExpandable('balance_transaction');
  }

  BalanceTransaction get balanceTransactionExpand {
    var value = _dataMap['balance_transaction'];
    if (value == null) return null;
    else return new BalanceTransaction.fromMap(value);
  }

  String get description => _dataMap['description'];

  String get failureCode => _dataMap['failure_code'];

  String get failureMessage => _dataMap['failure_message'];

  Map get metadata => _dataMap['metadata'];

  String get applicationFee => _dataMap['application_fee'];

  String get destination {
    return this._getIdForExpandable('destination');
  }

  dynamic get destinationExpand {
    var value = _dataMap['destination'];
    if (!(value is Map) || !(value.containsKey('object'))) return null;
    String object = value['object'];
    switch (object) {
      case 'card':
        return new Card.fromMap(value);
      case 'account':
        return new Account.fromMap(value);
      case 'bank_account':
        return new BankAccount.fromMap(value);
      default:
        return null;
    }
  }

  String get destinationPayment {
    return this._getIdForExpandable('destination_payment');
  }

  Charge get destinationPaymentExpand {
    var value = _dataMap['destination_payment'];
    if (value == null) return null;
    else return new Charge.fromMap(value);
  }

  String get sourceTransaction {
    return this._getIdForExpandable('source_transaction');
  }

  dynamic get sourceTransactionExpand {
    var value = _dataMap['source_transaction'];
    if (!(value is Map) || !(value.containsKey('object'))) return null;
    String object = value['object'];
    switch (object) {
      case 'charge':
        return new Charge.fromMap(value);
      default:
        return null;
    }
  }

  String get statementDescriptor => _dataMap['statement_descriptor'];

  Transfer.fromMap(Map dataMap) : super.fromMap(dataMap);

  /// [Retrieve a transfer](https://stripe.com/docs/api#retrieve_transfer)
  static Future<Transfer> retrieve(String transferId, {final Map data}) async {
    var dataMap = await StripeService.retrieve([Transfer._path, transferId], data: data);
    return new Transfer.fromMap(dataMap);
  }

  /// [Canceling a Transfer](https://stripe.com/docs/api/curl#cancel_transfer)
  static Future<Transfer> cancel(String transferId) async {
    var dataMap = await StripeService.post([Transfer._path, transferId, 'cancel']);
    return new Transfer.fromMap(dataMap);
  }

  /// [List all transfers](https://stripe.com/docs/api#list_transfers)
  static Future<TransferCollection> list(
      {var created,
      var date,
      int limit,
      String startingAfter,
      String endingBefore,
      String recipient,
      String status}) async {
    var data = {};
    if (created != null) data['created'] = created;
    if (date != null) data['date'] = date;
    if (endingBefore != null) data['ending_before'] = endingBefore;
    if (limit != null) data['limit'] = limit;
    if (recipient != null) data['recipient'] = recipient;
    if (startingAfter != null) data['starting_after'] = startingAfter;
    if (status != null) data['status'] = status;
    if (data == {}) data = null;
    var dataMap = await StripeService.list([Transfer._path], data: data);
    return new TransferCollection.fromMap(dataMap);
  }
}

class TransferCollection extends ResourceCollection {
  Transfer _getInstanceFromMap(map) => new Transfer.fromMap(map);

  TransferCollection.fromMap(Map map) : super.fromMap(map);
}

/// [Create a transfer](https://stripe.com/docs/api#create_transfer)
class TransferCreation extends ResourceRequest {
  @required
  set amount(int amount) => _setMap('amount', amount);

  @required
  set currency(String currency) => _setMap('currency', currency);

  @required
  set destination(String destination) => _setMap('destination', destination);

  set sourceTransaction(String sourceTransaction) => _setMap('source_transaction', sourceTransaction);

  set description(String description) => _setMap('description', description);

  set statementDescriptor(String statementDescriptor) => _setMap('statement_descriptor', statementDescriptor);

  set metadata(Map metadata) => _setMap('metadata', metadata);

  Future<Transfer> create() async {
    var dataMap = await StripeService.create([Transfer._path], _getMap());
    return new Transfer.fromMap(dataMap);
  }
}

/// [Update a transfer](https://stripe.com/docs/api#update_transfer)
class TransferUpdate extends ResourceRequest {
  set description(String description) => _setMap('description', description);

  set metadata(Map metadata) => _setMap('metadata', metadata);

  Future<Transfer> update(String transferId) async {
    var dataMap = await StripeService.create([Transfer._path, transferId], _getMap());
    return new Transfer.fromMap(dataMap);
  }
}
