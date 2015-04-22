part of stripe;

class TransferSchedule extends Resource {
  int get delayDays => _dataMap['delay_days'];

  String get interval => _dataMap['interval'];

  int get monthlyAnchor => _dataMap['monthly_anchor'];

  String get weeklyAnchor => _dataMap['weekly_anchor'];

  TransferSchedule.fromMap(Map dataMap) : super.fromMap(dataMap);
}
