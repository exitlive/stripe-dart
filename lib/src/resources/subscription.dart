part of stripe;

/// [Subscriptions](https://stripe.com/docs/api/curl#subscriptions)
class Subscription extends ApiResource {
  String get id => _dataMap['id'];

  final String object = 'subscription';

  static var _path = 'subscriptions';

  bool get cancelAtPeriodEnd => _dataMap['cancel_at_period_end'];

  String get customer {
    var value = _dataMap['customer'];
    if (value == null) return null;
    else if (value is String) return value;
    else return new Customer.fromMap(value).id;
  }

  Customer get customerExpand {
    var value = _dataMap['customer'];
    if (value == null) return null;
    else return new Customer.fromMap(value);
  }

  Plan get plan {
    var value = _dataMap['plan'];
    if (value == null) return null;
    else return new Plan.fromMap(value);
  }

  int get quantity => _dataMap['quantity'];

  DateTime get start => _getDateTimeFromMap('start');

  String get status => _dataMap['status'];

  int get applicationFeePercent => _dataMap['application_fee_percent'];

  DateTime get canceledAt => _getDateTimeFromMap('canceled_at');

  DateTime get currentPeriodEnd => _getDateTimeFromMap('current_period_end');

  DateTime get currentPeriodStart => _getDateTimeFromMap('current_period_start');

  Discount get discount {
    var value = _dataMap['discount'];
    if (value == null) return null;
    else return new Discount.fromMap(value);
  }

  DateTime get endedAt => _getDateTimeFromMap('ended_at');

  Map<String, String> get metadata => _dataMap['metadata'];

  DateTime get trialEnd => _getDateTimeFromMap('trial_end');

  DateTime get trialStart => _getDateTimeFromMap('trial_start');

  Subscription.fromMap(Map dataMap) : super.fromMap(dataMap);

  /// [Retrieving a customer's subscription](https://stripe.com/docs/api/curl#retrieve_subscription)
  static Future<Subscription> retrieve(String customerId, String subscriptionId, {final Map data}) async {
    var dataMap =
        await StripeService.retrieve([Customer._path, customerId, Subscription._path, subscriptionId], data: data);
    return new Subscription.fromMap(dataMap);
  }

  /// [Canceling a Customer's Subscription](https://stripe.com/docs/api/curl#cancel_subscription)
  static Future<Subscription> cancel(String customerId, String subscriptionId,
      {bool atPeriodEnd, final Map data}) async {
    var data = {};
    if (atPeriodEnd != null) data['at_period_end'] = atPeriodEnd;
    if (data == {}) data = null;
    var dataMap =
        await StripeService.delete([Customer._path, customerId, Subscription._path, subscriptionId], data: data);
    return new Subscription.fromMap(dataMap);
  }

  /// [Listing subscriptions](https://stripe.com/docs/api/curl#list_subscriptions)
  static Future<SubscriptionCollection> list(String customerId,
      {int limit, String startingAfter, String endingBefore}) async {
    var data = {};
    if (limit != null) data['limit'] = limit;
    if (startingAfter != null) data['starting_after'] = startingAfter;
    if (endingBefore != null) data['ending_before'] = endingBefore;
    if (data == {}) data = null;
    var dataMap = await StripeService.list([Customer._path, customerId, Subscription._path], data: data);
    return new SubscriptionCollection.fromMap(dataMap);
  }
}

class SubscriptionCollection extends ResourceCollection {
  Subscription _getInstanceFromMap(map) => new Subscription.fromMap(map);

  SubscriptionCollection.fromMap(Map map) : super.fromMap(map);
}

/// [Creating a new subscription](https://stripe.com/docs/api/curl#create_subscription)
class SubscriptionCreation extends ResourceRequest {
  @required
  set plan(String plan) => _setMap('plan', plan);

  set coupon(String coupon) => _setMap('coupon', coupon);

  set trialEnd(int trialEnd) => _setMap('trial_end', trialEnd);

  set card(CardCreation card) => _setMap('card', card);

  set quantity(int quantity) => _setMap('quantity', quantity);

  set applicationFeePercent(int applicationFeePercent) => _setMap('application_fee_percent', applicationFeePercent);

  set metadata(Map metadata) => _setMap('metadata', metadata);

  Future<Subscription> create(String customerId) async {
    var dataMap = await StripeService.create([Customer._path, customerId, Subscription._path], _getMap());
    return new Subscription.fromMap(dataMap);
  }
}

/// [Updating a Subscription](https://stripe.com/docs/api/curl#update_subscription)
class SubscriptionUpdate extends ResourceRequest {
  set plan(String plan) => _setMap('plan', plan);

  set coupon(String coupon) => _setMap('coupon', coupon);

  set prorate(bool prorate) => _setMap('prorate', prorate);

  set trialEnd(int trialEnd) => _setMap('trial_end', trialEnd);

  set card(CardCreation card) => _setMap('card', card);

  set quantity(int quantity) => _setMap('quantity', quantity);

  set applicationFeePercent(int applicationFeePercent) => _setMap('application_fee_percent', applicationFeePercent);

  set metadata(Map metadata) => _setMap('metadata', metadata);

  Future<Subscription> update(String customerId, String subscriptionId) async {
    var dataMap =
        await StripeService.create([Customer._path, customerId, Subscription._path, subscriptionId], _getMap());
    return new Subscription.fromMap(dataMap);
  }
}
