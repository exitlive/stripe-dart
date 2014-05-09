part of stripe;

/**
 * A subscription plan contains the pricing information for different products
 * and feature levels on your site. For example, you might have a $10/month
 * plan for basic features and a different $20/month plan for premium features.
 */
class Plan extends ApiResource {

  final String objectName = "plan";

  static String _path = "plans";


  Plan.fromMap(Map dataMap) : super.fromMap(dataMap);

  String get id => _dataMap["id"];

  bool get livemode => _dataMap["livemode"];

  int get amount => _dataMap["amount"];

  DateTime get created => _getDateTimeFromMap("created");

  /// One of week, month or year. The frequency with which a subscription
  /// should be billed.

  String get currency => _dataMap["currency"];

  String get interval => _dataMap["interval"];

  int get intervalCount => _dataMap["interval_count"];

  String get name => _dataMap["name"];

  Map<String, String> get metadata => _dataMap["metadata"];

  int get trialPeriodDays => _dataMap["trial_period_days"];

  String get statementDescription => _dataMap["statement_description"];

  static Future<Plan> retrieve(String id) {
    return StripeService.retrieve(Plan._path, id)
        .then((Map json) => new Plan.fromMap(json));
  }

  static Future<PlanCollection> all({Map<String, dynamic> params: const {}}) {
    return StripeService.list(Plan._path, params)
        .then((Map json) => new PlanCollection.fromMap(json));
  }

  static Future delete(String id) => StripeService.delete(Plan._path, id);


}


/**
 * Used to create a new [Plan]
 */
class PlanCreation extends ResourceRequest {

  @required
  set id (String id) => _setMap("id", id);

  @required
  set amount (int amount) => _setMap("amount", amount);

  @required
  set currency (String currency) => _setMap("currency", currency);

  @required
  set interval (String interval) => _setMap("interval", interval);

  @required
  set intervalCount (int intervalCount) => _setMap("interval_count", intervalCount);

  @required
  set name (String name) => _setMap("name", name);

  set trialDaysPeriod (int trialDaysPeriod) => _setMap("trial_days_period", trialDaysPeriod);

  set metadata (Map metadata) => _setMap("metadata", metadata);

  set statementDescription (String statementDescription) => _setMap("statement_description", statementDescription);

  Future<Plan> create() {
    return StripeService.create(Plan._path, _getMap())
      .then((Map json) => new Plan.fromMap(json));
  }

}