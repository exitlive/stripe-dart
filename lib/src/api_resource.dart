part of stripe;

/// ApiResources are resources that can be created and sent to the Stripe REST Api.
abstract class ApiResource extends Resource {
  ApiResource.fromMap(Map map) : super.fromMap(map);
}
