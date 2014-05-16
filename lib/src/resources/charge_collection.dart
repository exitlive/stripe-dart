part of stripe;

class ChargeCollection extends ResourceCollection {

  Charge _getInstanceFromMap(map) => new Charge.fromMap(map);

  ChargeCollection.fromMap(Map map) : super.fromMap(map);

}