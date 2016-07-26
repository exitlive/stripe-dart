part of stripe;

/// [Refunds](https://stripe.com/docs/api#refunds)
class Refund extends ApiResource {
  String get id => _dataMap['id'];

  final String object = 'refund';

  static var _path = 'refunds';

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

  String get charge => _dataMap['charge'];

  Map<String, String> get metadata => _dataMap['metadata'];

  String get reason => _dataMap['reason'];

  String get receiptNumber => _dataMap['receipt_number'];

  String get description => _dataMap['description'];

  Refund.fromMap(Map dataMap) : super.fromMap(dataMap);

  /// [Retrieve a refund](https://stripe.com/docs/api#retrieve_refund)
  static Future<Refund> retrieve(String chargeId, String refundId, {final Map data}) async {
    var dataMap = await StripeService.retrieve([Charge._path, chargeId, Refund._path, refundId], data: data);
    return new Refund.fromMap(dataMap);
  }

  /// [List all refunds](https://stripe.com/docs/api#list_refunds)
  static Future<RefundCollection> list(String chargeId, {int limit, String startingAfter, String endingBefore}) async {
    var data = {};
    if (endingBefore != null) data['ending_before'] = endingBefore;
    if (limit != null) data['limit'] = limit;
    if (startingAfter != null) data['starting_after'] = startingAfter;
    if (data == {}) data = null;
    var dataMap = await StripeService.list([Charge._path, chargeId, Refund._path], data: data);
    return new RefundCollection.fromMap(dataMap);
  }
}

/// [Create a refund](https://stripe.com/docs/api#create_refund)
class RefundCreation extends ResourceRequest {
  set amount(int amount) => _setMap('amount', amount);

  set refundApplicationFee(bool refundApplicationFee) =>
      _setMap('refund_application_fee', refundApplicationFee.toString());

  set reason(String reason) => _setMap('reason', reason);

  set metadata(Map metadata) => _setMap('metadata', metadata);

  Future<Refund> create(String chargeId) async {
    var dataMap = await StripeService.create([Charge._path, chargeId, Refund._path], _getMap());
    return new Refund.fromMap(dataMap);
  }
}

/// [Update a refund](https://stripe.com/docs/api#update_refund)
class RefundUpdate extends ResourceRequest {
  set metadata(Map metadata) => _setMap('metadata', metadata);

  Future<Refund> update(String chargeId, String refundId) async {
    var dataMap = await StripeService.update([Charge._path, chargeId, Refund._path, refundId], _getMap());
    return new Refund.fromMap(dataMap);
  }
}

class RefundCollection extends ResourceCollection {
  Refund _getInstanceFromMap(map) => new Refund.fromMap(map);

  RefundCollection.fromMap(Map map) : super.fromMap(map);
}
