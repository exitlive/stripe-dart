library legal_entity_tests;

import 'dart:convert';

import 'package:unittest/unittest.dart';

import '../../lib/stripe.dart';
import '../utils.dart' as utils;

import 'additional_owner_tests.dart' as additional_owner;
import 'address_tests.dart' as address;
import 'date_tests.dart' as date;
import 'verification_tests.dart' as verification;

var example = '''
    {
      "address": ${address.example},
      "dob": ${date.example},
      "personal_address": ${address.example},
      "verification": ${verification.example},
      "additional_owners": [${additional_owner.example}],
      "business_name": "business_name",
      "first_name": "first_name",
      "last_name": "last_name",
      "type": "type"
    }''';

main(List<String> args) {
  utils.setApiKeyFromArgs(args);

  group('LegalEntity offline', () {
    test('fromMap() properly popullates all values', () {
      var map = JSON.decode(example);
      var legalEntity = new LegalEntity.fromMap(map);
      expect(legalEntity.address.toMap(), new Address.fromMap(map['address']).toMap());
      expect(legalEntity.dateOfBirth.toMap(), new Date.fromMap(map['dob']).toMap());
      expect(legalEntity.personalAddress.toMap(), new Address.fromMap(map['personal_address']).toMap());
      expect(legalEntity.additionalOwners.first.toMap(), new Address.fromMap(map['additional_owners'].first).toMap());
      expect(legalEntity.businessName, map['business_name']);
      expect(legalEntity.firstName, map['first_name']);
      expect(legalEntity.lastName, map['last_name']);
      expect(legalEntity.type, map['type']);
    });
  });
}
