part of stripe;


class SubscriptionCollection extends ResourceCollection {

  Subscription _getInstanceFromMap(map) => new Subscription.fromMap(map);

  SubscriptionCollection.fromMap(Map map) : super.fromMap(map);

}