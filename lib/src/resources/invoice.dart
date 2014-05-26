part of stripe;


/**
 * [Invoices](https://stripe.com/docs/api/curl#invoices)
 */
class Invoice extends ApiResource {

  String get id => _dataMap['id'];

  String objectName = 'invoice';

  static String _path = 'invoices';

  bool get livemode => _dataMap['livemode'];

  int get amountDue => _dataMap['amount_due'];

  int get attemptCount => _dataMap['attempt_count'];

  bool get attempted => _dataMap['attempted'];

  bool get closed => _dataMap['closed'];

  String get currency => _dataMap['currency'];

  String get customer {
    var value = _dataMap['customer'];
    if (value == null) return null;
    else if(value is String) return value;
    else return new Customer.fromMap(value).id;
  }

  Customer get customerExpand {
    var value = _dataMap['customer'];
    if (value == null) return null;
    else return new Customer.fromMap(value);
  }

  DateTime get date => _getDateTimeFromMap('date');

  InvoiceLineItemCollection get lines {
    var value = _dataMap['lines'];
    if (value == null) return null;
    else return new InvoiceLineItemCollection.fromMap(value);
  }

  bool get paid => _dataMap['paid'];

  DateTime get periodEnd => _getDateTimeFromMap('period_end');

  DateTime get periodStart => _getDateTimeFromMap('period_start');

  int get startingBalance => _dataMap['starting_balance'];

  int get subtotal => _dataMap['subtotal'];

  int get total => _dataMap['total'];

  int get applicationFee => _dataMap['application_fee'];

  String get charge {
    var value = _dataMap['charge'];
    if (value == null) return null;
    else if(value is String) return value;
    else return new Charge.fromMap(value).id;
  }

  Charge get chargeExpand {
    var value = _dataMap['charge'];
    if (value == null) return null;
    else return new Charge.fromMap(value);
  }

  String get description => _dataMap['description'];

  Discount get discount {
    var value = _dataMap['discount'];
    if (value == null) return null;
    else return new Discount.fromMap(value);
  }

  int get endingBalance => _dataMap['ending_balance'];

  DateTime get nextPaymentAttempt => _getDateTimeFromMap('next_payment_attempt');

  String get subscription => _dataMap['subscription'];

  DateTime get webhooksDeliveredAt => _getDateTimeFromMap('webhooks_delivered_at');

  Map<String, String> get metadata => _dataMap['metadata'];

  Invoice.fromMap(Map dataMap) : super.fromMap(dataMap);

  /**
   * [Retrieving an Invoice](https://stripe.com/docs/api/curl#retrieve_invoice)
   */
  static Future<Invoice> retrieve(String invoiceId) {
    return StripeService.retrieve([Invoice._path, invoiceId])
        .then((Map json) => new Invoice.fromMap(json));
  }

  /**
   * [Paying an invoice](https://stripe.com/docs/api/curl#pay_invoice)
   */
  static Future<Invoice> pay(String invoiceId) {
    return StripeService.post([Invoice._path, invoiceId, 'pay'])
        .then((Map json) => new Invoice.fromMap(json));
  }

  /**
   * [Retrieving a List of Invoices](https://stripe.com/docs/api/curl#list_customer_invoices)
   */
  // TODO: implement missing arguments
  static Future<InvoiceCollection> list({String customer, int limit, String startingAfter, String endingBefore}) {
    Map data = {};
    if (customer != null) data['customer'] = customer;
    if (limit != null) data['limit'] = limit;
    if (startingAfter != null) data['starting_after'] = startingAfter;
    if (endingBefore != null) data['ending_before'] = endingBefore;
    if (data == {}) data = null;
    return StripeService.list([Invoice._path], data: data)
        .then((Map json) => new InvoiceCollection.fromMap(json));
  }

