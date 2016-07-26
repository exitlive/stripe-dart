part of stripe;

/// ApiResources are the main resources of the Stripe API
/// Many of them provide functions to e.g. create, retrieve or delete
/// Every ApiResource has a unique [name]
abstract class ApiResource extends Resource {
  String object;

  /// Creates this api resource from a JSON string.
  ApiResource.fromMap(dataMap) : super.fromMap(dataMap) {
    assert(object != null);
    if (_dataMap == null) throw new InvalidDataReceivedException('The dataMap must not be null');
    if (_dataMap['object'] != object)
      throw new InvalidDataReceivedException('The data received was not for object ${object}');
  }
}
