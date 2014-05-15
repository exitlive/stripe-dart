part of stripe;

/**
 * Invoices are statements of what a customer owes for a particular billing
 * period, including subscriptions, invoice items, and any automatic proration
 * adjustments if necessary.
 *
 * Once an invoice is created, payment is automatically attempted. Note that the
 * payment, while automatic, does not happen exactly at the time of invoice
 * creation. If you have configured webhooks, the invoice will wait until one
 * hour after the last webhook is successfully sent
 * (or the last webhook times out after failing).
 *
 * Any customer credit on the account is applied before determining how much is
 * due for that invoice (the amount that will be actually charged). If the
 * amount due for the invoice is less than 50 cents (the minimum for a charge),
 * we add the amount to the customer's running account balance to be added to
 * the next invoice. If this amount is negative, it will act as a credit to
 * offset the next invoice. Note that the customer account balance does not
 * include unpaid invoices; it only includes balances that need to be taken
 * into account when calculating the amount due for the next invoice.
 */
class Invoice extends ApiResource {

  String get id => _dataMap["id"];

  String objectName = "invoice";

  static String _path = "invoices";


  Invoice.fromMap(Map dataMap) : super.fromMap(dataMap);


  bool get livemode => _dataMap["livemode"];

  /// Final amount due at this time for this invoice. If the invoice’s total is
  /// smaller than the minimum charge amount, for example, or if there is
  /// account credit that can be applied to the invoice,
  /// the amount_due may be 0. If there is a positive starting_balance for the
  /// invoice (the customer owes money), the amount_due will also take that into
  /// account. The charge that gets generated for the invoice will be for the
  /// amount specified in amount_due.
  int get amountDue => _dataMap["amount_due"];

  /// Number of automatic payment attempts made for this invoice.
  /// Does not include manual attempts to pay the invoice.
  int get attemptCount => _dataMap["attempt_count"];

  /// Whether or not an attempt has been made to pay the invoice. An invoice is
  /// not attempted until 1 hour after the invoice.created webhook, for example,
  /// so you might not want to display that invoice as unpaid to your users.
  bool get attempted => _dataMap["attempt"];

  /// Whether or not the invoice is still trying to collect payment. An invoice
  /// is closed if it’s either paid or it has been marked closed. A closed
  /// invoice will no longer attempt to collect payment.
  bool get closed => _dataMap["closed"];

  String get currency => _dataMap["currency"];

  /// ID of the customer
  String get customer {
    var value = _dataMap["customer"];
    if (value == null) return null;
    else if(value is String) return value;
    else return new Customer.fromMap(value).id;
  }

  /// [Customer] object
  /// This will return null if you call retrieve without expanding.
  Customer get customerExpand {
    var value = _dataMap["customer"];
    if (value == null) return null;
    else return new Customer.fromMap(value);
  }

  DateTime get date => _getDateTimeFromMap("date");

  /// The individual line items that make up the invoice
  InvoiceLineItemCollection get lines {
    var value = _dataMap["lines"];
    if (value == null) return null;
    else return new InvoiceLineItemCollection.fromMap(value);
  }

  /// Whether or not payment was successfully collected for this invoice.
  /// An invoice can be paid (most commonly) with a charge or with credit from
  /// the customer’s account balance.
  bool get paid => _dataMap["paid"];

  /// End of the usage period the invoice covers
  DateTime get periodEnd => _getDateTimeFromMap("period_end");

  /// Start of the usage period the invoice covers
  DateTime get periodStart => _getDateTimeFromMap("period_start");

  /// Starting customer balance before attempting to pay invoice. If the invoice
  /// has not been attempted yet, this will be the current customer balance.
  int get startingBalance => _dataMap["starting_balance"];

  /// Total of all subscriptions, invoice items, and prorations on the invoice
  /// before any discount is applied
  int get subtotal => _dataMap["subtotal"];

  /// Total after discount
  int get total => _dataMap["total"];

  /// The fee in cents that will be applied to the invoice and transferred to the application owner’s Stripe account when the invoice is paid.
  int get applicationFee => _dataMap["application_fee"];

  /// ID of the latest charge generated for this invoice, if any.
  String get charge {
    var value = _dataMap["charge"];
    if (value == null) return null;
    else if(value is String) return value;
    else return new Charge.fromMap(value).id;
  }

  /// [Charge] object of the latest charge generated for this invoice, if any.
  /// This will return null if you call retrieve without expanding.
  Charge get chargeExpand {
    var value = _dataMap["charge"];
    if (value == null) return null;
    else return new Charge.fromMap(value);
  }

  String get description => _dataMap["description"];

  Discount get discount => new Discount.fromMap(_dataMap["discount"]);

  /// Ending customer balance after attempting to pay invoice.
  /// If the invoice has not been attempted yet, this will be null.
  int get endingBalance => _dataMap["ending_balance"];

  DateTime get nextPaymentAttempt => _getDateTimeFromMap("next_payment_attempt");

  /// The subscription that this invoice was prepared for, if any.
  String get subscription => _dataMap["subscription"];

  /// A set of key/value pairs that you can attach to an invoice object.
  /// It can be useful for storing additional information about the invoice in
  /// a structured format.
  Map<String, String> get metadata => _dataMap["metadata"];



  /**
   * Retrieves the invoice with the given ID.
   *
   * If you need the [Customer] or [Charge] object of this invoice you can
   * avoid an additional API request e.g.:
   *
   *     Invoice.retrieve(id, data: {"expand": ["customer"]})
   *
   * or
   *
   *     Invoice.retrieve(id, data: {"expand": ["customer", "charge"]})
   *
   * then retrieve the [Customer] using [customerExpand]
   * Only expand resources on demand.
   */
  static Future<Invoice> retrieve(String id) {
    return StripeService.retrieve(Invoice._path, id)
        .then((Map json) => new Invoice.fromMap(json));
  }

}