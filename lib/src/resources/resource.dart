part of stripe;

/**
 * All objects sent through the Stripe REST API are [Resource]s, but only
 * [ApiResource]s can be created, deleted, etc...
 *
 * Instances of this Class can only be retrieved through the use of another
 * [ApiResource].
 */
abstract class Resource {

  /// Creates this resource from a JSON string.
  Resource.fromMap(Map map);

}