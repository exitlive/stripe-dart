library balance_tests;

import 'dart:convert';

import 'package:unittest/unittest.dart';

import '../../lib/stripe.dart';
import '../utils.dart' as utils;

var exampleBalance = '''
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
    }''';

main(List<String> args) {
  utils.setApiKeyFromArgs(args);

  group('Balance offline', () {
    test('fromMap() properly popullates all values', () {
      var map = JSON.decode(exampleBalance);
      var balance = new Balance.fromMap(map);
      expect(balance.pending.first.amount, map['pending'][0]['amount']);
      expect(balance.pending.first.currency, map['pending'][0]['currency']);
      expect(balance.available.first.amount, map['available'][0]['amount']);
      expect(balance.available.first.currency, map['available'][0]['currency']);
    });
  });

  group('Balance online', () {
    tearDown(() {
      return utils.tearDown();
    });

    test('Retrieve Balance', () async {
      var balance = await Balance.retrieve();
      expect(balance.livemode, isFalse);
      // other tests will depend on your stripe account

    });
  });
}
