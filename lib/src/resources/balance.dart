part of stripe;

/**
 * This is an object representing your Stripe balance.
 * You can retrieve it to see the balance currently on your Stripe account.
 *
 * You can also retrieve a list of the balance history, which contains a full
 * list of transactions that have ever contributed to the balance
 * (charges, refunds, transfers, and so on).
 *
 * Note: this API is experimental, so the endpoints and response spec may change.
 */
class Balance extends Resource {

  String get id => _dataMap["id"];

  String objectName = "balance";

  static String _path = "balance";

  bool get livemode => _dataMap["livemode"];

  /// Funds that are available to be paid out automatically by Stripe or
  /// explicitly via the transfers API.
  List<Fund> get available {
    List funds = _dataMap["available"];
    assert(funds != null);
    return funds.map((Map fund) => new Fund.fromMap(fund)).toList(growable: false);
  }

  /// Funds that are not available in the balance yet,
  /// due to the 7-day rolling pay cycle.
  List<Fund> get pending {
    List funds = _dataMap["pending"];
    assert(funds != null);
    return funds.map((Map fund) => new Fund.fromMap(fund)).toList(growable: false);
  }

  Balance.fromMap(Map dataMap) : super.fromMap(dataMap);

  /**
   * Retrieves the current account balance, based on the API key that was used
   * to make the request.
   */
  static Future<Balance> retrieve() {
    return StripeService.get(Balance._path)
        .then((Map json) => new Balance.fromMap(json));
  }


}


class Fund {

  Map _dataMap;

  /// The amount in cents
  int get amount => _dataMap["amount"];

  /// 3-letter ISO code for currency.
  String get currency => _dataMap["currency"];

  Fund.fromMap(this._dataMap);

}