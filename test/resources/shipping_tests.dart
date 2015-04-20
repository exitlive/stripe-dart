library shipping_tests;

import 'dart:convert';

import 'package:unittest/unittest.dart';

import '../../lib/stripe.dart';
import '../utils.dart' as utils;

import 'address_tests.dart' as address;

var example = '''
    {
      "address": ${address.example},
      "name": "name",
      "carrier": "carrier",
      "phone": "phone",
      "tracking_number": "tracking_number"
    }''';

main(List<String> args) {
  utils.setApiKeyFromArgs(args);

  group('Shipping offline', () {
    test('fromMap() properly popullates all values', () {
      var map = JSON.decode(example);
      var shipping = new Shipping.fromMap(map);
      expect(shipping.address.toMap(), new Address.fromMap(map['address']).toMap());
      expect(shipping.name, map['name']);
      expect(shipping.carrier, map['carrier']);
      expect(shipping.phone, map['phone']);
      expect(shipping.trackingNumber, map['tracking_number']);
    });
  });
}
