part of stripe;


/**
 * [The invoice_line_item object](https://stripe.com/docs/api/curl#invoice_line_item_object)
 */
class InvoiceLineItem extends Resource {

  String get id => _dataMap['id'];

  String objectName = 'line_item';

  static String _path = 'lines';

  bool get livemode => _dataMap['livemode'];

  int get amount => _dataMap['amount'];

  String get currency =>_dataMap['currency'];

  Period get period => new Period.fromMap(_dataMap['period']);

  bool get proration => _dataMap['proration'];

  String get type => _dataMap['type'];

  String get description => _dataMap['description'];

  Map<String, String> get metadata => _dataMap['metadata'];

  Plan get plan => new Plan.fromMap(_dataMap['plan']);

  int get quantity => _dataMap['quantity'];

  InvoiceLineItem.fromMap(Map dataMap) : super.fromMap(dataMap);

}


class Period {

  Map _dataMap;

  int get start => _dataMap['start'];

  int get end => _dataMap['end'];

  Period.fromMap(this._dataMap);

}