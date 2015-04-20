library address_tests;

import 'dart:convert';

import 'package:unittest/unittest.dart';

import '../../lib/stripe.dart';
import '../utils.dart' as utils;

var example = '''
    {
      "line1": "line1",
      "line2": "line2",
      "city": "city",
      "state": "state",
      "postal_code": "postal code",
      "country": "country"
    }''';

main(List<String> args) {
  utils.setApiKeyFromArgs(args);

  group('Address offline', () {
    test('fromMap() properly popullates all values', () {
      var map = JSON.decode(example);
      var address = new Address.fromMap(map);
      expect(address.line1, map['line1']);
      expect(address.line2, map['line2']);
      expect(address.city, map['city']);
      expect(address.state, map['state']);
      expect(address.postalCode, map['postal_code']);
      expect(address.country, map['country']);
    });
  });
}
