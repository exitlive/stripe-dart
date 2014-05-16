part of stripe;


class PlanCollection extends ResourceCollection {

  Plan _getInstanceFromMap(map) => new Plan.fromMap(map);

  PlanCollection.fromMap(Map map) : super.fromMap(map);

}