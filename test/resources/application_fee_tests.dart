library application_fee_tests;

import 'dart:convert';

import 'package:unittest/unittest.dart';

import '../../lib/stripe.dart';
import '../utils.dart' as utils;


var exampleApplicationFee = """
    {
      "id": "fee_46ctshdXTn0txu",
      "object": "application_fee",
      "created": 1401116624,
      "livemode": false,
      "amount": 100,
      "currency": "usd",
      "refunded": false,
      "amount_refunded": 0,
      "refunds": [
    
      ],
      "balance_transaction": "txn_1044ML41dfVNZFcq7TtjDZeb",
      "account": "acct_103yoB41dfVNZFcq",
      "application": "ca_46ctJf0EUeVbeYGw6K81MlkMuX8kWdAb",
      "charge": "ch_1046aN41dfVNZFcq1TGLAbRm"
    }""";


main(List<String> args) {

  utils.setApiKeyFromArgs(args);

  group('Account offline', () {

    test('fromMap() properly popullates all values', () {

      var map = JSON.decode(exampleApplicationFee);
      var applicationFee = new ApplicationFee.fromMap(map);
      expect(applicationFee.id, equals(map['id']));
      expect(applicationFee.created, equals(new DateTime.fromMillisecondsSinceEpoch(map['created'] * 1000)));
      expect(applicationFee.livemode, equals(map['livemode']));
      expect(applicationFee.amount, equals(map['amount']));
      expect(applicationFee.currency, equals(map['currency']));
      expect(applicationFee.refunded, equals(map['refunded']));
      expect(applicationFee.amountRefunded, equals(map['amount_refunded']));
      expect(applicationFee.refunds, equals(map['refunds']));
      expect(applicationFee.balanceTransaction, equals(map['balance_transaction']));
      expect(applicationFee.account, equals(map['account']));
      expect(applicationFee.application, equals(map['application']));
      expect(applicationFee.charge, equals(map['charge']));

    });

  });

}