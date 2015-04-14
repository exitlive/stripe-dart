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
      expect(token.id, equals(map['id']));
      expect(token.livemode, equals(map['livemode']));
      expect(token.created, equals(new DateTime.fromMillisecondsSinceEpoch(map['created'] * 1000)));
      expect(token.used, equals(map['used']));
      expect(token.type, equals(map['type']));
      Card card = token.card;
      expect(card.id, equals(map['card']['id']));
      expect(card.last4, equals(map['card']['last4']));
      expect(card.type, equals(map['card']['type']));
      expect(card.expMonth, equals(map['card']['exp_month']));
      expect(card.expYear, equals(map['card']['exp_year']));
      expect(card.fingerprint, equals(map['card']['fingerprint']));
      expect(card.country, equals(map['card']['country']));
      expect(card.name, equals(map['card']['name']));
      expect(card.addressLine1, equals(map['card']['address_line1']));
      expect(card.addressLine2, equals(map['card']['address_line2']));
      expect(card.addressCity, equals(map['card']['address_city']));
      expect(card.addressState, equals(map['card']['address_state']));
      expect(card.addressZip, equals(map['card']['address_zip']));
      expect(card.addressCountry, equals(map['card']['address_country']));
      expect(card.customer, equals(map['card']['customer']));

    });

  });

  group('Token online', () {

    setUp(() {
      return utils.setUp();
    });

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
      expect(token.card.last4, equals(testCardNumber.substring(testCardNumber.length - 4)));
      expect(token.card.expMonth, equals(testCardExpMonth));
      expect(token.card.expYear, equals(testCardExpYear));
      expect(token.livemode, isFalse);
      expect(token.used, isFalse);
      expect(token.type, equals('card'));
      // testing retrieve
      token = await Token.retrieve(token.id);
      expect(token.id, new isInstanceOf<String>());
      expect(token.card.last4, equals(testCardNumber.substring(testCardNumber.length - 4)));
      expect(token.card.expMonth, equals(testCardExpMonth));
      expect(token.card.expYear, equals(testCardExpYear));
      expect(token.livemode, isFalse);
      expect(token.used, isFalse);
      expect(token.type, equals('card'));

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
      expect(token.bankAccount.country, equals(testBankAccountCountry));
      expect(token.bankAccount.last4, equals(testBankAccountAccountNumber.substring(testBankAccountAccountNumber.length - 4)));
      expect(token.livemode, isFalse);
      expect(token.used, isFalse);
      expect(token.type, equals('bank_account'));
      // testing retrieve
      token = await Token.retrieve(token.id);
      expect(token.id, new isInstanceOf<String>());
      expect(token.bankAccount.country, equals(testBankAccountCountry));
      expect(token.bankAccount.last4, equals(testBankAccountAccountNumber.substring(testBankAccountAccountNumber.length - 4)));
      expect(token.livemode, isFalse);
      expect(token.used, isFalse);
      expect(token.type, equals('bank_account'));

    });

  });

}