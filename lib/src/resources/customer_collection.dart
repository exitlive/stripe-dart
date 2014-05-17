part of stripe;


class CustomerCollection extends ResourceCollection {

  Customer _getInstanceFromMap(map) => new Customer.fromMap(map);

  CustomerCollection.fromMap(Map map) : super.fromMap(map);

}