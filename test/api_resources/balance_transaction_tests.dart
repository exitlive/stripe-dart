library balance_transaction_tests;

import 'dart:convert';

import 'package:unittest/unittest.dart';

import '../../lib/stripe.dart';
import '../utils.dart' as utils;

var example = '''
    {
      "id": "txn_10427j41dfVNZFcqQpEyIITM",
      "object": "balance_transaction",
      "amount": 100,
      "currency": "usd",
      "net": 67,
      "type": "charge",
      "created": 1400078159,
      "available_on": 1400630400,
      "status": "pending",
      "fee": 33,
      "fee_details": [
        {
          "amount": 33,
          "currency": "usd",
          "type": "stripe_fee",
          "description": "Stripe processing fees",
          "application": null
        }
      ],
      "source": "ch_10427j41dfVNZFcqhfaTmJUU",
      "description": null
    }''';

main(List<String> args) {
  utils.setApiKeyFromArgs(args);

  group('BalanceTransaction offline', () {
    test('fromMap() properly popullates all values', () {
      var map = JSON.decode(example);
      var balanceTransaction = new BalanceTransaction.fromMap(map);
      expect(balanceTransaction.id, map['id']);
      expect(balanceTransaction.amount, map['amount']);
      expect(balanceTransaction.currency, map['currency']);
      expect(balanceTransaction.net, map['net']);
      expect(balanceTransaction.type, map['type']);
      expect(balanceTransaction.created, new DateTime.fromMillisecondsSinceEpoch(map['created'] * 1000));
      expect(balanceTransaction.availableOn, new DateTime.fromMillisecondsSinceEpoch(map['available_on'] * 1000));
      expect(balanceTransaction.status, map['status']);
      expect(balanceTransaction.fee, map['fee']);
      expect(balanceTransaction.feeDetails.first.amount, map['fee_details'].first['amount']);
      expect(balanceTransaction.feeDetails.first.currency, map['fee_details'].first['currency']);
      expect(balanceTransaction.feeDetails.first.type, map['fee_details'].first['type']);
      expect(balanceTransaction.feeDetails.first.description, map['fee_details'].first['description']);
      expect(balanceTransaction.feeDetails.first.application, map['fee_details'].first['application']);
      expect(balanceTransaction.source, map['source']);
      expect(balanceTransaction.description, map['description']);
    });
  });
}
