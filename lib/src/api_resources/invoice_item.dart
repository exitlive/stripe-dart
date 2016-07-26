part of stripe;

/// [Invoice items](https://stripe.com/docs/api/curl#invoiceitems)
class InvoiceItem extends ApiResource {
  String get id => _dataMap['id'];

  final String object = 'invoiceitem';

  static var _path = 'invoiceitems';

  bool get livemode => _dataMap['livemode'];

  int get amount => _dataMap['amount'];

  String get currency => _dataMap['currency'];

  String get customer {
    return this._getIdForExpandable('customer');
  }

  Customer get customerExpand {
    var value = _dataMap['customer'];
    if (value == null)
      return null;
    else
      return new Customer.fromMap(value);
  }

  DateTime get date => _getDateTimeFromMap('date');

  bool get proration => _dataMap['proration'];

  String get description => _dataMap['description'];

  String get invoice {
    return this._getIdForExpandable('invoice');
  }

  Invoice get invoiceExpand {
    var value = _dataMap['invoice'];
    if (value == null)
      return null;
    else
      return new Invoice.fromMap(value);
  }

  Map<String, String> get metadata => _dataMap['metadata'];

  String get subscription => _dataMap['subscription'];

  InvoiceItem.fromMap(Map dataMap) : super.fromMap(dataMap);

  /// [Retrieving an Invoice Item](https://stripe.com/docs/api/curl#retrieve_invoiceitem)
  static Future<InvoiceItem> retrieve(String invoiceItemId, {final Map data}) async {
    var dataMap = await StripeService.retrieve([InvoiceItem._path, invoiceItemId], data: data);
    return new InvoiceItem.fromMap(dataMap);
  }

  /// [List all Invoice Items](https://stripe.com/docs/api/curl#list_invoiceitems)
  /// TODO: implement missing argument: `created`
  static Future<InvoiceItemCollection> list(
      {String customer, int limit, String startingAfter, String endingBefore}) async {
    var data = {};
    if (customer != null) data['customer'] = customer;
    if (limit != null) data['limit'] = limit;
    if (startingAfter != null) data['starting_after'] = startingAfter;
    if (endingBefore != null) data['ending_before'] = endingBefore;
    if (data == {}) data = null;
    var dataMap = await StripeService.list([InvoiceItem._path], data: data);
    return new InvoiceItemCollection.fromMap(dataMap);
  }

  /// [Deleting an Invoice Item](https://stripe.com/docs/api/curl#delete_invoiceitem)
  static Future<Map> delete(String invoiceItemId) => StripeService.delete([InvoiceItem._path, invoiceItemId]);
}

class InvoiceItemCollection extends ResourceCollection {
  InvoiceItem _getInstanceFromMap(map) => new InvoiceItem.fromMap(map);

  InvoiceItemCollection.fromMap(Map map) : super.fromMap(map);
}

/// [Creating an Invoice Item](https://stripe.com/docs/api/curl#create_invoiceitem)
class InvoiceItemCreation extends ResourceRequest {
  @required
  set customer(String customer) => _setMap('customer', customer);

  @required
  set amount(int amount) => _setMap('amount', amount);

  @required
  set currency(String currency) => _setMap('currency', currency);

  set invoice(String invoice) => _setMap('invoice', invoice);

  set subscription(String subscription) => _setMap('subscription', subscription);

  set description(String description) => _setMap('description', description);

  set metadata(Map metadata) => _setMap('metadata', metadata);

  Future<InvoiceItem> create() async {
    var dataMap = await StripeService.create([InvoiceItem._path], _getMap());
    return new InvoiceItem.fromMap(dataMap);
  }
}

/// [Updating an Invoice Item](https://stripe.com/docs/api/curl#update_invoiceitem)
class InvoiceItemUpdate extends ResourceRequest {
  set amount(int amount) => _setMap('amount', amount);

  set description(String description) => _setMap('description', description);

  set metadata(Map metadata) => _setMap('metadata', metadata);

  Future<InvoiceItem> update(String invoiceItemId) async {
    var dataMap = await StripeService.update([InvoiceItem._path, invoiceItemId], _getMap());
    return new InvoiceItem.fromMap(dataMap);
  }
}
