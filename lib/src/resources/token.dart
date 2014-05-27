part of stripe;


/**
 * [Tokens](https://stripe.com/docs/api/curl#tokens)
 */
class Token extends ApiResource {

  String get id => _dataMap['id'];

  final String objectName = 'token';

  static String _path = 'tokens';

  bool get livemode => _dataMap['livemode'];

  DateTime get created => _getDateTimeFromMap('created');

  String get type => _dataMap['type'];

  bool get used => _dataMap['used'];

  BankAccount get bankAccount {
    var value = _dataMap['bank_account'];
    if (value == null) return null;
    else return new BankAccount.fromMap(value);
  }

  Card get card {
    var value = _dataMap['card'];
    if (value == null) return null;
    else return new Card.fromMap(value);
  }

  Token.fromMap(Map dataMap) : super.fromMap(dataMap);

  /**
   * [Retrieving a Token](https://stripe.com/docs/api/curl#retrieve_token)
   */
  static Future<Token> retrieve(String tokenId) {
    return StripeService.retrieve([Token._path, tokenId])
        .then((Map json) => new Token.fromMap(json));
  }

}


/**
 * [Creating a Card Token](https://stripe.com/docs/api/curl#create_card_token)
 */
class CardTokenCreation extends ResourceRequest {

  set card (CardCreation card) => _setMap('card', card);

  set customer (CustomerCreation customer) => _setMap('customer', customer);

  Future<Token> create() {
    return StripeService.create([Token._path], _getMap())
        .then((Map json) => new Token.fromMap(json));
  }

}


/**
 * [Creating a Bank Account Token](https://stripe.com/docs/api/curl#create_bank_account_token)
 */
class BankAccountTokenCreation extends ResourceRequest {

  set bankAccount (BankAccountRequest bankAccount) => _setMap('bank_account', bankAccount);

  Future<Token> create() {
    return StripeService.create([Token._path], _getMap())
        .then((Map json) => new Token.fromMap(json));
  }

}