library recipient_tests;

import 'dart:convert';
import 'dart:async';

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
      String testRecipientName1 = 'Test Name1';
      String testRecipientType = 'individual';
      String testRecipientTaxId1 = '111111111';
      String testRecipientEmail1 = 'test@test1.com';
      String testRecipientDescription1 = 'test description1';
      Map testRecipientMetadata1 = {'foo': 'bar1'};

      String testRecipientName2 = 'Test Name2';
      String testRecipientTaxId2 = '000000000';
      String testRecipientEmail2 = 'test@test2.com';
      String testRecipientDescription2 = 'test description2';
      Map testRecipientMetadata2 = {'foo': 'bar2'};

      // BankAccount fields
      String testBankAccountCountry = 'US';
      String testBankAccountRoutingNumber = '110000000';
      String testBankAccountAccountNumber1 = '000111111116';
      String testBankAccountAccountNumber2 = '000123456789';


      BankAccountRequest testRecipientBankAccount1 = (new BankAccountRequest()
          ..country = testBankAccountCountry
          ..routingNumber = testBankAccountRoutingNumber
          ..accountNumber = testBankAccountAccountNumber1
      );

      BankAccountRequest testRecipientBankAccount2 = (new BankAccountRequest()
          ..country = testBankAccountCountry
          ..routingNumber = testBankAccountRoutingNumber
          ..accountNumber = testBankAccountAccountNumber2
      );

      (new RecipientCreation()
          ..name = testRecipientName1
          ..type = testRecipientType
          ..bankAccount = testRecipientBankAccount1
          ..email = testRecipientEmail1
          ..description = testRecipientDescription1
          ..metadata = testRecipientMetadata1
      ).create()
      .then((Recipient recipient) {
        expect(recipient.id, new isInstanceOf<String>());
        expect(recipient.name, equals(testRecipientName1));
        expect(recipient.type, equals(testRecipientType));

        expect(recipient.activeAccount.bankName, equals('STRIPE TEST BANK'));
        expect(recipient.activeAccount.country, equals(testBankAccountCountry));
        expect(recipient.activeAccount.currency, equals('usd'));
        expect(recipient.activeAccount.last4, equals(testBankAccountAccountNumber1.substring(8)));
        expect(recipient.activeAccount.disabled, isFalse);
        expect(recipient.activeAccount.fingerprint, equals('VWNIOfZT5sKafYB2'));
        expect(recipient.activeAccount.validated, isFalse);

        expect(recipient.email, equals(testRecipientEmail1));
        expect(recipient.description, equals(testRecipientDescription1));
        expect(recipient.metadata, equals(testRecipientMetadata1));
        return Recipient.retrieve(recipient.id);
      })
      .then((Recipient recipient) {
        expect(recipient.id, new isInstanceOf<String>());
        expect(recipient.name, equals(testRecipientName1));
        expect(recipient.type, equals(testRecipientType));

        expect(recipient.activeAccount.bankName, equals('STRIPE TEST BANK'));
        expect(recipient.activeAccount.country, equals(testBankAccountCountry));
        expect(recipient.activeAccount.currency, equals('usd'));
        expect(recipient.activeAccount.last4, equals(testBankAccountAccountNumber1.substring(8)));
        expect(recipient.activeAccount.disabled, isFalse);
        expect(recipient.activeAccount.fingerprint, equals('VWNIOfZT5sKafYB2'));
        expect(recipient.activeAccount.validated, isFalse);

        expect(recipient.email, equals(testRecipientEmail1));
        expect(recipient.description, equals(testRecipientDescription1));
        expect(recipient.metadata, equals(testRecipientMetadata1));
        return (new RecipientUpdate()
            ..name = testRecipientName2
            ..taxId = testRecipientTaxId2
            ..bankAccount = testRecipientBankAccount2
            ..email = testRecipientEmail2
            ..description = testRecipientDescription2
            ..metadata = testRecipientMetadata2
        ).update(recipient.id);
      })
      .then((Recipient recipient) {
        expect(recipient.id, new isInstanceOf<String>());
        expect(recipient.name, equals(testRecipientName2));
        expect(recipient.type, equals(testRecipientType));

        expect(recipient.activeAccount.bankName, equals('STRIPE TEST BANK'));
        expect(recipient.activeAccount.country, equals(testBankAccountCountry));
        expect(recipient.activeAccount.currency, equals('usd'));
        expect(recipient.activeAccount.last4, equals(testBankAccountAccountNumber2.substring(8)));
        expect(recipient.activeAccount.disabled, isFalse);
        expect(recipient.activeAccount.fingerprint, equals('w3wTQ7xfYhoIBIcK'));
        expect(recipient.activeAccount.validated, isFalse);

        expect(recipient.email, equals(testRecipientEmail2));
        expect(recipient.description, equals(testRecipientDescription2));
        expect(recipient.metadata, equals(testRecipientMetadata2));
      })
      .then(expectAsync((_) => true));

    });

    test('Delete Recipient', () {
      // Recipient fields
      Recipient testRecipient;
      String testRecipientName = 'test name';
      String testRecipientType = 'corporation';
      (new RecipientCreation()
          ..name = testRecipientName
          ..type = testRecipientType
      ).create()
      .then((Recipient recipient) {
        testRecipient = recipient;
        expect(recipient.id, new isInstanceOf<String>());
        expect(recipient.name, equals(testRecipientName));
        expect(recipient.type, equals(testRecipientType));
        return Recipient.delete(recipient.id);
      })
      .then((Map response) {
        expect(response['deleted'], isTrue);
        expect(response['id'], equals(testRecipient.id));
      })
      .then(expectAsync((_) => true));

    });

    test('List parameters Recipient', () {
      // Recipient fields
      Recipient testRecipient;
      String testRecipientName = 'test name';
      String testRecipientType = 'corporation';


      List<Future> queue = [];
      for (var i = 0; i < 20; i++) {
        queue.add((new RecipientCreation()
            ..name = testRecipientName + i.toString()
            ..type = testRecipientType
        ).create());
      }

      Future.wait(queue)
      .then((_) => Recipient.list(limit: 10))
      .then((RecipientCollection recipients) {
        expect(recipients.data.length, equals(10));
        expect(recipients.hasMore, equals(true));
        return Recipient.list(limit: 10, startingAfter: recipients.data.last.id);
      })
      .then((RecipientCollection recipients) {
        expect(recipients.data.length, equals(10));
        expect(recipients.hasMore, equals(false));
        return Recipient.list(limit: 10, endingBefore: recipients.data.first.id);
      })
      .then((RecipientCollection recipients) {
        expect(recipients.data.length, equals(10));
        expect(recipients.hasMore, equals(false));
      })
      .then(expectAsync((_) => true));

    });



  });

}