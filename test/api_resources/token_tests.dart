library token_tests;

import 'dart:convert';

import 'package:unittest/unittest.dart';

import '../../lib/stripe.dart';
import '../utils.dart' as utils;

var example = '''
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
    }''';

var bankAccountExample = '''
    {
      "country": "US",
      "currency": "usd",
      "routing_number": "110000000",
      "account_number": "000123456789"
    }''';
main(List<String> args) {
  utils.setApiKeyFromArgs(args);

  group('Token offline', () {
    test('fromMap() properly popullates all values', () {
      var map = JSON.decode(example);
      var token = new Token.fromMap(map);
      expect(token.id, map['id']);
      expect(token.livemode, map['livemode']);
      expect(token.created, new DateTime.fromMillisecondsSinceEpoch(map['created'] * 1000));
      expect(token.used, map['used']);
      expect(token.type, map['type']);
      var card = token.card;
      expect(card.id, map['card']['id']);
      expect(card.last4, map['card']['last4']);
      expect(card.brand, map['card']['brand']);
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

    test('Create CardToken', () async {
      // Card fields
      var cardNumber = '4242424242424242', cardExpMonth = 12, cardExpYear = 2020, cvc = 123;
      await new CustomerCreation().create();
      var token = await (new CardTokenCreation()
            ..card = (new CardCreation()
              ..number = cardNumber
              ..expMonth = cardExpMonth
              ..expYear = cardExpYear
              ..cvc = cvc))
          .create();
      expect(token.id, new isInstanceOf<String>());
      expect(token.card.last4, cardNumber.substring(cardNumber.length - 4));
      expect(token.card.expMonth, cardExpMonth);
      expect(token.card.expYear, cardExpYear);
      expect(token.livemode, isFalse);
      expect(token.used, isFalse);
      expect(token.type, 'card');
      // testing retrieve
      token = await Token.retrieve(token.id);
      expect(token.id, new isInstanceOf<String>());
      expect(token.card.last4, cardNumber.substring(cardNumber.length - 4));
      expect(token.card.expMonth, cardExpMonth);
      expect(token.card.expYear, cardExpYear);
      expect(token.livemode, isFalse);
      expect(token.used, isFalse);
      expect(token.type, 'card');
    });

    test('Create BankAccountToken', () async {
      var bankAccountMap = JSON.decode(bankAccountExample);
      var bankAccount = new BankAccount.fromMap(bankAccountMap);

      var token = await (new BankAccountTokenCreation()..bankAccount = bankAccount).create();
      expect(token.id, new isInstanceOf<String>());
      expect(token.used, isFalse);
      expect(token.type, 'bank_account');
      expect(token.bankAccount.country, bankAccount.country);
      expect(token.bankAccount.currency, bankAccount.currency);
      expect(token.bankAccount.routingNumber, bankAccount.routingNumber);

      // testing retrieve
      token = await Token.retrieve(token.id);
      expect(token.id, new isInstanceOf<String>());
      expect(token.livemode, isFalse);
      expect(token.type, 'bank_account');
      expect(token.bankAccount.country, bankAccount.country);
      expect(token.bankAccount.currency, bankAccount.currency);
      expect(token.bankAccount.routingNumber, bankAccount.routingNumber);
    });
  });
}