  /**
   * [Retrieving a Customer's Upcoming Invoice](https://stripe.com/docs/api/curl#retrieve_customer_invoice)
   */
  static Future<Invoice> retrieveUpcoming(String customerId, {String subscriptionId}) {
    Map data = {};
    data['customer'] = customerId;
    if (subscriptionId != null) data['subscription'] = subscriptionId;
    return StripeService.get([Invoice._path, 'upcoming'], data: data)
        .then((Map json) => new Invoice.fromMap(json));
  }

  /**
   * [Retrieve an invoice's line items](https://stripe.com/docs/api/curl#invoice_lines)
   */
  static Future<InvoiceLineItemCollection> retrieveLineItems(String invoiceId, {String customerId, int limit, String startingAfter, String endingBefore, String subscriptionId}) {
    Map data = {};
    if (customerId != null) data['customer'] = customerId;
    if (limit != null) data['limit'] = limit;
    if (startingAfter != null) data['starting_after'] = startingAfter;
    if (endingBefore != null) data['ending_before'] = endingBefore;
    if (subscriptionId != null) data['s'] = subscriptionId;
    if (data == {}) data = null;
    return StripeService.retrieve([Invoice._path, invoiceId, InvoiceLineItem._path])
        .then((Map json) => new InvoiceLineItemCollection.fromMap(json));
  }

}


class InvoiceCollection extends ResourceCollection {

  Invoice _getInstanceFromMap(map) => new Invoice.fromMap(map);

  InvoiceCollection.fromMap(Map map) : super.fromMap(map);

}


/**
 * [Creating an invoice](https://stripe.com/docs/api/curl#create_invoice)
 */
class InvoiceCreation extends ResourceRequest {

  @required
  set customer (String customer) => _setMap('customer', customer);

  set applicationFee (int applicationFee) => _setMap('application_fee', applicationFee);

  set description (String description) => _setMap('description', description);

  set metadata (Map metadata) => _setMap('metadata', metadata);

  set subscription (String subscription) => _setMap('subscription', subscription);

  Future<Invoice> create() {
    return StripeService.create([Invoice._path], _getMap())
      .then((Map json) => new Invoice.fromMap(json));
  }

}


/**
 * [Updating an invoice](https://stripe.com/docs/api/curl#update_invoice)
 */
class InvoiceUpdate extends ResourceRequest {

  set applicationFee (int applicationFee) => _setMap('application_fee', applicationFee);

  set closed (bool closed) => _setMap('closed', closed);

  set description (String description) => _setMap('description', description);

  set metadata (Map metadata) => _setMap('metadata', metadata);

  Future<Invoice> update(String invoiceId) {
    return StripeService.update([Invoice._path, invoiceId], _getMap())
      .then((Map json) => new Invoice.fromMap(json));
  }

}


/**
 * [The invoice_line_item object](https://stripe.com/docs/api/curl#invoice_line_item_object)
 */
class InvoiceLineItem extends Resource {

  String get id => _dataMap['id'];

  String objectName = 'line_item';

  static String _path = 'lines';

  bool get livemode => _dataMap['livemode'];

  int get amount => _dataMap['amount'];

  String get currency =>_dataMap['currency'];

  Period get period => new Period.fromMap(_dataMap['period']);

  bool get proration => _dataMap['proration'];

  String get type => _dataMap['type'];

  String get description => _dataMap['description'];

  Map<String, String> get metadata => _dataMap['metadata'];

  Plan get plan => new Plan.fromMap(_dataMap['plan']);

  int get quantity => _dataMap['quantity'];

  InvoiceLineItem.fromMap(Map dataMap) : super.fromMap(dataMap);

}


class InvoiceLineItemCollection extends ResourceCollection {

  InvoiceLineItem _getInstanceFromMap(map) => new InvoiceLineItem.fromMap(map);

  InvoiceLineItemCollection.fromMap(Map map) : super.fromMap(map);

}


class Period {

  Map _dataMap;

  int get start => _dataMap['start'];

  int get end => _dataMap['end'];

  Period.fromMap(this._dataMap);

}