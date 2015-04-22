part of stripe;

class Date extends Resource {
  int get day => _dataMap['day'];

  int get month => _dataMap['month'];

  int get year => _dataMap['year'];

  Date.fromMap(Map dataMap) : super.fromMap(dataMap);
}
