part of stripe;

/// All objects sent through the Stripe REST API are [Resource]s, but only
/// [ApiResource]s can be created, deleted, etc...
///
/// Instances of this Class can only be retrieved through the use of another
/// [ApiResource].
abstract class Resource {
  final Map _dataMap;

  /// Creates this resource from a JSON string.
  Resource.fromMap(this._dataMap);

  /// Whenever a value has to be transformed when retrieved (like a DateTime),
  /// it is cached in this map to avoid duplicating objects.
  Map _cachedDataMap = {};

  /// Returns a DateTime from given dataMap key, and caches the value for future
  /// use.
  DateTime _getDateTimeFromMap(String key) {
    var cachedValue;
    if ((cachedValue = _cachedDataMap[key]) != null) return cachedValue;
    if (_dataMap[key] == null) return null;
    int value = _dataMap[key];
    cachedValue = new DateTime.fromMillisecondsSinceEpoch(value * 1000);
    _cachedDataMap[key] = cachedValue;
    return cachedValue;
  }

  Map toMap() {
    return _dataMap;
  }

  String _getIdForExpandable(String key) {
    var value = _dataMap[key];
    if (value is String) return value;
    else if (value is Map && value.containsKey('id')) return value['id'];
    else return null;
  }
}

/// The base class for request resources (eg: [CustomerCreation],
/// [CustomerUpdate], etc...)
abstract class ResourceRequest {

  /// Holds all values that have been set/changed.
  /// You should not access this map directly, but use [_setMap] and [_getMap].
  Map<String, dynamic> _map = {};

  _setMap(String key, dynamic value) {
    // TODO write a better exception
    if (_map.containsKey(key)) throw new BadRequestException('You can not set the same key twice.');
    _map[key] = value;
  }

  /// Returns the [_map] and checks that all [required] fields are set.
  _getMap() {
    ClassMirror classMirror = reflect(this).type;
    Map<Symbol, MethodMirror> methods = classMirror.instanceMembers;
    methods.forEach((symbol, method) {
      if (method.isSetter) {
        method.metadata.forEach((InstanceMirror instanceMirror) {
          if (instanceMirror.reflectee.runtimeType == Required) {
            var symbolName = MirrorSystem.getName(method.simpleName);
            var setterCamelCase = symbolName.substring(0, symbolName.length - 1);
            var setter = _underscore(setterCamelCase);
            String className = MirrorSystem.getName(classMirror.simpleName);
            if (_map[setter] ==
                null) throw new MissingArgumentException('You have to set ${setter} for a proper ${className} request');
          }
        });
      }
    });
    _map.forEach((k, v) {
      if (v is ResourceRequest) _map[k] = v._getMap();
    });
    return _map;
  }

  String _underscore(String camelized) {
    return camelized.replaceAllMapped(new RegExp(r'([A-Z])'), (Match match) => '_${match.group(1).toLowerCase()}');
  }

  String toString() {
    return _map.toString();
  }
}
