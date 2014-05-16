part of stripe;


/**
 * [Balance](https://stripe.com/docs/api/curl#balance)
 */
class Balance extends Resource {

  String get id => _dataMap['id'];

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


class Fund {

  Map _dataMap;

  int get amount => _dataMap['amount'];

  String get currency => _dataMap['currency'];

  Fund.fromMap(this._dataMap);

}