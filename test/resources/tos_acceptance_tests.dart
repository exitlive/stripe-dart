library tos_acceptance_tests;

import 'dart:convert';

import 'package:unittest/unittest.dart';

import '../../lib/stripe.dart';
import '../utils.dart' as utils;

var example = '''
    {
      "date": 1399894618,
      "ip": "127.0.0.1",
      "user_agent": "user_agent"
    }''';

main(List<String> args) {
  utils.setApiKeyFromArgs(args);

  group('TosAcceptance offline', () {
    test('fromMap() properly popullates all values', () {
      var map = JSON.decode(example);
      var tosAcceptance = new TosAcceptance.fromMap(map);
      expect(tosAcceptance.date, new DateTime.fromMillisecondsSinceEpoch(map['date'] * 1000));
      expect(tosAcceptance.ip, map['ip']);
      expect(tosAcceptance.userAgent, map['user_agent']);
    });
  });
}
