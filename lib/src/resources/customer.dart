part of stripe;

/**
 * Customer objects allow you to perform recurring charges and track multiple
 * charges that are associated with the same customer. The API allows you to
 * create, delete, and update your customers. You can retrieve individual
 * customers as well as a list of all your customers.
 */
class Customer extends ApiResource {

  final String objectName = "customer";

  static String _path = "customers";


  Customer.fromMap(Map dataMap) : super.fromMap(dataMap);

  String get id => _dataMap["id"];

  DateTime get created => _getDateTimeFromMap("created");

  bool get livemode => _dataMap["livemode"];

  bool get deleted => _dataMap["deleted"];

  String get description => _dataMap["description"];

  /**
   * If you want the actual card Object, you need to load it manually like this:
   *
   *     Card.retrieve(customer.defaultCard)
   */
  String get defaultCard => _dataMap["default_card"];

  String get email => _dataMap["email"];

  int get trialEnd => _dataMap["trial_end"];

  Discount get discount => _dataMap["discount"];

  NextRecurringCharge get nextRecurringCharge {
    var value;
    if ((value = _dataMap["next_recurring_charge"]) == null) return null;
    else return new NextRecurringCharge.fromMap(value);
  }

  Subscription get subscription {
    var value;
    if ((value = _dataMap["subscription"]) == null) return null;
    else return new Subscription.fromMap(value);
  }

  bool get delinquent => _dataMap["delinquent"];

  int get accountBalance => _dataMap["account_balance"];

  String get currency => _dataMap["currency"];

  CustomerCardCollection get cards {
    var value = _dataMap["cards"];
    if (value == null) return null;
    else return new CustomerCardCollection.fromMap(value);
  }

  Map<String, String> get metadata => _dataMap["metadata"];


  static Future<Customer> retrieve(String id) {
    return StripeService.retrieve(Customer._path, id)
        .then((Map json) => new Customer.fromMap(json));
  }

  static Future<CustomerCollection> all({Map<String, dynamic> params: const {}}) {
    return StripeService.list(Customer._path, params)
        .then((Map json) => new CustomerCollection.fromMap(json));
  }

  static Future delete(String id) => StripeService.delete(Customer._path, id);

}


/**
 * Used to create a new [Customer]
 */
class CustomerCreation extends ResourceRequest {

  set accountBalance (int accountBalance) => _setMap("account_balance", accountBalance);

  set card (CardCreation card) => _setMap("card", card._getMap());

  set coupon (String coupon) => _setMap("coupon", coupon);

  set description (String description) => _setMap("description", description);

  set email (String email) => _setMap("email", email);

  set metadata (Map metadata) => _setMap("metadata", metadata);

  set plan (String plan) => _setMap("plan", plan);

  set quantity (int quantity) => _setMap("quantity", quantity);

  set trialEnd (int trialEnd) => _setMap("trial_end", trialEnd);

  Future<Customer> create() {
    return StripeService.create(Customer._path, _getMap())
      .then((Map json) => new Customer.fromMap(json));
  }

}


/**
 * Used to update an existing [Customer]
 */
class CustomerUpdate extends ResourceRequest {

  set accountBalance (int accountBalance) => _setMap("account_balance", accountBalance);

  set card (CardCreation card) => _setMap("card", card._getMap());

  set coupon (String coupon) => _setMap("coupon", coupon);

  set defaultCard (String defaultCard) => _setMap("default_card", defaultCard);

  set description (String description) => _setMap("description", description);

  set email (String email) => _setMap("email", email);

  set metadata (Map metadata) => _setMap("metadata", metadata);

  // TODO: needs to be changed to use StripeService.update()
  Future<Customer> update() {
    return StripeService.create(Customer._path, _getMap())
      .then((Map json) => new Customer.fromMap(json));
  }

}