library recipient_tests;

import 'dart:convert';

import 'package:unittest/unittest.dart';

import '../../lib/stripe.dart';
import '../utils.dart' as utils;

var exampleRecipient = '''
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
    }''';

main(List<String> args) {
  utils.setApiKeyFromArgs(args);

  group('Recipient offline', () {
    test('fromMap() properly popullates all values', () {
      var map = JSON.decode(exampleRecipient);
      var recipient = new Recipient.fromMap(map);
      expect(recipient.id, map['id']);
      expect(recipient.created, new DateTime.fromMillisecondsSinceEpoch(map['created'] * 1000));
      expect(recipient.livemode, map['livemode']);
      expect(recipient.type, map['type']);
      expect(recipient.description, map['description']);
      expect(recipient.email, map['email']);
      expect(recipient.name, map['name']);
      expect(recipient.verified, map['verified']);
      expect(recipient.metadata, map['metadata']);
      expect(recipient.activeAccount, map['active_account']);
    });
  });

  group('Recipient online', () {
    tearDown(() {
      return utils.tearDown();
    });

    test('RecipientCreation minimal', () async {

      // Recipient fields
      var recipientName = 'test name',
          recipientType = 'corporation';

      var recipient = await (new RecipientCreation()
        ..name = recipientName
        ..type = recipientType).create();
      expect(recipient.id, new isInstanceOf<String>());
      expect(recipient.name, recipientName);
      expect(recipient.type, recipientType);
    });

    test('RecipientCreation full', () async {

      // Recipient fields
      var recipientName1 = 'Test Name1',
          recipientType = 'individual',
          recipientEmail1 = 'test@test1.com',
          recipientDescription1 = 'test description1',
          recipientMetadata1 = {'foo': 'bar1'},
          recipientName2 = 'Test Name2',
          recipientTaxId2 = '000000000',
          recipientEmail2 = 'test@test2.com',
          recipientDescription2 = 'test description2',
          recipientMetadata2 = {'foo': 'bar2'},

          // BankAccount fields
          bankAccountCountry = 'US',
          bankAccountRoutingNumber = '110000000',
          bankAccountAccountNumber1 = '000111111116',
          bankAccountAccountNumber2 = '000123456789';

      var recipientBankAccount1 = (new BankAccountRequest()
        ..country = bankAccountCountry
        ..routingNumber = bankAccountRoutingNumber
        ..accountNumber = bankAccountAccountNumber1);

      var recipientBankAccount2 = (new BankAccountRequest()
        ..country = bankAccountCountry
        ..routingNumber = bankAccountRoutingNumber
        ..accountNumber = bankAccountAccountNumber2);

      var recipient = await (new RecipientCreation()
        ..name = recipientName1
        ..type = recipientType
        ..bankAccount = recipientBankAccount1
        ..email = recipientEmail1
        ..description = recipientDescription1
        ..metadata = recipientMetadata1).create();
      expect(recipient.id, new isInstanceOf<String>());
      expect(recipient.name, recipientName1);
      expect(recipient.type, recipientType);

      expect(recipient.activeAccount.country, bankAccountCountry);
      expect(recipient.activeAccount.currency, 'usd');
      expect(recipient.activeAccount.last4, bankAccountAccountNumber1.substring(8));
      expect(recipient.activeAccount.status, 'new');

      expect(recipient.email, recipientEmail1);
      expect(recipient.description, recipientDescription1);
      expect(recipient.metadata, recipientMetadata1);
      recipient = await Recipient.retrieve(recipient.id);
      expect(recipient.id, new isInstanceOf<String>());
      expect(recipient.name, recipientName1);
      expect(recipient.type, recipientType);

      expect(recipient.activeAccount.country, bankAccountCountry);
      expect(recipient.activeAccount.currency, 'usd');
      expect(recipient.activeAccount.last4, bankAccountAccountNumber1.substring(8));
      expect(recipient.activeAccount.status, 'new');

      expect(recipient.email, recipientEmail1);
      expect(recipient.description, recipientDescription1);
      expect(recipient.metadata, recipientMetadata1);
      recipient = await (new RecipientUpdate()
        ..name = recipientName2
        ..taxId = recipientTaxId2
        ..bankAccount = recipientBankAccount2
        ..email = recipientEmail2
        ..description = recipientDescription2
        ..metadata = recipientMetadata2).update(recipient.id);
      expect(recipient.id, new isInstanceOf<String>());
      expect(recipient.name, recipientName2);
      expect(recipient.type, recipientType);

      expect(recipient.activeAccount.country, bankAccountCountry);
      expect(recipient.activeAccount.currency, 'usd');
      expect(recipient.activeAccount.last4, bankAccountAccountNumber2.substring(8));
      expect(recipient.activeAccount.status, 'new');

      expect(recipient.email, recipientEmail2);
      expect(recipient.description, recipientDescription2);
      expect(recipient.metadata, recipientMetadata2);
    });

    test('Delete Recipient', () async {

      // Recipient fields
      var recipientName = 'test name',
          recipientType = 'corporation';
      var recipient = await (new RecipientCreation()
        ..name = recipientName
        ..type = recipientType).create();
      expect(recipient.id, new isInstanceOf<String>());
      expect(recipient.name, recipientName);
      expect(recipient.type, recipientType);
      var response = await Recipient.delete(recipient.id);
      expect(response['deleted'], isTrue);
      expect(response['id'], recipient.id);
    });

    test('List parameters Recipient', () async {

      // Recipient fields
      var recipientName = 'test name',
          recipientType = 'corporation';

      for (var i = 0; i < 20; i++) {
        await (new RecipientCreation()
          ..name = recipientName + i.toString()
          ..type = recipientType).create();
      }

      var recipients = await Recipient.list(limit: 10);
      expect(recipients.data.length, 10);
      expect(recipients.hasMore, isTrue);
      recipients = await Recipient.list(limit: 10, startingAfter: recipients.data.last.id);
      expect(recipients.data.length, 10);
      expect(recipients.hasMore, isFalse);
      recipients = await Recipient.list(limit: 10, endingBefore: recipients.data.first.id);
      expect(recipients.data.length, 10);
      expect(recipients.hasMore, isFalse);
    });
  });
}
