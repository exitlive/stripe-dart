library refund_tests;

import 'dart:convert';

import 'package:unittest/unittest.dart';

import '../../lib/stripe.dart';
import '../utils.dart' as utils;

var example = '''
    {
      "id": "re_15tboK41dfVNZFcqGjeMiXGv",
      "object": "refund",
      "amount": 10,
      "created": 1429524448,
      "currency": "usd",
      "balance_transaction": "txn_15tboK41dfVNZFcqCs5n6DLf"
    }''';

var collectionExample = '''
    {
      "object": "list",
      "total_count": 1,
      "has_more": false,
      "url": "/v1/charges/ch_15tbwd41dfVNZFcq48lWk5V2/refunds",
      "data": [${example}]
    }''';

main(List<String> args) {
  utils.setApiKeyFromArgs(args);

  group('Refund offline', () {
    test('fromMap() properly popullates all values', () {
      var map = JSON.decode(example);
      var refund = new Refund.fromMap(map);
      expect(refund.id, map['id']);
      expect(refund.amount, map['amount']);
      expect(refund.amount, map['amount']);
      expect(refund.amount, map['amount']);
      expect(refund.amount, map['amount']);
    });
  });
}
