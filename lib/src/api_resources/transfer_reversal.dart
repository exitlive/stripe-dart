part of stripe;

/// [Transfer Reversals](https://stripe.com/docs/api#transfer_reversals)
class TransferReversal extends ApiResource {
  String get id => _dataMap['id'];

  final String object = 'transfer_reversal';

  static var _path = 'reversals';

  int get amount => _dataMap['amount'];

  DateTime get created => _getDateTimeFromMap('created');

  String get currency => _dataMap['currency'];

  String get balanceTransaction {
    return this._getIdForExpandable('balance_transaction');
  }

  BalanceTransaction get balanceTransactionExpand {
    var value = _dataMap['balance_transaction'];
    if (value == null)
      return null;
    else
      return new BalanceTransaction.fromMap(value);
  }

  Map get metadata => _dataMap['metadata'];

  String get transfer {
    return this._getIdForExpandable('transfer');
  }

  Transfer get transferExpand {
    var value = _dataMap['transfer'];
    if (value == null)
      return null;
    else
      return new Transfer.fromMap(value);
  }

  TransferReversal.fromMap(Map dataMap) : super.fromMap(dataMap);

  /// [Retrieve a reversal](https://stripe.com/docs/api#retrieve_transfer_reversal)
  static Future<Transfer> retrieve(String transferId, String reversalId, {final Map data}) async {
    var dataMap =
        await StripeService.retrieve([Transfer._path, transferId, TransferReversal._path, reversalId], data: data);
    return new Transfer.fromMap(dataMap);
  }

  /// [List all reversals](https://stripe.com/docs/api#list_transfer_reversals)
  static Future<TransferReversalCollection> list(String transferId,
      {int limit, String startingAfter, String endingBefore}) async {
    var data = {};
    if (limit != null) data['limit'] = limit;
    if (startingAfter != null) data['starting_after'] = startingAfter;
    if (endingBefore != null) data['ending_before'] = endingBefore;
    if (data == {}) data = null;
    var dataMap = await StripeService.list([Transfer._path, transferId, TransferReversal._path], data: data);
    return new TransferReversalCollection.fromMap(dataMap);
  }
}

class TransferReversalCollection extends ResourceCollection {
  TransferReversal _getInstanceFromMap(map) => new TransferReversal.fromMap(map);

  TransferReversalCollection.fromMap(Map map) : super.fromMap(map);
}

/// [Create a transfer reversal](https://stripe.com/docs/api#create_transfer_reversal)
class TransferReversalCreation extends ResourceRequest {
  set amount(int amount) => _setMap('amount', amount);

  set refundApplicationFee(bool refundApplicationFee) => _setMap('refund_application_fee', refundApplicationFee);

  set metadata(Map metadata) => _setMap('metadata', metadata);

  set description(String description) => _setMap('description', description);

  Future<TransferReversal> create(String transferId) async {
    var dataMap = await StripeService.create([Transfer._path, transferId, TransferReversal._path], _getMap());
    return new TransferReversal.fromMap(dataMap);
  }
}

/// [Update a reversal](https://stripe.com/docs/api#update_transfer_reversal)
class TransferReversalUpdate extends ResourceRequest {
  set metadata(Map metadata) => _setMap('metadata', metadata);

  set description(String description) => _setMap('description', description);

  Future<TransferReversal> update(String transferId, String reversalId) async {
    var dataMap =
        await StripeService.create([Transfer._path, transferId, TransferReversal._path, reversalId], _getMap());
    return new TransferReversal.fromMap(dataMap);
  }
}
