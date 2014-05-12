part of stripe;

/**
 * A subscription plan contains the pricing information for different products
 * and feature levels on your site. For example, you might have a $10/month
 * plan for basic features and a different $20/month plan for premium features.
 */
class Plan extends ApiResource {

  String get id => _dataMap["id"];

  final String objectName = "plan";

  static String _path = "plans";


  Plan.fromMap(Map dataMap) : super.fromMap(dataMap);


  bool get livemode => _dataMap["livemode"];

  /// The amount in cents to be charged on the interval specified
  int get amount => _dataMap["amount"];

  DateTime get created => _getDateTimeFromMap("created");

  /// Currency in which subscription will be charged
  String get currency => _dataMap["currency"];

  /// One of week, month or year. The frequency with which a subscription should
  /// be billed.
  String get interval => _dataMap["interval"];

  /// The number of intervals (specified in the interval property) between each
  /// subscription billing. For example, interval=month and interval_count=3
  /// bills every 3 months.
  int get intervalCount => _dataMap["interval_count"];

  /// Display name of the plan
  String get name => _dataMap["name"];

  /// A set of key/value pairs that you can attach to a plan object.
  /// It can be useful for storing additional information about the plan in a
  /// structured format.
  Map<String, String> get metadata => _dataMap["metadata"];

  /// Number of trial period days granted when subscribing a customer to this
  /// plan. Null if the plan has no trial period.
  int get trialPeriodDays => _dataMap["trial_period_days"];

  /// Extra information about a charge for the customer’s credit card statement.
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

  /// Unique string of your choice that will be used to identify this plan when
  /// subscribing a customer. This could be an identifier like "gold" or
  /// a primary key from your own database.
  @required
  set id (String id) => _setMap("id", id);

  /// A positive integer in cents (or 0 for a free plan) representing how much
  /// to charge (on a recurring basis).
  @required
  set amount (int amount) => _setMap("amount", amount);

  /// 3-letter ISO code for currency.
  @required
  set currency (String currency) => _setMap("currency", currency);

  /// Specifies billing frequency. Either week, month or year.
  @required
  set interval (String interval) => _setMap("interval", interval);

  /// The number of intervals between each subscription billing. For example,
  /// interval=month and interval_count=3 bills every 3 months. Maximum of one
  /// year interval allowed (1 year, 12 months, or 52 weeks).
  @required
  set intervalCount (int intervalCount) => _setMap("interval_count", intervalCount);

  /// Name of the plan, to be displayed on invoices and in the web interface.
  @required
  set name (String name) => _setMap("name", name);

  /// Specifies a trial period in (an integer number of) days.
  /// If you include a trial period, the customer won't be billed for the first
  /// time until the trial period ends. If the customer cancels before the trial
  /// period is over, she'll never be billed at all.
  set trialPeriodDays (int trialPeriodDays) => _setMap("trial_period_days", trialPeriodDays);

  /// A set of key/value pairs that you can attach to a plan object.
  /// It can be useful for storing additional information about the plan in a
  /// structured format.
  set metadata (Map metadata) => _setMap("metadata", metadata);

  /// An arbitrary string to be displayed on your customers' credit card
  /// statements (alongside your company name) for charges created by this plan.
  ///  This may be up to 15 characters. As an example, if your website is
  ///  RunClub and you specify Silver Plan, the user will see
  ///  RUNCLUB SILVER PLAN.
  ///  The statement description may not include <>"' characters.
  ///  While most banks display this information consistently, some may display
  ///  it incorrectly or not at all.
  set statementDescription (String statementDescription) => _setMap("statement_description", statementDescription);

  /**
   * Uses the values of [PlanCreation] to send a request to the Stripe API.
   * Returns a [Future] with a new [Plan] from the response.
   */
  Future<Plan> create() {
    return StripeService.create(Plan._path, _getMap())
      .then((Map json) => new Plan.fromMap(json));
  }

}