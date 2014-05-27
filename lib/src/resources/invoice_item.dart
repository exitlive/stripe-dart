part of stripe;


/**
 * [Invoice items](https://stripe.com/docs/api/curl#invoiceitems)
 */
class Invoiceitem extends Resource {

  String get id => _dataMap['id'];

  String objectName = 'invoiceitem';

  static String _path = 'invoiceitems';

  bool get livemode => _dataMap['livemode'];

  int get amount => _dataMap['amount'];

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

  bool get proration => _dataMap['proration'];

  String get description => _dataMap['description'];

  String get invoice {
    var value = _dataMap['invoice'];
    if (value == null) return null;
    else if(value is String) return value;
    else return new Invoice.fromMap(value).id;
  }

  Invoice get invoiceExpand {
    var value = _dataMap['invoice'];
    if (value == null) return null;
    else return new Invoice.fromMap(value);
  }

  Map<String, String> get metadata => _dataMap['metadata'];

  String get subscription => _dataMap['subscription'];

  Invoiceitem.fromMap(Map dataMap) : super.fromMap(dataMap);

  /**
   * [Retrieving an Invoice Item](https://stripe.com/docs/api/curl#retrieve_invoiceitem)
   */
  static Future<Invoiceitem> retrieve(String invoiceitemId, {final Map data}) {
    return StripeService.retrieve([Invoiceitem._path, invoiceitemId], data: data)
        .then((Map json) => new Invoiceitem.fromMap(json));
  }

  /**
   * [List all Invoice Items](https://stripe.com/docs/api/curl#list_invoiceitems)
   */
  // TODO: implement missing arguments
  static Future<InvoiceitemCollection> list({String customer, int limit, String startingAfter, String endingBefore}) {
    Map data = {};
    if (customer != null) data['customer'] = customer;
    if (limit != null) data['limit'] = limit;
    if (startingAfter != null) data['starting_after'] = startingAfter;
    if (endingBefore != null) data['ending_before'] = endingBefore;
    if (data == {}) data = null;
    return StripeService.list([Invoiceitem._path], data: data)
        .then((Map json) => new InvoiceitemCollection.fromMap(json));
  }


  /**
   * [Deleting an Invoice Item](https://stripe.com/docs/api/curl#delete_invoiceitem)
   */
  static Future delete(String invoiceitemId) => StripeService.delete([Invoiceitem._path, invoiceitemId]);


}


class InvoiceitemCollection extends ResourceCollection {

  Invoiceitem _getInstanceFromMap(map) => new Invoiceitem.fromMap(map);

  InvoiceitemCollection.fromMap(Map map) : super.fromMap(map);

}


/**
 * [Creating an Invoice Item](https://stripe.com/docs/api/curl#create_invoiceitem)
 */
class InvoiceitemCreation extends ResourceRequest {

  @required
  set customer (String customer) => _setMap('customer', customer);

  @required
  set amount (int amount) => _setMap('amount', amount);

  @required
  set currency (String currency) => _setMap('currency', currency);

  set invoice (String invoice) => _setMap('invoice', invoice);

  set subscription (String subscription) => _setMap('subscription', subscription);

  set description (String description) => _setMap('description', description);

  set metadata (Map metadata) => _setMap('metadata', metadata);

  Future<Invoiceitem> create() {
    return StripeService.create([Invoiceitem._path], _getMap())
      .then((Map json) => new Invoiceitem.fromMap(json));
  }

}


/**
 * [Updating an Invoice Item](https://stripe.com/docs/api/curl#update_invoiceitem)
 */
class InvoiceitemUpdate extends ResourceRequest {

  set amount (int amount) => _setMap('amount', amount);

  set description (String description) => _setMap('description', description);

  set metadata (Map metadata) => _setMap('metadata', metadata);

  Future<Invoiceitem> update(String invoiceitemId) {
    return StripeService.update([Invoiceitem._path, invoiceitemId], _getMap())
      .then((Map json) => new Invoiceitem.fromMap(json));
  }

}
