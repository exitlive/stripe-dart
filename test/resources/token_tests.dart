library token_tests;

import 'dart:convert';

import 'package:unittest/unittest.dart';

import '../../lib/stripe.dart';
import '../utils.dart' as utils;


var exampleToken = """
    {
      "id": "tok_103z9O41dfVNZFcqpeOFk6jX",
      "livemode": false,
      "created": 1399392437,
      "used": false,
      "object": "token",
      "type": "card",
      "card": {
        "id": "card_103z9O41dfVNZFcqrVvPvM2f",
        "object": "card",
        "last4": "4242",
        "type": "Visa",
        "exp_month": 8,
        "exp_year": 2016,
        "fingerprint": "2OcV4uXscDkio6R5",
        "country": "US",
        "name": null,
        "address_line1": null,
        "address_line2": null,
        "address_city": null,
        "address_state": null,
        "address_zip": null,
        "address_country": null,
        "customer": null
      }
    }""";


main(List<String> args) {

  utils.setApiKeyFromArgs(args);

  group('Token offline', () {

    test('fromMap() properly popullates all values', () {

      var map = JSON.decode(exampleToken);
      var token = new Token.fromMap(map);
      expect(token.id, map['id']);
      expect(token.livemode, map['livemode']);
      expect(token.created, new DateTime.fromMillisecondsSinceEpoch(map['created'] * 1000));
      expect(token.used, map['used']);
      expect(token.type, map['type']);
      Card card = token.card;
      expect(card.id, map['card']['id']);
      expect(card.last4, map['card']['last4']);
      expect(card.type, map['card']['type']);
      expect(card.expMonth, map['card']['exp_month']);
      expect(card.expYear, map['card']['exp_year']);
      expect(card.fingerprint, map['card']['fingerprint']);
      expect(card.country, map['card']['country']);
      expect(card.name, map['card']['name']);
      expect(card.addressLine1, map['card']['address_line1']);
      expect(card.addressLine2, map['card']['address_line2']);
      expect(card.addressCity, map['card']['address_city']);
      expect(card.addressState, map['card']['address_state']);
      expect(card.addressZip, map['card']['address_zip']);
      expect(card.addressCountry, map['card']['address_country']);
      expect(card.customer, map['card']['customer']);

    });

  });

  group('Token online', () {

    tearDown(() {
      return utils.tearDown();
    });

    test('CardTokenCreation', () async {

      // Card fields
      String testCardNumber = '4242424242424242';
      int testCardExpMonth = 12;
      int testCardExpYear = 2016;
      await new CustomerCreation().create();
      Token token = await (new CardTokenCreation()
          ..card = (new CardCreation()
          ..number = testCardNumber
          ..expMonth = testCardExpMonth
          ..expYear = testCardExpYear
      )).create();
      expect(token.id, new isInstanceOf<String>());
      expect(token.card.last4, testCardNumber.substring(testCardNumber.length - 4));
      expect(token.card.expMonth, testCardExpMonth);
      expect(token.card.expYear, testCardExpYear);
      expect(token.livemode, isFalse);
      expect(token.used, isFalse);
      expect(token.type, 'card');
      // testing retrieve
      token = await Token.retrieve(token.id);
      expect(token.id, new isInstanceOf<String>());
      expect(token.card.last4, testCardNumber.substring(testCardNumber.length - 4));
      expect(token.card.expMonth, testCardExpMonth);
      expect(token.card.expYear, testCardExpYear);
      expect(token.livemode, isFalse);
      expect(token.used, isFalse);
      expect(token.type, 'card');

    });

    test('BankAccountTokenCreation', () async {

      // BankAccount fields
      String testBankAccountCountry = 'US';
      String testBankAccountRoutingNumber = '110000000';
      String testBankAccountAccountNumber = '000123456789';

      BankAccountRequest testBankAccount = (new BankAccountRequest()
          ..country = testBankAccountCountry
          ..routingNumber = testBankAccountRoutingNumber
          ..accountNumber = testBankAccountAccountNumber
      );

      Token token = await (new BankAccountTokenCreation()
          ..bankAccount = testBankAccount
      ).create();
      expect(token.id, new isInstanceOf<String>());
      expect(token.bankAccount.country, testBankAccountCountry);
      expect(token.bankAccount.last4, testBankAccountAccountNumber.substring(testBankAccountAccountNumber.length - 4));
      expect(token.livemode, isFalse);
      expect(token.used, isFalse);
      expect(token.type, 'bank_account');
      // testing retrieve
      token = await Token.retrieve(token.id);
      expect(token.id, new isInstanceOf<String>());
      expect(token.bankAccount.country, testBankAccountCountry);
      expect(token.bankAccount.last4, testBankAccountAccountNumber.substring(testBankAccountAccountNumber.length - 4));
      expect(token.livemode, isFalse);
      expect(token.used, isFalse);
      expect(token.type, 'bank_account');

    });

  });

}