part of stripe;

/**
 * Customer objects allow you to perform recurring charges and track multiple
 * charges that are associated with the same customer. The API allows you to
 * create, delete, and update your customers. You can retrieve individual
 * customers as well as a list of all your customers.
 */
class Customer extends ApiResource {

  String get id => _dataMap["id"];

  final String objectName = "customer";

  static String _path = "customers";


  Customer.fromMap(Map dataMap) : super.fromMap(dataMap);


  DateTime get created => _getDateTimeFromMap("created");

  bool get livemode => _dataMap["livemode"];

  /// Current balance, if any, being stored on the customer’s account.
  /// If negative, the customer has credit to apply to the next invoice.
  /// If positive, the customer has an amount owed that will be added to the
  /// next invoice. The balance does not refer to any unpaid invoices;
  /// it solely takes into account amounts that have yet to be successfully
  /// applied to any invoice. This balance is only taken into account for
  /// recurring charges.
  int get accountBalance => _dataMap["account_balance"];

  /// The currency the customer can be charged in for recurring billing purposes
  /// (subscriptions, invoices, invoice items).
  String get currency => _dataMap["currency"];

  /// ID of the default credit card attached to the customer
  ///
  /// If you want the actual card Object, you need to load it manually like this:
  ///
  ///     Card.retrieve(customer.defaultCard)
  String get defaultCard => _dataMap["default_card"];

  /// Whether or not the latest charge for the customer’s latest invoice
  /// has failed
  bool get delinquent => _dataMap["delinquent"];

  String get description => _dataMap["description"];

  /// Describes the current discount active on the customer, if there is one.
  Discount get discount {
    var value = _dataMap["discount"];
    if (value == null) return null;
    else return new Discount.fromMap(value);
  }

  String get email => _dataMap["email"];

  /// A set of key/value pairs that you can attach to a customer object.
  /// It can be useful for storing additional information about the customer
  /// in a structured format.
  Map<String, String> get metadata => _dataMap["metadata"];


  NextRecurringCharge get nextRecurringCharge {
    var value;
    if ((value = _dataMap["next_recurring_charge"]) == null) return null;
    else return new NextRecurringCharge.fromMap(value);
  }

  SubscriptionCollection get subscriptions {
    var value = _dataMap["subscriptions"];
    if (value == null) return null;
    else return new SubscriptionCollection.fromMap(value);
  }

  CardCollection get cards {
    var value = _dataMap["cards"];
    if (value == null) return null;
    else return new CardCollection.fromMap(value);
  }

  /// Returns a customer object if a valid identifier was provided.
  static Future<Customer> retrieve(String id) {
    return StripeService.retrieve(Customer._path, id)
        .then((Map json) => new Customer.fromMap(json));
  }

  /// When requesting the ID of a customer that has been deleted, a subset of
  /// the customer's information will be returned, including a "deleted"
  /// property, which will be true.
  bool get deleted => _dataMap["deleted"];

  /**
   * Returns a [CustomerCollection] of your customers.
   * The customers are returned sorted by creation date, with the most recently
   * created customers appearing first.
   */
  static Future<CustomerCollection> list({int limit, String startingAfter, String endingBefore}) {
    Map data = {};
    if (limit != null) data["limit"] = limit;
    if (startingAfter != null) data["starting_after"] = startingAfter;
    if (endingBefore != null) data["ending_before"] = endingBefore;
    if (data == {}) data = null;
    return StripeService.list(Customer._path, data: data)
        .then((Map json) => new CustomerCollection.fromMap(json));
  }

  /**
   * Permanently deletes a customer. It cannot be undone.
   * Also immediately cancels any active subscription on the customer.
   */
  static Future delete(String id) => StripeService.delete(Customer._path, id);

}


/**
 * Used to create a new [Customer]
 */
class CustomerCreation extends ResourceRequest {

