library account_tests;

import 'dart:convert';

import 'package:unittest/unittest.dart';

import '../../lib/stripe.dart';
import '../utils.dart' as utils;

var exampleAccount = """
    {
      "id": "acct_103yoB41dfVNZFcq",
      "email": "martin.flucka@gmail.com",
      "statement_descriptor": null,
      "display_name": null,
      "timezone": "Etc/UTC",
      "details_submitted": false,
      "charge_enabled": false,
      "transfer_enabled": false,
      "currencies_supported": [
        "usd",
        "aed",
        "afn"
      ],
      "default_currency": "usd",
      "country": "US",
      "object": "account"
    }""";

main(List<String> args) {
  utils.setApiKeyFromArgs(args);

  group('Account offline', () {
    test('fromMap() properly popullates all values', () {
      var map = JSON.decode(exampleAccount);
      var account = new Account.fromMap(map);
      expect(account.id, map['id']);
      expect(account.email, map['email']);
      expect(account.statementDescriptor, map['statement_descriptor']);
      expect(account.displayName, map['display_name']);
      expect(account.timezone, map['timezone']);
      expect(account.detailsSubmitted, map['details_submitted']);
      expect(account.chargeEnabled, map['charge_enabled']);
      expect(account.transferEnabled, map['transfer_enabled']);
      expect(account.currenciesSupported, map['currencies_supported']);
      expect(account.defaultCurrency, map['default_currency']);
      expect(account.country, map['country']);
    });
  });

  group('Account online', () {
    test('Retrieve Account', () async {
      var account = await Account.retrieve();
      expect(account.id.substring(0, 3), 'acc');
      // other tests will depend on your stripe account

    });
  });
}
