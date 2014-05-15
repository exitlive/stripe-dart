part of stripe;


class InvoiceLineItem extends Resource {


  /// The ID of the source of this line item, either an invoice item
  /// or a subscription
  String get id => _dataMap["id"];

  String objectName = "line_item";

  static String _path = "lines";

  /// Whether or not this is a test line item
  bool get livemode => _dataMap["livemode"];

  /// The amount, in cents
  int get amount => _dataMap["amount"];

  String get currency =>_dataMap["currency"];

  /// The period this line_item covers
  Period get period => new Period.fromMap(_dataMap["period"]);

  /// Whether or not this is a proration
  bool get proration => _dataMap["proration"];

  /// A string identifying the type of the source of this line item,
  /// either an invoice item or a subscription
  String get type => _dataMap["type"];


  /// A text description of the line item, if the line item is an invoice item
  String get description => _dataMap["description"];

  /// Key-value pairs attached to the line item, if the line item is an
  /// invoice item
  Map<String, String> get metadata => _dataMap["metadata"];

  /// The plan of the subscription, if the line item is a subscription
  Plan get plan => new Plan.fromMap(_dataMap["plan"]);

  /// The quantity of the subscription, if the line item is a subscription
  int get quantity => _dataMap["quantity"];


  InvoiceLineItem.fromMap(Map dataMap) : super.fromMap(dataMap);




}


class Period {

  Map _dataMap;

  int get start => _dataMap["start"];

  int get end => _dataMap["end"];

  Period.fromMap(this._dataMap);

}