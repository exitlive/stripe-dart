library date_tests;

import 'dart:convert';

import 'package:unittest/unittest.dart';

import '../../lib/stripe.dart';
import '../utils.dart' as utils;

var example = '''
    {
      "day": 1,
      "month": 1,
      "year": 1980
    }''';

main(List<String> args) {
  utils.setApiKeyFromArgs(args);

  solo_group('Date offline', () {
    test('fromMap() properly popullates all values', () {
      var map = JSON.decode(example);
      var date = new Date.fromMap(map);
      expect(date.day, map['day']);
      expect(date.month, map['month']);
      expect(date.year, map['year']);
    });
  });
}
