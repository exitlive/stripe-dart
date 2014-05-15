part of stripe;

/**
 * You can store multiple credit cards for a customer in order to charge the
 * customer later.
 */
class Card extends Resource {

  final String objectName = "card";

  static String _path = "cards";


  Card.fromMap(Map map) : super.fromMap(map) {

  }

  int get expMonth => _dataMap["exp_month"];

  int get expYear => _dataMap["exp_year"];

  String get last4 => _dataMap["last4"];

  String get country => _dataMap["country"];

  String get type => _dataMap["type"];

  String get name => _dataMap["name"];

  String get id => _dataMap["id"];

  String get customer => _dataMap["customer"];

  String get addressLine1 => _dataMap["address_line1"];

  String get addressLine2 => _dataMap["address_line2"];

  String get addressZip => _dataMap["address_zip"];

  String get addressCity => _dataMap["address_city"];

  String get addressState => _dataMap["address_state"];

  String get addressCountry => _dataMap["address_country"];

  String get addressZipCheck => _dataMap["address_zip_check"];

  String get addressLine1Check => _dataMap["address_line1_check"];

  String get cvcCheck => _dataMap["cvc_check"];

  String get fingerprint => _dataMap["fingerprint"];

}



/**
 * Used to create a [Card]
 */
class CardCreation extends ResourceRequest {

  @required
  set number (String number) => _setMap("number", number);

  @required
  set expMonth (int expMonth) => _setMap("exp_month", expMonth);

  @required
  set expYear (int expYear) => _setMap("exp_year", expYear);

  set cvc (int cvc) => _setMap("cvc", cvc);

  set name (String name) => _setMap("name", name);

  set addressLine1 (String addressLine1) => _setMap("address_line1", addressLine1);

  set addressLine2 (String addressLine2) => _setMap("address_line2", addressLine2);

  set addressCity (String addressCity) => _setMap("address_city", addressCity);

  set addressZip (String addressZip) => _setMap("address_zip", addressZip);

  set addressState (String addressState) => _setMap("address_state", addressState);

  set addressCountry (String addressCountry) => _setMap("address_country", addressCountry);

  Future<Card> create(String customerId) {
    return StripeService.create("${Customer._path}/${customerId}/${Card._path}", {"card": _getMap()})
      .then((Map json) => new Card.fromMap(json));
  }

}

/**
 * Used to create a [Card] with a token
 */
class CardCreationWithToken extends ResourceRequest {

  @required
  set token (String token) => _setMap("card", token);

  Future<Card> create(String customerId) {
    return StripeService.create("${Customer._path}/${customerId}/${Card._path}", _getMap())
      .then((Map json) => new Card.fromMap(json));
  }

}


/**
 * Used to update an existing [Card].
 */
class CardUpdate extends ResourceRequest {

  set expMonth (int expMonth) => _setMap("exp_month", expMonth);

  set expYear (int expYear) => _setMap("exp_year", expYear);

  set name (String name) => _setMap("name", name);

  set addressLine1 (String addressLine1) => _setMap("address_line1", addressLine1);

  set addressLine2 (String addressLine2) => _setMap("address_line2", addressLine2);

  set addressCity (String addressCity) => _setMap("address_city", addressCity);

  set addressZip (String addressZip) => _setMap("address_zip", addressZip);

  set addressState (String addressState) => _setMap("address_state", addressState);

  set addressCountry (String addressCountry) => _setMap("address_country", addressCountry);

  // TODO: needs to be changed to use StripeService.update()
  Future<Card> update() {
    return StripeService.create(Card._path, _getMap())
          .then((Map json) => new Card.fromMap(json));
  }

}
