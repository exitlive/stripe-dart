part of stripe;

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
 * STUB.
 * TODO: Complete this class.
 */
class CardCreation extends ResourceRequest {

  @required
  set number (String number) => _setMap("number", number);

  Future<Card> create() {
    return StripeService.create(Card._path, _getMap())
      .then((Map json) => new Card.fromMap(json));
  }

}
