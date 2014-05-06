part of stripe;

class CustomerCollection extends ApiResource {

  final String objectName = "list";

  List<Customer> get data {
    var value;
    if ((value = _dataMap["data"]) == null) return null;
    else {
      var customers = new List<Customer>();

      for (var customerData in value) {
        customers.add(new Customer.fromMap(customerData));
      }

      return customers;
    }
  }

  int get count => _dataMap["count"];

  String get url => _dataMap["url"];

  CustomerCollection.fromMap(Map dataMap) : super.fromMap(dataMap);

}