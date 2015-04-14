library recipient_tests;

import 'dart:convert';

import 'package:unittest/unittest.dart';

import '../../lib/stripe.dart';
import '../utils.dart' as utils;


var exampleRecipient = """
    {
      "id": "rp_14gyAY41dfVNZFcqD6nfNcbw",
      "object": "recipient",
      "created": 1411735794,
      "livemode": true,
      "type": "individual",
      "description": "Recipient for John Doe",
      "email": "test@example.com",
      "name": "John Doe",
      "verified": false,
      "metadata": {
      },
      "active_account": null,
      "cards": {
        "object": "list",
        "total_count": 0,
        "has_more": false,
        "url": "/v1/recipients/rp_14gyAY41dfVNZFcqD6nfNcbw/cards",
        "data": [
    
        ]
      },
      "default_card": null
    }""";


main(List<String> args) {

  utils.setApiKeyFromArgs(args);

  group('Recipient offline', () {

    test('fromMap() properly popullates all values', () {

      var map = JSON.decode(exampleRecipient);
      var recipient = new Recipient.fromMap(map);
      expect(recipient.id, equals(map['id']));
      expect(recipient.created, equals(new DateTime.fromMillisecondsSinceEpoch(map['created'] * 1000)));
      expect(recipient.livemode, equals(map['livemode']));
      expect(recipient.type, equals(map['type']));
      expect(recipient.description, equals(map['description']));
      expect(recipient.email, equals(map['email']));
      expect(recipient.name, equals(map['name']));
      expect(recipient.verified, equals(map['verified']));
      expect(recipient.metadata, equals(map['metadata']));
      expect(recipient.activeAccount, equals(map['active_account']));

    });

  });

  group('Recipient online', () {

    setUp(() {
      return utils.setUp();
    });

    tearDown(() {
      return utils.tearDown();
    });

    test('RecipientCreation minimal', () async {

      // Recipient fields
      String testRecipientName = 'test name';
      String testRecipientType = 'corporation';

      Recipient recipient = await (new RecipientCreation()
          ..name = testRecipientName
          ..type = testRecipientType
      ).create();
      expect(recipient.id, new isInstanceOf<String>());
      expect(recipient.name, equals(testRecipientName));
      expect(recipient.type, equals(testRecipientType));

    });

    test('RecipientCreation full', () async {

      // Recipient fields
      String testRecipientName1 = 'Test Name1';
      String testRecipientType = 'individual';
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

      Recipient recipient = await (new RecipientCreation()
          ..name = testRecipientName1
          ..type = testRecipientType
          ..bankAccount = testRecipientBankAccount1
          ..email = testRecipientEmail1
          ..description = testRecipientDescription1
          ..metadata = testRecipientMetadata1
      ).create();
      expect(recipient.id, new isInstanceOf<String>());
      expect(recipient.name, equals(testRecipientName1));
      expect(recipient.type, equals(testRecipientType));

      expect(recipient.activeAccount.country, equals(testBankAccountCountry));
      expect(recipient.activeAccount.currency, equals('usd'));
      expect(recipient.activeAccount.last4, equals(testBankAccountAccountNumber1.substring(8)));
      expect(recipient.activeAccount.status, 'new');

      expect(recipient.email, equals(testRecipientEmail1));
      expect(recipient.description, equals(testRecipientDescription1));
      expect(recipient.metadata, equals(testRecipientMetadata1));
      recipient = await Recipient.retrieve(recipient.id);
      expect(recipient.id, new isInstanceOf<String>());
      expect(recipient.name, equals(testRecipientName1));
      expect(recipient.type, equals(testRecipientType));

      expect(recipient.activeAccount.country, equals(testBankAccountCountry));
      expect(recipient.activeAccount.currency, equals('usd'));
      expect(recipient.activeAccount.last4, equals(testBankAccountAccountNumber1.substring(8)));
      expect(recipient.activeAccount.status, 'new');

      expect(recipient.email, equals(testRecipientEmail1));
      expect(recipient.description, equals(testRecipientDescription1));
      expect(recipient.metadata, equals(testRecipientMetadata1));
      recipient = await (new RecipientUpdate()
          ..name = testRecipientName2
          ..taxId = testRecipientTaxId2
          ..bankAccount = testRecipientBankAccount2
          ..email = testRecipientEmail2
          ..description = testRecipientDescription2
          ..metadata = testRecipientMetadata2
      ).update(recipient.id);
      expect(recipient.id, new isInstanceOf<String>());
      expect(recipient.name, equals(testRecipientName2));
      expect(recipient.type, equals(testRecipientType));

      expect(recipient.activeAccount.country, equals(testBankAccountCountry));
      expect(recipient.activeAccount.currency, equals('usd'));
      expect(recipient.activeAccount.last4, equals(testBankAccountAccountNumber2.substring(8)));
      expect(recipient.activeAccount.status, 'new');

      expect(recipient.email, equals(testRecipientEmail2));
      expect(recipient.description, equals(testRecipientDescription2));
      expect(recipient.metadata, equals(testRecipientMetadata2));

    });

    test('Delete Recipient', () async {

      // Recipient fields
      String testRecipientName = 'test name';
      String testRecipientType = 'corporation';
      Recipient recipient = await (new RecipientCreation()
          ..name = testRecipientName
          ..type = testRecipientType
      ).create();
      expect(recipient.id, new isInstanceOf<String>());
      expect(recipient.name, equals(testRecipientName));
      expect(recipient.type, equals(testRecipientType));
      Map response = await Recipient.delete(recipient.id);
      expect(response['deleted'], isTrue);
      expect(response['id'], equals(recipient.id));

    });

    test('List parameters Recipient', () async {

      // Recipient fields
      String testRecipientName = 'test name';
      String testRecipientType = 'corporation';

      for (var i = 0; i < 20; i++) {
        await (new RecipientCreation()
            ..name = testRecipientName + i.toString()
            ..type = testRecipientType
        ).create();
      }

      RecipientCollection recipients = await Recipient.list(limit: 10);
      expect(recipients.data.length, equals(10));
      expect(recipients.hasMore, equals(true));
      recipients = await Recipient.list(limit: 10, startingAfter: recipients.data.last.id);
      expect(recipients.data.length, equals(10));
      expect(recipients.hasMore, equals(false));
      recipients = await Recipient.list(limit: 10, endingBefore: recipients.data.first.id);
      expect(recipients.data.length, equals(10));
      expect(recipients.hasMore, equals(false));

    });

  });

}