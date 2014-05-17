part of stripe;


class InvoiceLineItemCollection extends ResourceCollection {

  InvoiceLineItem _getInstanceFromMap(map) => new InvoiceLineItem.fromMap(map);

  InvoiceLineItemCollection.fromMap(Map map) : super.fromMap(map);

}