part of stripe;

/**
 * To charge a credit or a debit card, you create a new charge object.
 *
 * You can retrieve and refund individual charges as well as list all charges.
 *
 * Charges are identified by a unique random ID.
 */
class Charge extends Resource {

  String objectName = "charge";

  static String _path = "charges";


  Charge.fromMap(Map dataMap) : super.fromMap(dataMap);

  String get id => _dataMap["id"];

  DateTime get created => _getDateTimeFromMap("created");

  bool get livemode => _dataMap["livemode"];

  bool get paid => _dataMap["paid"];

  int get amount => _dataMap["amount"];

  String get currency => _dataMap["currency"];

  bool get refunded => _dataMap["refunded"];

  String get customer => _dataMap["customer"];

  Card get card {
    var value = _dataMap["card"];
    if (value == null) return null;
    else return new Card.fromMap(value);
  }

  String get description => _dataMap["description"];

  Map<String, String> get metadata => _dataMap["metadata"];

  String get statement_description => _dataMap["statement_description"];

  bool get disputed => _dataMap["disputed"];

  bool get captured => _dataMap["captured"];

  String get failureMessage => _dataMap["failureMessage"];

  String get failureCode => _dataMap["failureCode"];

  int get amountRefunded => _dataMap["amountRefunded"];

  String get invoice => _dataMap["invoice"];

  List<Refund> get refunds {
    List refundMaps = _dataMap["refunds"];
    assert(refundMaps != null);
    return refundMaps.map((Map refund) => new Refund.fromMap(refund)).toList(growable: false);
  }

  Dispute get dispute {
    var value = _dataMap["dispute"];
    if (value == null) return null;
    else return new Dispute.fromMap(value);
  }

  String get balanceTransaction => _dataMap["balanceTransaction"];

  static Future<Charge> retrieve(String id) {
    return StripeService.retrieve(Charge._path, id)
        .then((Map json) => new Charge.fromMap(json));
  }

}



/**
 * Used to create [Charge]
 */
class ChargeCreation extends ResourceRequest {

  @required
  set amount (int amount) => _setMap("amount", amount);

  @required
  set currency (String currency) => _setMap("currency", currency);

  set customer (String customer) => _setMap("customer", customer);

  set card (CardCreation card) => _setMap("card", card._getMap());

  set description (String description) => _setMap("description", description);

  set metadata (Map metadata) => _setMap("metadata", metadata);

  set capture (bool capture) => _setMap("capture", capture);

  set statementDescription (String statementDescription) => _setMap("statement_description", statementDescription);

  set applicationFee (int applicationFee) => _setMap("application_fee", applicationFee);


  Future<Card> create() {
    return StripeService.create(Card._path, _getMap())
      .then((Map json) => new Card.fromMap(json));
  }

}

/**
 * Used to update a [Charge]
 */
class ChargeUpdate extends ResourceRequest {

  set description (int description) => _setMap("description", description);

  set metadata (Map metadata) => _setMap("metadata", metadata);


  Future<Charge> update(String chargeId) {
    return StripeService.update(Charge._path, chargeId, _getMap())
          .then((Map json) => new Charge.fromMap(json));
  }

}
