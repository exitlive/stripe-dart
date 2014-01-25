part of stripe;

/**
 * Customer objects allow you to perform recurring charges and track multiple
 * charges that are associated with the same customer. The API allows you to
 * create, delete, and update your customers. You can retrieve individual
 * customers as well as a list of all your customers.
 */
class Customer extends ApiResource {

  static String _path = "customers";

  Customer.fromMap(Map map) : super.fromMap(map) {
    print(map);
  }

  int created;
  String id;
  bool livemode;
  bool deleted;
  String description;
  String defaultCard;
  String email;
  int trialEnd;
  Discount discount;
  NextRecurringCharge nextRecurringCharge;
  Subscription subscription;
  bool delinquent;
  int accountBalance;
  CustomerCardCollection cards;
  Map<String, String> metadata;

  static Future<Customer> create(Map params) {
    return StripeService.post(Customer._path, params)
      .then((Map json) => new Customer.fromMap(json));
  }

}