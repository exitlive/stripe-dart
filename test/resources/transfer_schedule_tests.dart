library transfer_schedule_tests;

import 'dart:convert';

import 'package:unittest/unittest.dart';

import '../../lib/stripe.dart';
import '../utils.dart' as utils;

var example = '''
    {
      "delay_days": 2,
      "interval": "manual",
      "monthly_anchor": 1,
      "weekly_anchor": "monday"
    }''';

main(List<String> args) {
  utils.setApiKeyFromArgs(args);

  group('TransferSchedule offline', () {
    test('fromMap() properly popullates all values', () {
      var map = JSON.decode(example);
      var transferSchedule = new TransferSchedule.fromMap(map);
      expect(transferSchedule.delayDays, map['delay_days']);
      expect(transferSchedule.interval, map['interval']);
      expect(transferSchedule.monthlyAnchor, map['monthly_anchor']);
      expect(transferSchedule.weeklyAnchor, map['weekly_anchor']);
    });
  });
}
