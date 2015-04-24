library transfer_reversal_tests;

import 'dart:convert';

import 'package:unittest/unittest.dart';

import '../../lib/stripe.dart';
import '../utils.dart' as utils;

import 'balance_transaction_tests.dart' as balance_transaction;

var example = '''
    {
      "id": "trr_15tcUC41dfVNZFcqFUVF8qn4",
      "object": "transfer_reversal",
      "amount": 100,
      "created": 1400696683,
      "currency": "usd",
      "balance_transaction": ${balance_transaction.example},
      "metadata": ${utils.metadataExample},
      "transfer": "tr_1046Ri41dfVNZFcqQ325IJCE"
    }''';

var collectionExample = '''
    {
      "object": "list",
      "total_count": 1,
      "has_more": false,
      "url": "/v1/transfers/tr_15uf0z41dfVNZFcq9jqmvB3X/reversals",
      "data": [${example}]
    }''';

main(List<String> args) {
  utils.setApiKeyFromArgs(args);

  group('TransferReversal offline', () {
    test('fromMap() properly popullates all values', () {
      var map = JSON.decode(example);
      var reversal = new TransferReversal.fromMap(map);
      expect(reversal.id, map['id']);
      expect(reversal.amount, map['amount']);
      expect(reversal.created, new DateTime.fromMillisecondsSinceEpoch(map['created'] * 1000));
      expect(reversal.currency, map['currency']);
      expect(reversal.balanceTransactionExpand.toMap(),
          new BalanceTransaction.fromMap(map['balance_transaction']).toMap());
      expect(reversal.transfer, map['transfer']);
    });
  });

  group('TransferReversal online', () {
    tearDown(() {
      return utils.tearDown();
    });

    test('Create minimal', () async {
      // TODO: implement
    });

    test('Create full', () async {
      // TODO: implement
    });

    test('List parameters', () async {
      // TODO: implement
    });
  });
}
