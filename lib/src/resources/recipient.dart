part of stripe;


/**
 * [Recipient](https://stripe.com/docs/api/curl#create_recipient)
 */
class Recipient extends Resource {

  String get id => _dataMap['id'];

  String objectName = 'recipient';

  static String _path = 'recipients';

  bool get livemode => _dataMap['livemode'];

  DateTime get created => _getDateTimeFromMap('created');

  String get type => _dataMap['type'];

  BankAccount get activeAccount {
    var value = _dataMap['active_account'];
    if (value == null) return null;
    else return new BankAccount.fromMap(value);
  }

  String get description => _dataMap['description'];

  String get email => _dataMap['email'];

  Map<String, String> get metadata => _dataMap['metadata'];

  String get name => _dataMap['name'];

  bool get verified => _dataMap['verified'];

  Recipient.fromMap(Map dataMap) : super.fromMap(dataMap);

  /**
   * [Retrieving a Recipient](https://stripe.com/docs/api/curl#retrieve_recipient)
   */
  static Future<Recipient> retrieve(String recipientId) {
    return StripeService.get([Recipient._path, recipientId])
        .then((Map json) => new Recipient.fromMap(json));
  }

  /**
   * [List all Recipients](https://stripe.com/docs/api/curl#list_recipients)
   */
  static Future<RecipientCollection> list({int limit, String startingAfter, String endingBefore, bool verified}) {
    Map data = {};
    if (limit != null) data['limit'] = limit;
    if (startingAfter != null) data['starting_after'] = startingAfter;
    if (endingBefore != null) data['ending_before'] = endingBefore;
    if (verified != null) data['verified'] = verified;
    if (data == {}) data = null;
    return StripeService.list([Recipient._path], data: data)
        .then((Map json) => new RecipientCollection.fromMap(json));
  }

  /**
   * [Deleting a Recipient](https://stripe.com/docs/api/curl#delete_recipient)
   */
  static Future delete(String recipientId) => StripeService.delete([Recipient._path, recipientId]);

}


class RecipientCollection extends ResourceCollection {

  Recipient _getInstanceFromMap(map) => new Recipient.fromMap(map);

  RecipientCollection.fromMap(Map map) : super.fromMap(map);

}


/**
 * [Creating a New Recipient](https://stripe.com/docs/api/curl#create_recipient)
 */
class RecipientCreation extends ResourceRequest {

  @required
  set name (String name) => _setMap('name', name);

  @required
  set type (String type) => _setMap('type', type);

  set taxId (String taxId) => _setMap('tax_id', taxId);

  set bankAccount (BankAccountRequest bankAccount) => _setMap('bank_account', bankAccount);

  set email (String email) => _setMap('email', email);

  set description (String description) => _setMap('description', description);

  set metadata (Map metadata) => _setMap('metadata', metadata);

  Future<Recipient> create() {
    return StripeService.create([Recipient._path], _getMap())
      .then((Map json) => new Recipient.fromMap(json));
  }

}


/**
 * [Updating a recipient](https://stripe.com/docs/api/curl#update_recipient)
 */
class RecipientUpdate extends ResourceRequest {

  set name (String name) => _setMap('name', name);

  set taxId (String taxId) => _setMap('tax_id', taxId);

  set bankAccount (BankAccountRequest bankAccount) => _setMap('bank_account', bankAccount);

  set email (String email) => _setMap('email', email);

  set description (String description) => _setMap('description', description);

  set metadata (Map metadata) => _setMap('metadata', metadata);

  Future<Recipient> update(String id) {
    return StripeService.update([Recipient._path, id], _getMap())
      .then((Map json) => new Recipient.fromMap(json));
  }

}


class BankAccount extends Resource {

  String get id => _dataMap['id'];

  String objectName = 'bank_account';

  String get bankName => _dataMap['bank_name'];

  String get country => _dataMap['country'];

  String get currency => _dataMap['currency'];

  String get last4 => _dataMap['last4'];

  bool get disabled => _dataMap['disabled'];

  String get fingerprint => _dataMap['fingerprint'];

  bool get validated => _dataMap['validated'];

  BankAccount.fromMap(Map dataMap) : super.fromMap(dataMap);

}


class BankAccountRequest extends ResourceRequest {

  set country (String country) => _setMap('country', country);

  set routingNumber (String routingNumber) => _setMap('routing_number', routingNumber);

  set accountNumber (String accountNumber) => _setMap('account_number', accountNumber);

}