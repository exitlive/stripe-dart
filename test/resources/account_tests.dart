library account_tests;

import "dart:convert";

import 'package:unittest/unittest.dart';

import '../../lib/stripe.dart';
import '../utils.dart' as utils;

var exampleObject = """
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

  group('Account', () {

    setUp(() {
      return utils.setUp();
    });

    tearDown(() {
      return utils.tearDown();
    });

    test("fromMap() properly popullates all values", () {
      var map = JSON.decode(exampleObject);

      var account = new Account.fromMap(map);

      expect(account.id, equals(map["id"]));
      expect(account.email, equals(map["email"]));
      expect(account.statementDescriptor, equals(map["statement_descriptor"]));
      expect(account.displayName, equals(map["display_name"]));
      expect(account.timezone, equals(map["timezone"]));
      expect(account.detailsSubmitted, equals(map["details_submitted"]));
      expect(account.chargeEnabled, equals(map["charge_enabled"]));
      expect(account.transferEnabled, equals(map["transfer_enabled"]));
      expect(account.currenciesSupported, equals(map["currencies_supported"]));
      expect(account.defaultCurrency, equals(map["default_currency"]));
      expect(account.country, equals(map["country"]));

    });

    test("Retrieve Balance", () {

      Account.retrieve()
          .then((Account account) {
            expect(account.id.substring(0, 3), equals("acc"));
            // other tests will depend on your stripe account
          })
          .then(expectAsync((_) => true));

    });


  });

}