part of stripe;

/**
 * Subscriptions allow you to charge a customer's card on a recurring basis.
 * A subscription ties a customer to a particular plan you've created.
 */
class Subscription extends ApiResource {

  String get id => _dataMap["id"];

  final String objectName = "subscription";

  static String _path = "subscriptions";

  /// If the subscription has been canceled with the at_period_end flag set to
  /// true, cancel_at_period_end on the subscription will be true.
  /// You can use this attribute to determine whether a subscription that has
  /// a status of active is scheduled to be canceled at the end of the current
  /// period.
  bool get cancelAtPeriodEnd => _dataMap["cancel_at_period_end"];


  String get customer => _dataMap["customer"];

  /// Hash describing the plan the customer is subscribed to
  Plan get plan {
    var value = _dataMap["plan"];
    if (value == null) return null;
    else return new Plan.fromMap(value);
  }

  int get quantity => _dataMap["quantiy"];

  /// Date the subscription started
  int get start => _dataMap["start"];

  /// Possible values are trialing, active, past_due, canceled, or unpaid.
  /// A subscription still in its trial period is trialing and moves to active
  /// when the trial period is over.
  /// When payment to renew the subscription fails, the subscription becomes
  /// past_due. After Stripe has exhausted all payment retry attempts,
  /// the subscription ends up with a status of either canceled or unpaid
  /// depending on your retry settings. Note that when a subscription has
  /// a status of unpaid, no subsequent invoices will be attempted
  /// (invoices will be created, but then immediately automatically closed).
  /// After receiving updated card details from a customer, you may choose to
  /// reopen and pay their closed invoices.
  String get status => _dataMap["status"];

  /// A positive decimal that represents the fee percentage of the subscription
  /// invoice amount that will be transferred to the application owner’s
  /// Stripe account each billing period.
  int get applicationFeePercent => _dataMap["application_fee_percent"];

  /// If the subscription has been canceled, the date of that cancellation.
  /// If the subscription was canceled with cancel_at_period_end,
  /// canceled_at will still reflect the date of the initial cancellation
  /// request, not the end of the subscription period when the subscription is
  /// automatically moved to a canceled state.
  int get canceledAt => _dataMap["canceled_at"];

  /// End of the current period that the subscription has been invoiced for.
  /// At the end of this period, a new invoice will be created.
  int get currentPeriodEnd => _dataMap["current_period_end"];

  /// Start of the current period that the subscription has been invoiced for
  int get currentPeriodStart => _dataMap["current_period_start"];

  /// Describes the current discount applied to this subscription,
  /// if there is one. When billing, a discount applied to a subscription
  /// overrides a discount applied on a customer-wide basis.
  Discount get discount {
    var value = _dataMap["discount"];
    if (value == null) return null;
    else return new Discount.fromMap(value);
  }

  /// If the subscription has ended (either because it was canceled or because
  /// the customer was switched to a subscription to a new plan),
  /// the date the subscription ended
  int get endedAt => _dataMap["ended_at"];

  /// If the subscription has a trial, the end of that trial.
  int get trialEnd => _dataMap["trial_end"];

  /// If the subscription has a trial, the beginning of that trial.
  int get trialStart => _dataMap["trial_start"];


  Subscription.fromMap(Map dataMap) : super.fromMap(dataMap);

}

/**
 * Used to create a new [Subscription]
 */
class SubscriptionCreation extends ResourceRequest {

  /// The identifier of the plan to subscribe the customer to.
  set plan (String plan) => _setMap("plan", plan);

  /// The code of the coupon to apply to this subscription.
  /// A coupon applied to a subscription will only affect invoices created for
  /// that particular subscription.
  set coupon (String coupon) => _setMap("coupon", coupon);

  /// UTC integer timestamp representing the end of the trial period the
  /// customer will get before being charged for the first time. If set,
  /// trial_end will override the default trial period of the plan the customer
  /// is being subscribed to. The special value now can be provided to end the
  /// customer's trial immediately.
  set trialEnd (int trialEnd) => _setMap("trial_end", trialEnd);

  /// The card can either be a token, like the ones returned by our Stripe.js,
  /// or a dictionary containing a user's credit card details
  /// (with the options shown below). You must provide a card if the customer
  /// does not already have a valid card attached, and you are subscribing the
  /// customer for a plan that is not free. Passing card will create a new card,
  /// make it the customer default card, and delete the old customer default
  /// if one exists. If you want to add an additional card to use with
  /// subscriptions, instead use the card creation API to add the card
  /// and then the customer update API to set it as the default.
  /// Whenever you attach a card to a customer, Stripe will automatically
  /// validate the card.
  set card (CardCreation card) => _setMap("card", card._getMap());

  /// The quantity you'd like to apply to the subscription you're creating.
  /// For example, if your plan is $10/user/month, and your customer has
  /// 5 users, you could pass 5 as the quantity to have the customer charged $50
  /// (5 x $10) monthly. If you update a subscription but don't change
  /// the plan ID (e.g. changing only the trial_end), the subscription will
  /// inherit the old subscription's quantity attribute unless you pass
  /// a new quantity parameter. If you update a subscription and change
  /// the plan ID, the new subscription will not inherit the quantity attribute
  /// and will default to 1 unless you pass a quantity parameter.
  set quantity (int quantity) => _setMap("quantity", quantity);

  /// A positive decimal (with at most two decimal places) between 1 and 100
  /// that represents the percentage of the subscription invoice amount due
  /// each billing period (including any bundled invoice items) that will be
  /// transferred to the application owner’s Stripe account.
  /// The request must be made with an OAuth key in order to set an application
  /// fee percentage . For more information, see the application fees
  /// documentation.
  set applicationFeePercent (int applicationFeePercent) => _setMap("application_fee_percent", applicationFeePercent);


  /**
   * Uses the values of [SubscriptionCreation] to send a request to the
   * Stripe API for the customer with [customerId].
   * Returns a [Future] with a new [Subscription] from the response.
   */
  Future<Subscription> create(String customerId) {
    return StripeService.create([Customer._path, customerId, Subscription._path], _getMap())
        .then((Map json) => new Subscription.fromMap(json));
  }

}
