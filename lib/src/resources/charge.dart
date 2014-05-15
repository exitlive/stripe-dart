part of stripe;

/**
 * To charge a credit or a debit card, you create a new charge object.
 * You can retrieve and refund individual charges as well as list all charges.
 * Charges are identified by a unique random ID.
 */
class Charge extends Resource {

  String get id => _dataMap["id"];

  String objectName = "charge";

  static String _path = "charges";


  Charge.fromMap(Map dataMap) : super.fromMap(dataMap);

  bool get livemode => _dataMap["livemode"];

  /// Amount charged in cents
  int get amount => _dataMap["amount"];

  /// If the charge was created without capturing, this boolean represents
  /// whether or not it is still uncaptured or has since been captured.
  bool get captured => _dataMap["captured"];

  /// Hash describing the card used to make the charge
  Card get card {
    var value = _dataMap["card"];
    if (value == null) return null;
    else return new Card.fromMap(value);
  }

  DateTime get created => _getDateTimeFromMap("created");

  /// Three-letter ISO currency code representing the currency in which the
  /// charge was made.
  String get currency => _dataMap["currency"];

  bool get paid => _dataMap["paid"];

  /// Whether or not the charge has been fully refunded. If the charge is only
  /// partially refunded, this attribute will still be false.
  bool get refunded => _dataMap["refunded"];

  /// A list of refunds that have been applied to the charge.
  List<Refund> get refunds {
    List refundMaps = _dataMap["refunds"];
    assert(refundMaps != null);
    return refundMaps.map((Map refund) => new Refund.fromMap(refund)).toList(growable: false);
  }

  /// Amount in cents refunded (can be less than the amount attribute on the
  /// charge if a partial refund was issued)
  int get amountRefunded => _dataMap["amountRefunded"];

  /// Balance transaction id that describes the impact of this charge on your
  /// account balance (not including refunds or disputes).
  String get balanceTransaction {
    var value = _dataMap["balance_transaction"];
    if (value == null) return null;
    else if(value is String) return _dataMap["balance_transaction"];
    else return new Balance.fromMap(value).id;
  }

  /// [Balance] object that describes the impact of this charge on your
  /// account balance (not including refunds or disputes).
  /// This will return null if you call retrieve without expanding.
  Balance get balanceTransactionExpand {
    var value = _dataMap["balance_transaction"];
    if (value == null) return null;
    else return new Balance.fromMap(value);
  }

  /// ID of the customer this charge is for if one exists
  String get customer {
    var value = _dataMap["customer"];
    if (value == null) return null;
    else if(value is String) return value;
    else return new Customer.fromMap(value).id;
  }

  /// [Customer] object of this charge is for if one exists
  /// This will return null if you call retrieve without expanding.
  Customer get customerExpand {
    var value = _dataMap["customer"];
    if (value == null) return null;
    else return new Customer.fromMap(value);
  }

  String get description => _dataMap["description"];

  /// Details about the dispute if the charge has been disputed
  Dispute get dispute {
    var value = _dataMap["dispute"];
    if (value == null) return null;
    else return new Dispute.fromMap(value);
  }

  /// Error code explaining reason for charge failure if available
  /// (see https://stripe.com/docs/api#errors for a list of codes)
  String get failureCode => _dataMap["failureCode"];

  /// Message to user further explaining reason for charge failure if available
  String get failureMessage => _dataMap["failureMessage"];

  /// ID of the invoice this charge is for if one exists
  String get invoice {
    var value = _dataMap["invoice"];
    if (value == null) return null;
    else if(value is String) return _dataMap["invoice"];
    else return new Invoice.fromMap(value).id;
  }

  /// [Invoice] object this charge is for if one exists
  /// This will return null if you call retrieve without expanding.
  Invoice get invoiceExpand {
    var value = _dataMap["invoice"];
    if (value == null) return null;
    else return new Invoice.fromMap(value);
  }

  /// A set of key/value pairs that you can attach to a charge object.
  /// It can be useful for storing additional information about the charge in
  /// a structured format.
  Map<String, String> get metadata => _dataMap["metadata"];

  /// Extra information about a charge for the customer’s credit card statement.
  String get statement_description => _dataMap["statement_description"];

  /**
   * Returns a charge object if a valid identifier was provided.
   *
   * If you need the [Balance], [Customer] or [Invoice] object of this charge
   * you can avoid an additional API request e.g.:
   *
   *     Charge.retrieve(id, data: {"expand": ["Customer"]})
   *
   * or
   *
   *     Charge.retrieve(id, data: {"expand": ["Balance", "Customer", "Invoice"]})
   *
   * then retrieve the e.g. [Customer] using [customerExpand]
   * Only expand resources on demand.
   */
  static Future<Charge> retrieve(String id, {final Map data}) {
    return StripeService.retrieve(Charge._path, id, data: data)
        .then((Map json) => new Charge.fromMap(json));
  }

  /**
   * Refunds a charge that has previously been created but not yet refunded.
   * Funds will be refunded to the credit or debit card that was originally
   * charged. The fees you were originally charged are also refunded.
   *
   * You can optionally refund only part of a charge. You can do so as many
   * times as you wish until the entire charge has been refunded.
   *
   * Once entirely refunded, a charge can't be refunded again. This method will
   * return an error when called on an already-refunded charge, or when trying
   * to refund more money than is left on a charge.
   */
  static Future<Charge> refund(String id, {int amount, bool refundApplicationFee}) {
    Map data = {};
    if (amount != null) data["amount"] = amount;
    if (refundApplicationFee != null) data["refund_application_fee"] = refundApplicationFee;
    if (data == {}) data = null;
    return StripeService.post(Charge._path, id: id, action: "refund", data: data)
        .then((Map json) => new Charge.fromMap(json));
  }

