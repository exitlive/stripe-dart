part of stripe;


/**
 * [Subscriptions](https://stripe.com/docs/api/curl#subscriptions)
 */
class Subscription extends ApiResource {

  String get id => _dataMap['id'];

  final String objectName = 'subscription';

  static String _path = 'subscriptions';

  bool get cancelAtPeriodEnd => _dataMap['cancel_at_period_end'];

  String get customer => _dataMap['customer'];

  Plan get plan {
    var value = _dataMap['plan'];
    if (value == null) return null;
    else return new Plan.fromMap(value);
  }

  int get quantity => _dataMap['quantiy'];

  int get start => _dataMap['start'];

  String get status => _dataMap['status'];

  int get applicationFeePercent => _dataMap['application_fee_percent'];

  int get canceledAt => _dataMap['canceled_at'];

  int get currentPeriodEnd => _dataMap['current_period_end'];

  int get currentPeriodStart => _dataMap['current_period_start'];

  Discount get discount {
    var value = _dataMap['discount'];
    if (value == null) return null;
    else return new Discount.fromMap(value);
  }

  int get endedAt => _dataMap['ended_at'];

  int get trialEnd => _dataMap['trial_end'];

  int get trialStart => _dataMap['trial_start'];

  Subscription.fromMap(Map dataMap) : super.fromMap(dataMap);

}


class SubscriptionCollection extends ResourceCollection {

  Subscription _getInstanceFromMap(map) => new Subscription.fromMap(map);

  SubscriptionCollection.fromMap(Map map) : super.fromMap(map);

}


/**
 * [Creating a new subscription](https://stripe.com/docs/api/curl#create_subscription)
 */
class SubscriptionCreation extends ResourceRequest {

  @required
  set plan (String plan) => _setMap('plan', plan);

  set coupon (String coupon) => _setMap('coupon', coupon);

  set trialEnd (int trialEnd) => _setMap('trial_end', trialEnd);

  set card (CardCreation card) => _setMap('card', card._getMap());

  set quantity (int quantity) => _setMap('quantity', quantity);

  set applicationFeePercent (int applicationFeePercent) => _setMap('application_fee_percent', applicationFeePercent);

  Future<Subscription> create(String customerId) {
    return StripeService.create([Customer._path, customerId, Subscription._path], _getMap())
        .then((Map json) => new Subscription.fromMap(json));
  }

}