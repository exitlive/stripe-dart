part of stripe;

class PlanCollection extends ResourceCollection {

  Plan getInstanceFromMap(map) => new Plan.fromMap(map);

  PlanCollection.fromMap(Map map) : super.fromMap(map);

}