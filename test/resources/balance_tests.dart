library balance_tests;

import "dart:convert";

import 'package:unittest/unittest.dart';

import '../../lib/stripe.dart';
import '../utils.dart' as utils;

var exampleObject = """
    {
      "pending": [
        {
          "amount": 295889,
          "currency": "usd"
        }
      ],
      "available": [
        {
          "amount": 0,
          "currency": "usd"
        }
      ],
      "livemode": false,
      "object": "balance"
    }""";


main(List<String> args) {

  utils.setApiKeyFromArgs(args);

  group('Balance', () {

    setUp(() {
      return utils.setUp();
    });

    tearDown(() {
      return utils.tearDown();
    });

    test("fromMap() properly popullates all values", () {
      var map = JSON.decode(exampleObject);

      var balance = new Balance.fromMap(map);

      expect(balance.id, equals(map["id"]));
      expect(balance.pending.first.amount, equals(map["pending"][0]["amount"]));
      expect(balance.pending.first.currency, equals(map["pending"][0]["currency"]));
      expect(balance.available.first.amount, equals(map["available"][0]["amount"]));
      expect(balance.available.first.currency, equals(map["available"][0]["currency"]));

    });

    test("Retrieve Balance", () {

      Balance.retrieve()
          .then((Balance balance) {
            expect(balance.livemode, equals(false));
            // other tests will depend on your stripe account
          })
          .then(expectAsync((_) => true));

    });


  });

}