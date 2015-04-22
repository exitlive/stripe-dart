part of stripe;

class TosAcceptance extends Resource {
  DateTime get date => _getDateTimeFromMap('date');

  String get ip => _dataMap['ip'];

  String get userAgent => _dataMap['user_agent'];

  TosAcceptance.fromMap(Map dataMap) : super.fromMap(dataMap);
}
