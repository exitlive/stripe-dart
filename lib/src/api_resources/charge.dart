part of stripe;

/// [Charges](https://stripe.com/docs/api#charges)
class Charge extends Resource {
  String get id => _dataMap['id'];

  final String object = 'charge';

  static var _path = 'charges';

  bool get livemode => _dataMap['livemode'];

  int get amount => _dataMap['amount'];

  bool get captured => _dataMap['captured'];

  DateTime get created => _getDateTimeFromMap('created');

  String get currency => _dataMap['currency'];

  bool get paid => _dataMap['paid'];

  bool get refunded => _dataMap['refunded'];

  RefundCollection get refunds {
    Map refundMap = _dataMap['refunds'];
    assert(refundMap != null);
    return new RefundCollection.fromMap(refundMap);
  }

  Card get source {
    var value = _dataMap['source'];
    if (value == null) return null;
    else return new Card.fromMap(value);
  }

  String get status => _dataMap['status'];

  int get amountRefunded => _dataMap['amountRefunded'];

  String get balanceTransaction {
    var value = _dataMap['balance_transaction'];
    if (value == null) return null;
    else if (value is String) return _dataMap['balance_transaction'];
    else return new BalanceTransaction.fromMap(value).id;
  }

  BalanceTransaction get balanceTransactionExpand {
    var value = _dataMap['balance_transaction'];
    if (value == null) return null;
    else return new BalanceTransaction.fromMap(value);
  }

  String get customer {
    var value = _dataMap['customer'];
    if (value == null) return null;
    else if (value is String) return value;
    else return new Customer.fromMap(value).id;
  }

  Customer get customerExpand {
    var value = _dataMap['customer'];
    if (value == null) return null;
    else return new Customer.fromMap(value);
  }

  String get description => _dataMap['description'];

  Dispute get dispute {
    var value = _dataMap['dispute'];
    if (value == null) return null;
    else return new Dispute.fromMap(value);
  }

  String get failureCode => _dataMap['failureCode'];

  String get failureMessage => _dataMap['failureMessage'];

  String get invoice {
    var value = _dataMap['invoice'];
    if (value == null) return null;
    else if (value is String) return _dataMap['invoice'];
    else return new Invoice.fromMap(value).id;
  }

  Invoice get invoiceExpand {
    var value = _dataMap['invoice'];
    if (value == null) return null;
    else return new Invoice.fromMap(value);
  }

  Map<String, String> get metadata => _dataMap['metadata'];

  String get receiptEmail => _dataMap['receipt_email'];

  String get receiptNumber => _dataMap['receipt_number'];

  String get applicationFee => _dataMap['application_fee'];

  String get destination => _dataMap['destination'];

  Map<String, String> get fraudDetails => _dataMap['fraud_details'];

  Shipping get shipping => new Shipping.fromMap(_dataMap['shipping']);

  String get statement_descriptor => _dataMap['statement_descriptor'];

  Charge.fromMap(Map dataMap) : super.fromMap(dataMap);

  /// [Retrieve a charge](https://stripe.com/docs/api#retrieve_charge)
  static Future<Charge> retrieve(String id, {final Map data}) async {
    var dataMap = await StripeService.retrieve([Charge._path, id], data: data);
    return new Charge.fromMap(dataMap);
  }

  /// [Capture a charge](https://stripe.com/docs/api#capture_charge)
  static Future<Charge> capture(String id,
      {int amount, String applicationFee, String receiptEmail, String statementDescriptor}) async {
    var data = {};
    if (amount != null) data['amount'] = amount;
    if (applicationFee != null) data['application_fee'] = applicationFee;
    if (receiptEmail != null) data['receipt_email'] = receiptEmail;
    if (statementDescriptor != null) data['statement_descriptor'] = statementDescriptor;
    var dataMap = await StripeService.post([Charge._path, id, 'capture'], data: data);
    return new Charge.fromMap(dataMap);
  }

  /// [List all Charges](https://stripe.com/docs/api#list_charges)
  static Future<ChargeCollection> list(
      {var created, String customer, int limit, String startingAfter, String endingBefore}) async {
    var data = {};
    if (created != null) data['created'] = created;
    if (customer != null) data['customer'] = customer;
    if (endingBefore != null) data['ending_before'] = endingBefore;
    if (limit != null) data['limit'] = limit;
    if (startingAfter != null) data['starting_after'] = startingAfter;
    var dataMap = await StripeService.list([Charge._path], data: data);
    return new ChargeCollection.fromMap(dataMap);
  }
}

class ChargeCollection extends ResourceCollection {
  Charge _getInstanceFromMap(map) => new Charge.fromMap(map);

  ChargeCollection.fromMap(Map map) : super.fromMap(map);
}

/// [Create a charge](https://stripe.com/docs/api#create_charge)
class ChargeCreation extends ResourceRequest {
  @required
  set amount(int amount) => _setMap('amount', amount);

  @required
  set currency(String currency) => _setMap('currency', currency);

  set customer(String customer) => _setMap('customer', customer);

  set sourceToken(String sourceToken) => _setMap('source', sourceToken);

  set source(CardCreation source) => _setMap('source', source);

  set description(String description) => _setMap('description', description);

  set metadata(Map metadata) => _setMap('metadata', metadata);

  set capture(bool capture) => _setMap('capture', capture.toString());

  set statementDescriptor(String statementDescriptor) => _setMap('statement_descriptor', statementDescriptor);

  set receiptEmail(String receiptEmail) => _setMap('receipt_email', receiptEmail);

  set destination(int destination) => _setMap('destination', destination);

  set applicationFee(int applicationFee) => _setMap('application_fee', applicationFee);

  set shipping(int shipping) => _setMap('shipping', shipping);

  Future<Charge> create() async {
    var dataMap = await StripeService.create([Charge._path], _getMap());
    return new Charge.fromMap(dataMap);
  }
}

/// [Update a charge](https://stripe.com/docs/api#update_charge)
class ChargeUpdate extends ResourceRequest {
  set description(String description) => _setMap('description', description);

  set metadata(Map metadata) => _setMap('metadata', metadata);

  set receiptEmail(Map receiptEmail) => _setMap('receipt_email', receiptEmail);

  set fraudDetails(Map fraudDetails) => _setMap('fraud_details', fraudDetails);

  Future<Charge> update(String id) async {
    var dataMap = await StripeService.update([Charge._path, id], _getMap());
    return new Charge.fromMap(dataMap);
  }
}
