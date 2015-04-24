library transfer_tests;

import 'dart:convert';

import 'package:unittest/unittest.dart';

import '../../lib/stripe.dart';
import '../utils.dart' as utils;

import 'card_tests.dart' as card;
import 'charge_tests.dart' as charge;
import 'balance_transaction_tests.dart' as balance_transaction;
import 'transfer_reversal_tests.dart' as transfer_reversal;

var example = '''
    {
      "id": "tr_1046Ri41dfVNZFcqQ325IJCE",
      "object": "transfer",
      "livemode": false,
      "amount": 100,
      "created": 1401075076,
      "currency": "usd",
      "date": 1401235200,
      "reversals": ${transfer_reversal.collectionExample},
      "reversed": false,
      "status": "pending",
      "type": "bank_account",
      "amount_reversed": 0,
      "balance_transaction": ${balance_transaction.example},
      "description": "STRIPE TRANSFER",
      "failure_code": "insufficient_funds",
      "failure_message": "Your Stripe account has insufficient funds to cover the transfer.",
      "metadata": ${utils.metadataExample},
      "application_fee": "application_fee",
      "destination": ${card.example},
      "destination_payment": ${charge.example},
      "source_transaction": ${charge.example},
      "statement_descriptor": "statement_descriptor"
    }''';

main(List<String> args) {
  utils.setApiKeyFromArgs(args);

  group('Transfer offline', () {
    test('fromMap() properly popullates all values', () {
      var map = JSON.decode(example);
      var transfer = new Transfer.fromMap(map);
      expect(transfer.id, map['id']);
      expect(transfer.livemode, map['livemode']);
      expect(transfer.amount, map['amount']);
      expect(transfer.created, new DateTime.fromMillisecondsSinceEpoch(map['created'] * 1000));
      expect(transfer.currency, map['currency']);
      expect(transfer.date, new DateTime.fromMillisecondsSinceEpoch(map['date'] * 1000));
      expect(transfer.reversals.toMap(), new TransferReversalCollection.fromMap(map['reversals']).toMap());
      expect(transfer.reversed, map['reversed']);
      expect(transfer.status, map['status']);
      expect(transfer.type, map['type']);
      expect(transfer.amountReversed, map['amount_reversed']);
      expect(transfer.balanceTransactionExpand.toMap(), new Balance.fromMap(map['balance_transaction']).toMap());
      expect(transfer.description, map['description']);
      expect(transfer.failureCode, map['failure_code']);
      expect(transfer.failureMessage, map['failure_message']);
      expect(transfer.metadata, map['metadata']);
      expect(transfer.applicationFee, map['application_fee']);
      expect(transfer.destinationExpand.toMap(), new Card.fromMap(map['destination']).toMap());
      expect(transfer.destinationPaymentExpand.toMap(), new Charge.fromMap(map['destination_payment']).toMap());
      expect(transfer.sourceTransactionExpand.toMap(), new Charge.fromMap(map['source_transaction']).toMap());
      expect(transfer.statementDescriptor, map['statement_descriptor']);
    });
  });

  group('Transfer online', () {
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
