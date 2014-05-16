part of stripe;


class Refund extends Resource {

  String get id => _dataMap['id'];

  String objectName = 'refund';

  int get amount => _dataMap['amount'];

  DateTime get created => _getDateTimeFromMap('created');

  String get currency => _dataMap['currency'];

  String get balanceTransaction {
    var value = _dataMap['balance_transaction'];
    if (value == null) return null;
    else if(value is String) return value;
    else return new Balance.fromMap(value).id;
  }

  Balance get balanceTransactionExpand {
    var value = _dataMap['balance_transaction'];
    if (value == null) return null;
    else return new Balance.fromMap(value);
  }

  Refund.fromMap(Map dataMap) : super.fromMap(dataMap);

}