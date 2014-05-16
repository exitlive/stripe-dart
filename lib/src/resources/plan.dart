part of stripe;


/**
 * [Plans](https://stripe.com/docs/api/curl#plans)
 */
class Plan extends ApiResource {

  String get id => _dataMap["id"];

  final String objectName = "plan";

  static String _path = "plans";

  bool get livemode => _dataMap["livemode"];

  int get amount => _dataMap["amount"];

  DateTime get created => _getDateTimeFromMap("created");

  String get currency => _dataMap["currency"];

  String get interval => _dataMap["interval"];

  int get intervalCount => _dataMap["interval_count"];

  String get name => _dataMap["name"];

  Map<String, String> get metadata => _dataMap["metadata"];

  int get trialPeriodDays => _dataMap["trial_period_days"];

  String get statementDescription => _dataMap["statement_description"];

  Plan.fromMap(Map dataMap) : super.fromMap(dataMap);

  /**
   * [Retrieving a Plan](https://stripe.com/docs/api/curl#retrieve_plan)
   */
  static Future<Plan> retrieve(String id) {
    return StripeService.retrieve([Plan._path, id])
        .then((Map json) => new Plan.fromMap(json));
  }

  /**
   * [List all Plans](https://stripe.com/docs/api/curl#list_plans)
   */
  static Future<PlanCollection> list({int limit, String startingAfter, String endingBefore}) {
    Map data = {};
    if (limit != null) data["limit"] = limit;
    if (startingAfter != null) data["starting_after"] = startingAfter;
    if (endingBefore != null) data["ending_before"] = endingBefore;
    if (data == {}) data = null;
    return StripeService.list([Plan._path], data: data)
        .then((Map json) => new PlanCollection.fromMap(json));
  }

  /**
   * [Deleting a plan](https://stripe.com/docs/api/curl#delete_plan)
   */
  static Future delete(String id) => StripeService.delete([Plan._path, id]);

}


/**
 * [Creating plans](https://stripe.com/docs/api/curl#create_plan)
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

  set trialPeriodDays (int trialPeriodDays) => _setMap("trial_period_days", trialPeriodDays);

  set metadata (Map metadata) => _setMap("metadata", metadata);

  set statementDescription (String statementDescription) => _setMap("statement_description", statementDescription);

  Future<Plan> create() {
    return StripeService.create([Plan._path], _getMap())
      .then((Map json) => new Plan.fromMap(json));
  }

}