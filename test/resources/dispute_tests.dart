library dispute_tests;

import 'dart:convert';

import 'package:unittest/unittest.dart';

import '../../lib/stripe.dart';
import '../utils.dart' as utils;


var exampleDispute = """
    {
      "charge": "ch_10442N41dfVNZFcqXcbfGBel",
      "amount": 1000,
      "created": 1400592617,
      "status": "needs_response",
      "livemode": false,
      "currency": "usd",
      "object": "dispute",
      "reason": "general",
      "balance_transaction": "txn_10427j41dfVNZFcqQpEyIITM",
      "evidence_due_by": 1402271999,
      "evidence": null
    }""";


main(List<String> args) {

  utils.setApiKeyFromArgs(args);

  group('Dispute offline', () {

    test('fromMap() properly popullates all values', () {

      var map = JSON.decode(exampleDispute);
      var dispute = new Dispute.fromMap(map);
      expect(dispute.charge, equals(map['charge']));
      expect(dispute.amount, equals(map['amount']));
      expect(dispute.created, equals(new DateTime.fromMillisecondsSinceEpoch(map['created'] * 1000)));
      expect(dispute.status, equals(map['status']));
      expect(dispute.livemode, equals(map['livemode']));
      expect(dispute.currency, equals(map['currency']));
      expect(dispute.reason, equals(map['reason']));
      expect(dispute.balanceTransaction, equals(map['balance_transaction']));
      expect(dispute.evidenceDueBy, equals(new DateTime.fromMillisecondsSinceEpoch(map['evidence_due_by'] * 1000)));
      expect(dispute.evidence, equals(map['evidence']));

    });

  });

}