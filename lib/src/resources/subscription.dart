part of stripe;

class Subscription extends ApiResource {

  String id;
  int currentPeriodEnd;
  int currentPeriodStart;
  bool cancelAtPeriodEnd;
  String customer;
  int start;
  String status;
  int trialStart;
  int trialEnd;
//  Plan plan;
  int canceledAt;
  int endedAt;
  int quantity;

  Subscription.fromMap(Map json) : super.fromMap(json) {

  }


}