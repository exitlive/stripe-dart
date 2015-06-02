library additional_owner_tests;

import 'dart:convert';

import 'package:unittest/unittest.dart';

import '../../lib/stripe.dart';
import '../utils.dart' as utils;

import 'address_tests.dart' as address;
import 'date_tests.dart' as date;
import 'verification_tests.dart' as verification;

var example = '''
    {
      "address": ${address.example},
      "dob": ${date.example},
      "verification": ${verification.example},
      "first_name": "first_name",
      "last_name": "last_name"
    }''';

main(List<String> args) {
  utils.setApiKeyFromArgs(args);

  group('AdditionalOwner offline', () {
    test('fromMap() properly popullates all values', () {
      var map = JSON.decode(example);
      var additionalOwner = new AdditionalOwner.fromMap(map);
      expect(additionalOwner.address.toMap(), new Address.fromMap(map['address']).toMap());
      expect(additionalOwner.dateOfBirth.toMap(), new Date.fromMap(map['dob']).toMap());
      expect(additionalOwner.verification.toMap(), new Verification.fromMap(map['verification']).toMap());
      expect(additionalOwner.firstName, map['first_name']);
      expect(additionalOwner.lastName, map['last_name']);
    });
  });
}
