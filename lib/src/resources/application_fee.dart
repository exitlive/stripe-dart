part of stripe;


/**
 * [Application Fees](https://stripe.com/docs/api/curl#application_fees)
 */
class ApplicationFee extends Resource {

  String get id => _dataMap['id'];

  String objectName = 'application_fee';

  static String _path = 'application_fees';

  bool get livemode => _dataMap['livemode'];

  String get account {
    var value = _dataMap['account'];
    if (value == null) return null;
    else if(value is String) return value;
    else return new Account.fromMap(value).id;
  }

  Account get accountExpand {
    var value = _dataMap['account'];
    if (value == null) return null;
    else return new Account.fromMap(value);
  }

  int get amount => _dataMap['amount'];

  String get application => _dataMap['application'];

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

  String get charge {
    var value = _dataMap['charge'];
    if (value == null) return null;
    else if(value is String) return value;
    else return new Charge.fromMap(value).id;
  }

  Charge get chargeExpand {
    var value = _dataMap['charge'];
    if (value == null) return null;
    else return new Charge.fromMap(value);
  }

  DateTime get created => _getDateTimeFromMap('created');

  String get currency => _dataMap['currency'];

  bool get refunded => _dataMap['refunded'];

  List<Refund> get refunds {
    List refundMaps = _dataMap['refunds'];
    assert(refundMaps != null);
    return refundMaps.map((Map refund) => new Refund.fromMap(refund)).toList(growable: false);
  }

  int get amountRefunded => _dataMap['amount_refunded'];

  ApplicationFee.fromMap(Map dataMap) : super.fromMap(dataMap);

  /**
   * [Retrieving an Application Fee](https://stripe.com/docs/api/curl#retrieve_application_fee)
   */
  static Future<ApplicationFee> retrieve(String applicationFeeId) {
    return StripeService.get([ApplicationFee._path, applicationFeeId])
        .then((Map json) => new ApplicationFee.fromMap(json));
  }


  /**
   * [Refunding an Application Fee](https://stripe.com/docs/api/curl#refund_application_fee)
   */
  static Future<ApplicationFee> refund(String applicationFeeId, {int amount}) {
    Map data = {};
    if (amount != null) data['amount'] = amount;
    if (data == {}) data = null;
    return StripeService.post([ApplicationFee._path, applicationFeeId, 'refund'], data: data)
        .then((Map json) => new ApplicationFee.fromMap(json));
  }

  /**
   * [List all Application Fees](https://stripe.com/docs/api/curl#list_application_fees)
   */
  // TODO: implement missing arguments
  static Future<ApplicationFeeCollection> list({String charge, int limit, String startingAfter, String endingBefore}) {
    Map data = {};
    if (charge != null) data['charge'] = charge;
    if (limit != null) data['limit'] = limit;
    if (startingAfter != null) data['starting_after'] = startingAfter;
    if (endingBefore != null) data['ending_before'] = endingBefore;
    if (data == {}) data = null;
    return StripeService.list([ApplicationFee._path], data: data)
        .then((Map json) => new ApplicationFeeCollection.fromMap(json));
  }

}


class ApplicationFeeCollection extends ResourceCollection {

  ApplicationFee _getInstanceFromMap(map) => new ApplicationFee.fromMap(map);

  ApplicationFeeCollection.fromMap(Map map) : super.fromMap(map);

}


