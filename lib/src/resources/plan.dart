part of stripe;


/**
 * [Plans](https://stripe.com/docs/api/curl#plans)
 */
class Plan extends ApiResource {

  String get id => _dataMap['id'];

  final String objectName = 'plan';

  static var _path = 'plans';

  bool get livemode => _dataMap['livemode'];

  int get amount => _dataMap['amount'];

  DateTime get created => _getDateTimeFromMap('created');

  String get currency => _dataMap['currency'];

  String get interval => _dataMap['interval'];

  int get intervalCount => _dataMap['interval_count'];

  String get name => _dataMap['name'];

  Map<String, String> get metadata => _dataMap['metadata'];

  int get trialPeriodDays => _dataMap['trial_period_days'];

  String get statementDescriptor => _dataMap['statement_descriptor'];

  Plan.fromMap(Map dataMap) : super.fromMap(dataMap);

  /**
   * [Retrieving a Plan](https://stripe.com/docs/api/curl#retrieve_plan)
   */
  static Future<Plan> retrieve(String id) async {
    var dataMap = await StripeService.retrieve([Plan._path, id]);
    return new Plan.fromMap(dataMap);
  }

  /**
   * [List all Plans](https://stripe.com/docs/api/curl#list_plans)
   */
  static Future<PlanCollection> list({int limit, String startingAfter, String endingBefore}) async {
    var data = {};
    if (limit != null) data['limit'] = limit;
    if (startingAfter != null) data['starting_after'] = startingAfter;
    if (endingBefore != null) data['ending_before'] = endingBefore;
    if (data == {}) data = null;
    var dataMap = await StripeService.list([Plan._path], data: data);
    return new PlanCollection.fromMap(dataMap);
  }

  /**
   * [Deleting a plan](https://stripe.com/docs/api/curl#delete_plan)
   */
  static Future<Map> delete(String id) => StripeService.delete([Plan._path, id]);

}


class PlanCollection extends ResourceCollection {

  Plan _getInstanceFromMap(map) => new Plan.fromMap(map);

  PlanCollection.fromMap(Map map) : super.fromMap(map);

}


/**
 * [Creating plans](https://stripe.com/docs/api/curl#create_plan)
 */
class PlanCreation extends ResourceRequest {

  @required
  set id (String id) => _setMap('id', id);

  @required
  set amount (int amount) => _setMap('amount', amount);

  @required
  set currency (String currency) => _setMap('currency', currency);

  @required
  set interval (String interval) => _setMap('interval', interval);

  set intervalCount (int intervalCount) => _setMap('interval_count', intervalCount);

  @required
  set name (String name) => _setMap('name', name);

  set trialPeriodDays (int trialPeriodDays) => _setMap('trial_period_days', trialPeriodDays);

  set metadata (Map metadata) => _setMap('metadata', metadata);

  set statementDescriptor (String statementDescriptor) => _setMap('statement_descriptor', statementDescriptor);

  Future<Plan> create() async {
    var dataMap = await StripeService.create([Plan._path], _getMap());
    return new Plan.fromMap(dataMap);
  }

}


/**
 * [Updating a plan](https://stripe.com/docs/api/curl#update_plan)
 */
class PlanUpdate extends ResourceRequest {

  set name (String name) => _setMap('name', name);

  set metadata (Map metadata) => _setMap('metadata', metadata);

  set statementDescriptor (String statementDescriptor) => _setMap('statement_descriptor', statementDescriptor);

  Future<Plan> update(String planId) async {
    var dataMap = await StripeService.update([Plan._path, planId], _getMap());
    return new Plan.fromMap(dataMap);
  }

}