  /// An integer amount in cents that is the starting account balance for your
  /// customer. A negative amount represents a credit that will be used before
  /// attempting any charges to the customer’s card; a positive amount will be
  /// added to the next invoice.
  set accountBalance (int accountBalance) => _setMap("account_balance", accountBalance);

  /// The card can either be a token, like the ones returned by our Stripe.js,
  /// or a dictionary containing a user’s credit card details
  /// (with the options shown below). Passing card will create a new card,
  /// make it the new customer default card, and delete the old customer default
  /// if one exists. If you want to add additional cards instead of replacing
  /// the existing default, use the card creation API. Whenever you attach a
  /// card to a customer, Stripe will automatically validate the card.
  set card (CardCreation card) => _setMap("card", card._getMap());

  /// If you provide a coupon code, the customer will have a discount applied on
  /// all recurring charges. Charges you create through the API will not have
  /// the discount.
  set coupon (String coupon) => _setMap("coupon", coupon);

  /// An arbitrary string that you can attach to a customer object.
  /// It is displayed alongside the customer in the dashboard.
  /// This will be unset if you POST an empty value.
  set description (String description) => _setMap("description", description);

  /// Customer’s email address. It’s displayed alongside the customer in your
  /// dashboard and can be useful for searching and tracking. This will be unset
  /// if you POST an empty value.
  set email (String email) => _setMap("email", email);

  /// A set of key/value pairs that you can attach to a customer object.
  /// It can be useful for storing additional information about the customer in
  /// a structured format. This will be unset if you POST an empty value.
  set metadata (Map metadata) => _setMap("metadata", metadata);

  /// The identifier of the plan to subscribe the customer to. If provided,
  /// the returned customer object has a ‘subscription’ attribute describing
  /// the state of the customer’s subscription
  set plan (String plan) => _setMap("plan", plan);

  /// The quantity you’d like to apply to the subscription you’re creating.
  /// For example, if your plan is 10 cents/user/month, and your customer has
  /// 5 users, you could pass 5 as the quantity to have the customer charged
  /// 50 cents (5 x 10 cents) monthly. Defaults to 1 if not set. Only applies
  /// when the plan parameter is also provided.
  set quantity (int quantity) => _setMap("quantity", quantity);

  /// UTC integer timestamp representing the end of the trial period the
  /// customer will get before being charged for the first time. If set,
  /// trial_end will override the default trial period of the plan the customer
  /// is being subscribed to.
  set trialEnd (int trialEnd) => _setMap("trial_end", trialEnd);

  /// The special value now can be provided to end the
  /// customer’s trial immediately. Only applies when the plan parameter is
  /// also provided.
  trialEndNow() => _setMap("trial_end", "now");


  /**
   * Uses the values of [CustomerCreation] to send a request to the Stripe API.
   * Returns a [Future] with a new [Customer] from the response.
   */
  Future<Customer> create() {
    return StripeService.create(Customer._path, _getMap())
      .then((Map json) => new Customer.fromMap(json));
  }

}


/**
 * Used to update an existing [Customer]
 */
class CustomerUpdate extends ResourceRequest {

  /// An integer amount in cents that is the starting account balance for your
  /// customer. A negative amount represents a credit that will be used before
  /// attempting any charges to the customer’s card; a positive amount will be
  /// added to the next invoice.
  set accountBalance (int accountBalance) => _setMap("account_balance", accountBalance);

  set card (CardCreation card) => _setMap("card", card._getMap());

  set coupon (String coupon) => _setMap("coupon", coupon);

  set defaultCard (String defaultCard) => _setMap("default_card", defaultCard);

  set description (String description) => _setMap("description", description);

  set email (String email) => _setMap("email", email);

  set metadata (Map metadata) => _setMap("metadata", metadata);


  /**
   * Uses the values of [CustomerUpdate] to send a request to the Stripe API.
   * Returns a [Future] with the updated [Customer] from the response.
   */
  Future<Customer> update(String id) {
    return StripeService.update(Customer._path, id, _getMap())
      .then((Map json) => new Customer.fromMap(json));
  }

}