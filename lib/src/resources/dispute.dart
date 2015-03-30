part of stripe;


/**
 * [Disputes](https://stripe.com/docs/api/curl#disputes)
 */
class Dispute extends Resource {

  final String objectName = 'dispute';

  static String _path = 'dispute';

  bool get livemode => _dataMap['livemode'];

  int get amount => _dataMap['amount'];

  String get charge {
    var value = _dataMap['charge'];
    if (value == null) return null;
    else if(value is String) return _dataMap['charge'];
    else return new Charge.fromMap(value).id;
  }

  Charge get ChargeExpand {
    var value = _dataMap['charge'];
    if (value == null) return null;
    else return new Charge.fromMap(value);
  }

  DateTime get created => _getDateTimeFromMap('created');

  String get currency => _dataMap['currency'];

  String get reason => _dataMap['reason'];

  String get status => _dataMap['status'];

  String get balanceTransaction {
    var value = _dataMap['balance_transaction'];
    if (value == null) return null;
    else if(value is String) return _dataMap['balance_transaction'];
    else return new BalanceTransaction.fromMap(value).id;
  }

  BalanceTransaction get balanceTransactionExpand {
    var value = _dataMap['balance_transaction'];
    if (value == null) return null;
    else return new BalanceTransaction.fromMap(value);
  }

  String get evidence => _dataMap['evidence'];

  DateTime get evidenceDueBy => _getDateTimeFromMap('evidence_due_by');

  bool get isProtected => _dataMap['is_protected'];

  Dispute.fromMap(Map dataMap) : super.fromMap(dataMap);

  /**
   * [Closing a dispute](https://stripe.com/docs/api/curl#close_dispute)
   */
  static Future close(String chargeId) => StripeService.post([Charge._path, chargeId, Dispute._path, 'close']);

}


/**
 * [Updating a dispute](https://stripe.com/docs/api/curl#update_dispute)
 */
class DisputeUpdate extends ResourceRequest {

  set evidence (String evidence) => _setMap('evidence', evidence);

  Future<Customer> update(String chargeId) async {
    var dataMap = await StripeService.update([Charge._path, chargeId, Dispute._path], _getMap());
    return new Customer.fromMap(dataMap);
  }

}