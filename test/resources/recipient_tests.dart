library recipient_tests;

import 'dart:convert';

import 'package:unittest/unittest.dart';

import '../../lib/stripe.dart';
import '../utils.dart' as utils;

var exampleAccount = """
    {
      "id": "rp_1044M141dfVNZFcqeFYdRcQN",
      "object": "recipient",
      "created": 1400592618,
      "livemode": true,
      "type": "individual",
      "description": "Recipient for John Doe",
      "email": "test@example.com",
      "name": "John Doe",
      "verified": false,
      "metadata": {
      },
      "active_account": null
    }""";


main(List<String> args) {

  utils.setApiKeyFromArgs(args);

  group('Recipient offline', () {

    test('fromMap() properly popullates all values', () {
      var map = JSON.decode(exampleAccount);

      var recipient = new Recipient.fromMap(map);

      expect(recipient.id, equals(map['id']));
      expect(recipient.created, equals(new DateTime.fromMillisecondsSinceEpoch(map['created'] * 1000)));
      expect(recipient.livemode, equals(map['livemode']));
      expect(recipient.type, equals(map['type']));
      expect(recipient.description, equals(map['description']));
      expect(recipient.email, equals(map['email']));
      expect(recipient.name, equals(map['name']));
      expect(recipient.verified, equals(map['verified']));
      expect(recipient.livemode, equals(map['livemode']));

    });


  });

  group('Recipient online', () {

    setUp(() {
      return utils.setUp();
    });

    tearDown(() {
      return utils.tearDown();
    });

    test('RecipientCreation minimal', () {

      // Recipient fields
      String testRecipientName = 'test name';
      String testRecipientType = 'corporation';

      (new RecipientCreation()
          ..name = testRecipientName
          ..type = testRecipientType
      ).create()
      .then((Recipient recipient) {
        expect(recipient.id, new isInstanceOf<String>());
        expect(recipient.name, equals(testRecipientName));
        expect(recipient.type, equals(testRecipientType));
      })
      .then(expectAsync((_) => true));

    });

    test('RecipientCreation full', () {

      // Recipient fields
      String testRecipientName = 'test name';
      String testRecipientType = 'corporation';
      String testRecipientTaxId = '000000000';
      String testRecipientEmail = 'test@test.com';
      String testRecipientDescription = 'test description';
      Map testRecipientMetadata = {'foo': 'bar'};

      // BankAccount fields
      String testBankAccountCountry = 'US';
      String testBankAccountRoutingNumber = '110000000';
      String testBankAccountAccountNumber = '000123456789';


      BankAccountRequest testRecipientBankAccount = (new BankAccountRequest()
          ..country = testBankAccountCountry
          ..routingNumber = testBankAccountRoutingNumber
          ..accountNumber = testBankAccountAccountNumber
      );

      (new RecipientCreation()
          ..name = testRecipientName
          ..type = testRecipientType
          ..bankAccount = testRecipientBankAccount
          ..email = testRecipientEmail
          ..description = testRecipientDescription
          ..metadata = testRecipientMetadata
      ).create()
      .then((Recipient recipient) {
        expect(recipient.id, new isInstanceOf<String>());
        expect(recipient.name, equals(testRecipientName));
        expect(recipient.type, equals(testRecipientType));
      })
      .then(expectAsync((_) => true));

    });


  });

}