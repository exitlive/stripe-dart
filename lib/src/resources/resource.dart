part of stripe;

/**
 * All objects sent through the Stripe REST API are [Resource]s, but only
 * [ApiResource]s can be created, deleted, etc...
 *
 * Instances of this Class can only be retrieved through the use of another
 * [ApiResource].
 */
abstract class Resource {

  final Map _dataMap;

  final String objectName = null;

  /// Creates this resource from a JSON string.
  Resource.fromMap(this._dataMap) {
    assert(objectName != null);
    if (_dataMap["object"] != objectName) throw new InvalidDataReceivedException("The data received was not for object ${objectName}");
  }

  /**
   * Whenever a value has to be transformed when retrieved (like a DateTime),
   * it is cached in this map to avoid duplicating objects.
   */
  Map _cachedDataMap = { };

  /**
   * Returns a DateTime from given dataMap key, and caches the value for future
   * use.
   */
  DateTime _getDateTimeFromMap(String key) {
    var cachedValue;
    if ((cachedValue = _cachedDataMap[key]) != null) return cachedValue;

    int value = _dataMap[key];
    cachedValue = new DateTime.fromMillisecondsSinceEpoch(value * 1000);
    _cachedDataMap[key] = cachedValue;

    return cachedValue;
  }

}




/**
 * The base class for request resources (eg: [CustomerCreation],
 * [CustomerUpdate], etc...)
 */
abstract class ResourceRequest {

  /**
   * Holds all values that have been set/changed.
   * You should not access this map directly, but use [_setMap] and [_getMap].
   */
  Map<String, dynamic> _map = { };


  _setMap(String key, dynamic value) {
    // TODO write a better exception
    if (_map.containsKey(key)) throw new BadRequestException("You can't set the same key twice.");
    _map[key] = value;
  }


  /**
   * Returns the [_map] and checks that all [required] fields are set.
   *
   * TODO check if all fields that are marked as [required] are set.
   */
  _getMap() => _map;

}