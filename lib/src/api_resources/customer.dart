part of stripe;

/// [Customers](https://stripe.com/docs/api#customers)
class Customer extends ApiResource {
  String get id => _dataMap['id'];

  final String object = 'customer';

  static var _path = 'customers';

  bool get livemode => _dataMap['livemode'];

  DateTime get created => _getDateTimeFromMap('created');

  int get accountBalance => _dataMap['account_balance'];

  String get currency => _dataMap['currency'];

  String get defaultSource {
    return this._getIdForExpandable('default_source');
  }

  Card get defaultSourceExpand {
    var value = _dataMap['default_source'];
    if (value == null)
      return null;
    else
      return new Card.fromMap(value);
  }

  bool get delinquent => _dataMap['delinquent'];

  String get description => _dataMap['description'];

  Discount get discount {
    var value = _dataMap['discount'];
    if (value == null)
      return null;
    else
      return new Discount.fromMap(value);
  }

  String get email => _dataMap['email'];

  Map<String, String> get metadata => _dataMap['metadata'];

  CardCollection get sources {
    var value = _dataMap['sources'];
    if (value == null)
      return null;
    else
      return new CardCollection.fromMap(value);
  }

  SubscriptionCollection get subscriptions {
    var value = _dataMap['subscriptions'];
    if (value == null)
      return null;
    else
      return new SubscriptionCollection.fromMap(value);
  }

  Customer.fromMap(Map dataMap) : super.fromMap(dataMap);

  /// [Retrieve a customer](https://stripe.com/docs/api#retrieve_customer)
  static Future<Customer> retrieve(String customerId, {final Map data}) async {
    var dataMap = await StripeService.retrieve([Customer._path, customerId], data: data);
    return new Customer.fromMap(dataMap);
  }

  /// [List all Customers](https://stripe.com/docs/api#list_customers)
  static Future<CustomerCollection> list({var created, int limit, String startingAfter, String endingBefore}) async {
    var data = {};
    if (created != null) data['created'] = created;
    if (limit != null) data['limit'] = limit;
    if (startingAfter != null) data['starting_after'] = startingAfter;
    if (endingBefore != null) data['ending_before'] = endingBefore;
    if (data == {}) data = null;
    var dataMap = await StripeService.list([Customer._path], data: data);
    return new CustomerCollection.fromMap(dataMap);
  }

  /// [Delete a customer](https://stripe.com/docs/api#delete_customer)
  static Future<Map> delete(String customerId) => StripeService.delete([Customer._path, customerId]);
}

class CustomerCollection extends ResourceCollection {
  Customer _getInstanceFromMap(map) => new Customer.fromMap(map);

  CustomerCollection.fromMap(Map map) : super.fromMap(map);
}

/// [Create a customer](https://stripe.com/docs/api#create_customer)
class CustomerCreation extends ResourceRequest {
  set accountBalance(int accountBalance) => _setMap('account_balance', accountBalance);

  set coupon(String coupon) => _setMap('coupon', coupon);

  set description(String description) => _setMap('description', description);

  set email(String email) => _setMap('email', email);

  set metadata(Map metadata) => _setMap('metadata', metadata);

  set plan(String plan) => _setMap('plan', plan);

  set quantity(int quantity) => _setMap('quantity', quantity);

  set source(SourceCreation source) => _setMap('source', source);

  set trialEnd(int trialEnd) => _setMap('trial_end', trialEnd);

  Future<Customer> create({String idempotencyKey}) async {
    var dataMap = await StripeService.create([Customer._path], _getMap(), idempotencyKey: idempotencyKey);
    return new Customer.fromMap(dataMap);
  }
}

/// [Update a customer](https://stripe.com/docs/api#update_customer)
class CustomerUpdate extends ResourceRequest {
  set accountBalance(int accountBalance) => _setMap('account_balance', accountBalance);

  set coupon(String coupon) => _setMap('coupon', coupon);

  set description(String description) => _setMap('description', description);

  set email(String email) => _setMap('email', email);

  set metadata(Map metadata) => _setMap('metadata', metadata);

  set sourceToken(String sourceToken) => _setMap('source', sourceToken);

  set source(SourceCreation source) => _setMap('source', source);

  set defaultSource(String sourceId) => _setMap('default_source', sourceId);

  Future<Customer> update(String customerId) async {
    var dataMap = await StripeService.update([Customer._path, customerId], _getMap());
    return new Customer.fromMap(dataMap);
  }
}
