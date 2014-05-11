part of stripe;

/*
 * An abstract collection class that helps retrieving multiple elements of the
 * same resource.
 */
abstract class ResourceCollection<T> extends ApiResource {

  final String objectName = "list";

  List<T> get data {
    var data;
    if ((data = _dataMap["data"]) == null) return null;
    else {
      var list = new List<T>();

      for (var map in data) {
        list.add(getInstanceFromMap(map));
      }

      return list;
    }
  }


  T getInstanceFromMap(map);

  int get count => _dataMap["count"];

  String get url => _dataMap["url"];

  ResourceCollection.fromMap(Map dataMap) : super.fromMap(dataMap);
}