  /**
   * Capture the payment of an existing, uncaptured, charge. This is the second
   * half of the two-step payment flow, where first you created a charge with
   * the capture option set to false.
   *
   * Uncaptured payments expire exactly seven days after they are created.
   * If they are not captured by that point in time, they will be marked as
   * refunded and will no longer be capturable.
   */
  static Future<Charge> capture(String id, {int amount, bool refundApplicationFee}) {
    Map data = {};
    if (amount != null) data["amount"] = amount;
    if (refundApplicationFee != null) data["refund_application_fee"] = refundApplicationFee;
    if (data == {}) data = null;
    return StripeService.post(Charge._path, id: id, action: "capture", data: data)
        .then((Map json) => new Charge.fromMap(json));
  }
}



/**
 * Used to create [Charge]
 */
class ChargeCreation extends ResourceRequest {

  /// A positive integer in the smallest currency unit
  /// (e.g 100 cents to charge $1.00, or 1 to charge ¥1, a 0-decimal currency)
  /// representing how much to charge the card. The minimum amount is $0.50
  /// (or equivalent in charge currency).
  @required
  set amount (int amount) => _setMap("amount", amount);

  /// 3-letter ISO code for currency.
  @required
  set currency (String currency) => _setMap("currency", currency);

  /// The ID of an existing customer that will be charged in this request.
  set customer (String customer) => _setMap("customer", customer);

  /// A card to be charged. If you also pass a customer ID, the card must be
  /// the ID of a card belonging to the customer. Otherwise, if you do not pass
  /// a customer ID, the card you provide must either be a token, like the ones
  /// returned by Stripe.js, or a hash containing a user's credit card details,
  /// with the options described below. Although not all information is
  /// required, the extra info helps prevent fraud.
  set cardId (String cardId) => _setMap("card", cardId);

  /// A card to be charged. If you also pass a customer ID, the card must be
  /// the ID of a card belonging to the customer. Otherwise, if you do not pass
  /// a customer ID, the card you provide must either be a token, like the ones
  /// returned by Stripe.js, or a hash containing a user's credit card details,
  /// with the options described below. Although not all information is
  /// required, the extra info helps prevent fraud.
  set cardToken (String cardToken) => _setMap("card", cardToken);

  /// A card to be charged. If you also pass a customer ID, the card must be
  /// the ID of a card belonging to the customer. Otherwise, if you do not pass
  /// a customer ID, the card you provide must either be a token, like the ones
  /// returned by Stripe.js, or a hash containing a user's credit card details,
  /// with the options described below. Although not all information is
  /// required, the extra info helps prevent fraud.
  set card (CardCreation card) => _setMap("card", card._getMap());

  /// An arbitrary string which you can attach to a charge object.
  /// It is displayed when in the web interface alongside the charge.
  /// Note that if you use Stripe to send automatic email receipts to your
  /// customers, your receipt emails will include the description of the
  /// charge(s) that they are describing.
  set description (String description) => _setMap("description", description);

  /// A set of key/value pairs that you can attach to a charge object.
  /// It can be useful for storing additional information about the customer in
  /// a structured format. It's often a good idea to store an email address in
  /// metadata for tracking later.
  set metadata (Map metadata) => _setMap("metadata", metadata);

  /// Whether or not to immediately capture the charge. When false, the charge
  /// issues an authorization (or pre-authorization), and will need to be
  /// captured later. Uncaptured charges expire in 7 days. For more information,
  /// see authorizing charges and settling later.
  ///
  // Apparently capture needs to be sent as String
  set capture (bool capture) => _setMap("capture", capture.toString());

  /// An arbitrary string to be displayed alongside your company name on your
  /// customer's credit card statement. This may be up to 15 characters.
  /// As an example, if your website is RunClub and you specify 5K Race Ticket,
  /// the user will see
  /// RUNCLUB 5K RACE TICKET.
  /// The statement description may not include <>"' characters.
  /// While most banks display this information consistently, some may display
  /// it incorrectly or not at all.
  set statementDescription (String statementDescription) => _setMap("statement_description", statementDescription);

  /// A fee in cents that will be applied to the charge and transferred to the
  /// application owner's Stripe account. The request must be made with an
  /// OAuth key in order to take an application fee. For more information,
  /// see the application fees documentation.
  set applicationFee (int applicationFee) => _setMap("application_fee", applicationFee);

  /**
   * Uses the values of [CardCreation] to send a request to the Stripe API.
   * Returns a [Future] with a new [Charge] from the response.
   */
  Future<Charge> create() {
    return StripeService.create(Charge._path, _getMap())
      .then((Map json) => new Charge.fromMap(json));
  }

}


/**
 * Used to update an existing [Charge]
 */
class ChargeUpdate extends ResourceRequest {

  /// An arbitrary string which you can attach to a recipient object.
  /// It is displayed alongside the recipient in the web interface.
  /// This can be unset by updating the value to nil and then saving.
  set description (String description) => _setMap("description", description);

  /// A set of key/value pairs that you can attach to a charge object.
  /// It can be useful for storing additional information about the charge in a
  /// structured format. You can unset an individual key by setting its value
  /// to nil and then saving. To clear all keys, set metadata to nil, then save.
  set metadata (Map metadata) => _setMap("metadata", metadata);


  /**
   * Uses the values of [ChargeUpdate] to send a request to the Stripe API.
   * Returns a [Future] with the updated [Charge] from the response.
   */
  Future<Charge> update(String id) {
    return StripeService.update([Charge._path, id], _getMap())
      .then((Map json) => new Charge.fromMap(json));
  }

}