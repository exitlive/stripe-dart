part of stripe;

/**
 * Refunds can't be created by the library.
 *
 * If you want to create a refund, use [Charge.refund].
 */
class Refund extends Resource {

  String get id => _dataMap["id"];

  String objectName = "refund";

  /// Amount refunded, in cents.
  int get amount => _dataMap["amount"];

  DateTime get created => _getDateTimeFromMap("created");

  /// Three-letter ISO code representing the currency of the refund.
  String get currency => _dataMap["currency"];

  /// Balance transaction that describes the impact of this refund on your
  /// account balance.
  String get balanceTransaction {
    var value = _dataMap["balance_transaction"];
    if (value == null) return null;
    else if(value is String) return value;
    else return new Balance.fromMap(value).id;
  }

  /// [Balance] transaction that describes the impact of this refund on your
  /// account balance.
  /// This will return null if you call retrieve without expanding.
  Balance get balanceTransactionExpand {
    var value = _dataMap["balance_transaction"];
    if (value == null) return null;
    else return new Balance.fromMap(value);
  }

  Refund.fromMap(Map dataMap) : super.fromMap(dataMap);

}