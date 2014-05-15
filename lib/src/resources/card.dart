part of stripe;

/**
 * You can store multiple credit cards for a customer in order to charge the
 * customer later.
 */
class Card extends Resource {

  /// ID of card (used in conjunction with a customer ID)
  String get id => _dataMap["id"];

  final String objectName = "card";

  static String _path = "cards";


  Card.fromMap(Map dataMap) : super.fromMap(dataMap);

  int get expMonth => _dataMap["exp_month"];

  int get expYear => _dataMap["exp_year"];

  /// Uniquely identifies this particular card number. You can use this
  /// attribute to check whether two customers who’ve signed up with you are
  /// using the same card number, for example.
  String get fingerprint => _dataMap["fingerprint"];

  String get last4 => _dataMap["last4"];

  /// Card brand. Can be Visa, American Express, MasterCard, Discover, JCB,
  /// Diners Club, or Unknown.
  String get type => _dataMap["type"];

  String get addressCity => _dataMap["address_city"];

  /// Billing address country, if provided when creating card
  String get addressCountry => _dataMap["address_country"];

  String get addressLine1 => _dataMap["address_line1"];

  /// If address_line1 was provided, results of the check: pass, fail,
  /// or unchecked.
  String get addressLine1Check => _dataMap["address_line1_check"];

  String get addressLine2 => _dataMap["address_line2"];

  String get addressState => _dataMap["address_state"];

  String get addressZip => _dataMap["address_zip"];

  /// If address_zip was provided, results of the check: pass, fail,
  /// or unchecked.
  String get addressZipCheck => _dataMap["address_zip_check"];

  String get country => _dataMap["country"];

  /// ID of the customer this card belongs to
  String get customer {
    var value = _dataMap["customer"];
    if (value == null) return null;
    else if(value is String) return value;
    else return new Customer.fromMap(value).id;
  }

  /// [Customer] object this card belongs to
  /// This will return null if you call retrieve without expanding.
  Customer get customerExpand {
    var value = _dataMap["customer"];
    if (value == null) return null;
    else return new Customer.fromMap(value);
  }

  /// If a CVC was provided, results of the check: pass, fail, or unchecked
  String get cvcCheck => _dataMap["cvc_check"];

  /// Cardholder name
  String get name => _dataMap["name"];



  /**
   * By default, you can see the 10 most recent cards stored on a customer
   * directly on the customer object, but you can also retrieve details about a
   * specific card stored on the customer.
   */
  static Future<Card> retrieve(String customerId, String cardId, {final Map data}) {
    return StripeService.retrieve([Customer._path, customerId, Card._path, cardId], data: data)
        .then((Map json) => new Card.fromMap(json));
  }

  /**
   * Retrieves a [CardCollection] of the cards for the customer with the
   * specified customerId.
   *
   * You can see a list of the customer's cards. Note that the 10 most recent
   * cards are always available by default on the customer object. If you need
   * more than those 10, you can use the limit and starting_after parameters to
   * page through additional cards.
   */
  static Future<CardCollection> list(String customerId, {int limit, String startingAfter, String endingBefore}) {
    Map data = {};
    if (limit != null) data["limit"] = limit;
    if (startingAfter != null) data["starting_after"] = startingAfter;
    if (endingBefore != null) data["ending_before"] = endingBefore;
    if (data == {}) data = null;
    return StripeService.list([Customer._path, customerId, Card._path], data: data)
        .then((Map json) => new CardCollection.fromMap(json));
  }

  /**
   * You can delete cards from a customer. If you delete a card that is
   * currently a customer's default, the most recently added card will be used
   * as the new default. If you delete the customer's last remaining card,
   * the default_card attribute on the customer will become null.
   *
   * Note that you may want to prevent customers on paid subscriptions from
   * deleting all cards on file so that there is at least one default card for
   * the next invoice payment attempt.
   */
  static Future delete(String customerId, String cardId) => StripeService.delete([Customer._path, customerId, Card._path, cardId]);

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
    return StripeService.create([Customer._path, customerId, Card._path], {"card": _getMap()})
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
    return StripeService.create([Customer._path, customerId, Card._path], _getMap())
      .then((Map json) => new Card.fromMap(json));
  }

}


/**
 * Used to update an existing [Card].
 */
class CardUpdate extends ResourceRequest {

  set addressCity (String addressCity) => _setMap("address_city", addressCity);

  set addressCountry (String addressCountry) => _setMap("address_country", addressCountry);

  set addressLine1 (String addressLine1) => _setMap("address_line1", addressLine1);

  set addressLine2 (String addressLine2) => _setMap("address_line2", addressLine2);

  set addressState (String addressState) => _setMap("address_state", addressState);

  set addressZip (String addressZip) => _setMap("address_zip", addressZip);

  set expMonth (int expMonth) => _setMap("exp_month", expMonth);

  set expYear (int expYear) => _setMap("exp_year", expYear);

  set name (String name) => _setMap("name", name);


  Future<Card> update(String customerId, String cardId) {
    return StripeService.update([Customer._path, customerId, Card._path, cardId], _getMap())
          .then((Map json) => new Card.fromMap(json));
  }

}
