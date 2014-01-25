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
    if (_dataMap["object"] != objectName) throw new InvalidDataReceived("The data received was not for object ${objectName}");
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