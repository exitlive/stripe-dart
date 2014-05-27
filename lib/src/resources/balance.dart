part of stripe;


/**
 * [Balance](https://stripe.com/docs/api/curl#balance)
 */
class Balance extends Resource {

  String objectName = 'balance';

  static String _path = 'balance';

  bool get livemode => _dataMap['livemode'];

  List<Fund> get available {
    List funds = _dataMap['available'];
    assert(funds != null);
    return funds.map((Map fund) => new Fund.fromMap(fund)).toList(growable: false);
  }

  List<Fund> get pending {
    List funds = _dataMap['pending'];
    assert(funds != null);
    return funds.map((Map fund) => new Fund.fromMap(fund)).toList(growable: false);
  }

  Balance.fromMap(Map dataMap) : super.fromMap(dataMap);

  /**
   * [Retrieve a balance](https://stripe.com/docs/api/curl#retrieve_balance)
   */
  static Future<Balance> retrieve() {
    return StripeService.get([Balance._path])
        .then((Map json) => new Balance.fromMap(json));
  }

}


class BalanceTransaction extends Resource {

  String get id => _dataMap['id'];

  String objectName = 'balance_transaction';

  static String _path = 'history';

  int get amount => _dataMap['amount'];

  DateTime get availableOn => _getDateTimeFromMap('available_on');

  DateTime get created => _getDateTimeFromMap('created');

  String get currency => _dataMap['currency'];

  int get fee => _dataMap['fee'];

  List<FeeDetails> get feeDetails {
    List feeDetails = _dataMap['fee_details'];
    assert(feeDetails != null);
    return feeDetails.map((Map feeDetails) => new FeeDetails.fromMap(feeDetails)).toList(growable: false);
  }

  int get net => _dataMap['net'];

  String get status => _dataMap['status'];

  String get type => _dataMap['type'];

  String get description => _dataMap['description'];

  String get source {
    var value = _dataMap['source'];
    if (value == null) return null;
    else if(value is String) return value;
    else return new Charge.fromMap(value).id;
  }

  Charge get sourceExpand {
    var value = _dataMap['source'];
    if (value == null) return null;
    else return new Charge.fromMap(value);
  }

  String get recipient {
    var value = _dataMap['recipient'];
    if (value == null) return null;
    else if(value is String) return value;
    else return new Recipient.fromMap(value).id;
  }

  Recipient get recipientExpand {
    var value = _dataMap['recipient'];
    if (value == null) return null;
    else return new Recipient.fromMap(value);
  }

  BalanceTransaction.fromMap(Map dataMap) : super.fromMap(dataMap);

  /**
   * [Retrieving a Balance Transaction](https://stripe.com/docs/api/curl#retrieve_balance_transaction)
   */
  static Future<BalanceTransaction> retrieve() {
    return StripeService.get([BalanceTransaction._path])
        .then((Map json) => new BalanceTransaction.fromMap(json));
  }

  /**
   * [Listing balance history](https://stripe.com/docs/api/curl#balance_history)
   */
  // TODO: implement missing arguments
  static Future<BalanceTransactionCollection> list({int limit, String startingAfter, String endingBefore}) {
    Map data = {};
    if (limit != null) data['limit'] = limit;
    if (startingAfter != null) data['starting_after'] = startingAfter;
    if (endingBefore != null) data['ending_before'] = endingBefore;
    if (data == {}) data = null;
    return StripeService.list([Balance._path, BalanceTransaction._path], data: data)
        .then((Map json) => new BalanceTransactionCollection.fromMap(json));
  }

}


class BalanceTransactionCollection extends ResourceCollection {

  Card _getInstanceFromMap(map) => new Card.fromMap(map);

  BalanceTransactionCollection.fromMap(Map map) : super.fromMap(map);

}


class Fund {

  Map _dataMap;

  int get amount => _dataMap['amount'];

  String get currency => _dataMap['currency'];

  Fund.fromMap(this._dataMap);

}


class FeeDetails {

  Map _dataMap;

  int get amount => _dataMap['amount'];

  String get currency => _dataMap['currency'];

  String get type => _dataMap['type'];

  String get application => _dataMap['application'];

  String get description => _dataMap['description'];

  FeeDetails.fromMap(this._dataMap);

}