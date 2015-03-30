part of stripe;


/**
 * [Customers](https://stripe.com/docs/api/curl#customers)
 */
class Customer extends ApiResource {

  String get id => _dataMap['id'];

  final String objectName = 'customer';

  static String _path = 'customers';

  DateTime get created => _getDateTimeFromMap('created');

  bool get livemode => _dataMap['livemode'];

  int get accountBalance => _dataMap['account_balance'];

  String get currency => _dataMap['currency'];

  String get defaultCard {
    var value = _dataMap['default_card'];
    if (value == null) return null;
    else if(value is String) return value;
    else return new Card.fromMap(value).id;
  }

  Card get defaultCardExpand {
    var value = _dataMap['default_card'];
    if (value == null) return null;
    else return new Card.fromMap(value);
  }

  bool get delinquent => _dataMap['delinquent'];

  String get description => _dataMap['description'];

  Discount get discount {
    var value = _dataMap['discount'];
    if (value == null) return null;
    else return new Discount.fromMap(value);
  }

  String get email => _dataMap['email'];

  Map<String, String> get metadata => _dataMap['metadata'];

  SubscriptionCollection get subscriptions {
    var value = _dataMap['subscriptions'];
    if (value == null) return null;
    else return new SubscriptionCollection.fromMap(value);
  }

  CardCollection get cards {
    var value = _dataMap['cards'];
    if (value == null) return null;
    else return new CardCollection.fromMap(value);
  }

  Customer.fromMap(Map dataMap) : super.fromMap(dataMap);

  /**
   * [Retrieving a Customer](https://stripe.com/docs/api/curl#retrieve_customer)
   */
  static Future<Customer> retrieve(String id, {final Map data}) async {
    var dataMap = await StripeService.retrieve([Customer._path, id], data: data);
    return new Customer.fromMap(dataMap);
  }

  /**
   * [List all Customers](https://stripe.com/docs/api/curl#list_customers)
   * TODO: implement missing argument: `created`
   */
  static Future<CustomerCollection> list({int limit, String startingAfter, String endingBefore}) async {
    Map data = {};
    if (limit != null) data['limit'] = limit;
    if (startingAfter != null) data['starting_after'] = startingAfter;
    if (endingBefore != null) data['ending_before'] = endingBefore;
    if (data == {}) data = null;
    var dataMap = await StripeService.list([Customer._path], data: data);
    return new CustomerCollection.fromMap(dataMap);
  }

  /**
   * [Deleting a Customer](https://stripe.com/docs/api/curl#delete_customer)
   */
  static Future delete(String id) => StripeService.delete([Customer._path, id]);

}


class CustomerCollection extends ResourceCollection {

  Customer _getInstanceFromMap(map) => new Customer.fromMap(map);

  CustomerCollection.fromMap(Map map) : super.fromMap(map);

}


/**
 * [Creating a New Customer](https://stripe.com/docs/api/curl#create_customer)
 */
class CustomerCreation extends ResourceRequest {

  set accountBalance (int accountBalance) => _setMap('account_balance', accountBalance);

  set card (CardCreation card) => _setMap('card', card);

  set coupon (String coupon) => _setMap('coupon', coupon);

  set description (String description) => _setMap('description', description);

  set email (String email) => _setMap('email', email);

  set metadata (Map metadata) => _setMap('metadata', metadata);

  set plan (String plan) => _setMap('plan', plan);

  set quantity (int quantity) => _setMap('quantity', quantity);

  set trialEnd (int trialEnd) => _setMap('trial_end', trialEnd);

  trialEndNow() => _setMap('trial_end', 'now');

  Future<Customer> create() async {
    var dataMap = await StripeService.create([Customer._path], _getMap());
    return new Customer.fromMap(dataMap);
  }

}


/**
 * [Updating a Customer](https://stripe.com/docs/api/curl#update_customer)
 */
class CustomerUpdate extends ResourceRequest {

  set accountBalance (int accountBalance) => _setMap('account_balance', accountBalance);

  set card (CardCreation card) => _setMap('card', card);

  set coupon (String coupon) => _setMap('coupon', coupon);

  set defaultCard (String defaultCard) => _setMap('default_card', defaultCard);

  set description (String description) => _setMap('description', description);

  set email (String email) => _setMap('email', email);

  set metadata (Map metadata) => _setMap('metadata', metadata);

  Future<Customer> update(String id) async {
    var dataMap = await StripeService.update([Customer._path, id], _getMap());
    return new Customer.fromMap(dataMap);
  }

}