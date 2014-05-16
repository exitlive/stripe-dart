part of stripe;


/**
 * [Invoices](https://stripe.com/docs/api/curl#invoices)
 */
class Invoice extends ApiResource {

  String get id => _dataMap["id"];

  String objectName = "invoice";

  static String _path = "invoices";

  bool get livemode => _dataMap["livemode"];

  int get amountDue => _dataMap["amount_due"];

  int get attemptCount => _dataMap["attempt_count"];

  bool get attempted => _dataMap["attempt"];

  bool get closed => _dataMap["closed"];

  String get currency => _dataMap["currency"];

  String get customer {
    var value = _dataMap["customer"];
    if (value == null) return null;
    else if(value is String) return value;
    else return new Customer.fromMap(value).id;
  }

  Customer get customerExpand {
    var value = _dataMap["customer"];
    if (value == null) return null;
    else return new Customer.fromMap(value);
  }

  DateTime get date => _getDateTimeFromMap("date");

  InvoiceLineItemCollection get lines {
    var value = _dataMap["lines"];
    if (value == null) return null;
    else return new InvoiceLineItemCollection.fromMap(value);
  }

  bool get paid => _dataMap["paid"];

  DateTime get periodEnd => _getDateTimeFromMap("period_end");

  DateTime get periodStart => _getDateTimeFromMap("period_start");

  int get startingBalance => _dataMap["starting_balance"];

  int get subtotal => _dataMap["subtotal"];

  int get total => _dataMap["total"];

  int get applicationFee => _dataMap["application_fee"];

  String get charge {
    var value = _dataMap["charge"];
    if (value == null) return null;
    else if(value is String) return value;
    else return new Charge.fromMap(value).id;
  }

  Charge get chargeExpand {
    var value = _dataMap["charge"];
    if (value == null) return null;
    else return new Charge.fromMap(value);
  }

  String get description => _dataMap["description"];

  Discount get discount => new Discount.fromMap(_dataMap["discount"]);

  int get endingBalance => _dataMap["ending_balance"];

  DateTime get nextPaymentAttempt => _getDateTimeFromMap("next_payment_attempt");

  String get subscription => _dataMap["subscription"];

  Map<String, String> get metadata => _dataMap["metadata"];

  Invoice.fromMap(Map dataMap) : super.fromMap(dataMap);

  /**
   * [Retrieving an Invoice](https://stripe.com/docs/api/curl#retrieve_invoice)
   */
  static Future<Invoice> retrieve(String id) {
    return StripeService.retrieve([Invoice._path, id])
        .then((Map json) => new Invoice.fromMap(json));
  }

}