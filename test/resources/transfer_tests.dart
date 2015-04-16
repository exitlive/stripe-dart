library transfer_tests;

import 'dart:convert';

import 'package:unittest/unittest.dart';

import '../../lib/stripe.dart';
import '../utils.dart' as utils;

var exampleTransfer = """
    {
      "id": "tr_1046Ri41dfVNZFcqQ325IJCE",
      "object": "transfer",
      "created": 1401075076,
      "date": 1401235200,
      "livemode": false,
      "amount": 4141,
      "currency": "usd",
      "status": "pending",
      "type": "bank_account",
      "balance_transaction": "txn_1044ML41dfVNZFcq7TtjDZeb",
      "summary": {
        "charge_gross": 7010,
        "charge_fees": 2190,
        "charge_fee_details": [
          {
            "amount": 2190,
            "currency": "usd",
            "type": "stripe_fee",
            "description": null,
            "application": null
          }
        ],
        "refund_gross": -700,
        "refund_fees": -21,
        "refund_fee_details": [
          {
            "amount": -21,
            "currency": "usd",
            "type": "stripe_fee",
            "description": null,
            "application": null
          }
        ],
        "adjustment_gross": 0,
        "adjustment_fees": 0,
        "adjustment_fee_details": [
    
        ],
        "validation_fees": 0,
        "validation_count": 0,
        "charge_count": 66,
        "refund_count": 14,
        "adjustment_count": 0,
        "net": 4141,
        "currency": "usd",
        "collected_fee_gross": 0,
        "collected_fee_count": 0,
        "collected_fee_refund_gross": 0,
        "collected_fee_refund_count": 0
      },
      "transactions": {
        "object": "list",
        "total_count": 80,
        "has_more": true,
        "url": "/v1/transfers/tr_1046Ri41dfVNZFcqQ325IJCE/transactions",
        "data": [
          {
            "id": "ch_1044o041dfVNZFcqIEgcg9P7",
            "type": "charge",
            "amount": 100,
            "currency": "usd",
            "net": 67,
            "created": 1400696687,
            "description": null,
            "fee": 33,
            "fee_details": [
              {
                "amount": 33,
                "currency": "usd",
                "type": "stripe_fee",
                "description": "Stripe processing fees",
                "application": null
              }
            ]
          },
          {
            "id": "ch_1044o041dfVNZFcqrnWnjxRs",
            "type": "charge",
            "amount": 100,
            "currency": "usd",
            "net": 67,
            "created": 1400696685,
            "description": null,
            "fee": 33,
            "fee_details": [
              {
                "amount": 33,
                "currency": "usd",
                "type": "stripe_fee",
                "description": "Stripe processing fees",
                "application": null
              }
            ]
          },
          {
            "id": "ch_1044o041dfVNZFcqzOvv2gr1",
            "type": "charge",
            "amount": 100,
            "currency": "usd",
            "net": 67,
            "created": 1400696685,
            "description": null,
            "fee": 33,
            "fee_details": [
              {
                "amount": 33,
                "currency": "usd",
                "type": "stripe_fee",
                "description": "Stripe processing fees",
                "application": null
              }
            ]
          },
          {
            "id": "ch_1044o041dfVNZFcqzhFXD8Pl",
            "type": "charge",
            "amount": 100,
            "currency": "usd",
            "net": 67,
            "created": 1400696684,
            "description": null,
            "fee": 33,
            "fee_details": [
              {
                "amount": 33,
                "currency": "usd",
                "type": "stripe_fee",
                "description": "Stripe processing fees",
                "application": null
              }
            ]
          },
          {
            "id": "ch_1044o041dfVNZFcqMpXTlhqm",
            "type": "charge",
            "amount": 100,
            "currency": "usd",
            "net": 67,
            "created": 1400696683,
            "description": null,
            "fee": 33,
            "fee_details": [
              {
                "amount": 33,
                "currency": "usd",
                "type": "stripe_fee",
                "description": "Stripe processing fees",
                "application": null
              }
            ]
          }
        ]
      },
      "other_transfers": [
        "tr_1046Ri41dfVNZFcqQ325IJCE"
      ],
      "description": "STRIPE TRANSFER",
      "metadata": {
      },
      "statement_descriptor": null,
      "recipient": null
    }""";

main(List<String> args) {
  utils.setApiKeyFromArgs(args);

  group('Transfer offline', () {
    test('fromMap() properly popullates all values', () {
      var map = JSON.decode(exampleTransfer);
      var transfer = new Transfer.fromMap(map);
      expect(transfer.id, map['id']);
      expect(transfer.created, new DateTime.fromMillisecondsSinceEpoch(map['created'] * 1000));
      expect(transfer.date, new DateTime.fromMillisecondsSinceEpoch(map['date'] * 1000));
      expect(transfer.livemode, map['livemode']);
      expect(transfer.amount, map['amount']);
      expect(transfer.currency, map['currency']);
      expect(transfer.status, map['status']);
      expect(transfer.type, map['type']);
      expect(transfer.balanceTransaction, map['balance_transaction']);
      expect(transfer.description, map['description']);
      expect(transfer.metadata, map['metadata']);
      expect(transfer.statementDescriptor, map['statement_descriptor']);
      expect(transfer.recipient, map['recipient']);
    });
  });

  group('Transfer online', () {
    tearDown(() {
      return utils.tearDown();
    });

    test('TransferCreation minimal', () async {

      // Transfer fields
      var transferAmount = 100,
          transferCurrency = 'usd',
          transferRecipient = 'self';

      var transfer = await (new TransferCreation()
        ..amount = transferAmount
        ..currency = transferCurrency
        ..recipient = transferRecipient).create();
      expect(transfer.amount, transferAmount);
      expect(transfer.currency, transferCurrency);
      expect(transfer.recipient, isNull);
    });

    test('TransferCreation full', () async {

      // Recipient fields
      var recipientName = 'test name',
          recipientType = 'corporation',
          bankAccountCountry = 'US',
          bankAccountRoutingNumber = '110000000',
          bankAccountAccountNumber = '000123456789';

      var recipientBankAccount = (new BankAccountRequest()
        ..country = bankAccountCountry
        ..routingNumber = bankAccountRoutingNumber
        ..accountNumber = bankAccountAccountNumber);

      var recipientCreation = new RecipientCreation()
        ..name = recipientName
        ..type = recipientType
        ..bankAccount = recipientBankAccount;

      // Transfer fields
      var transferAmount = 100,
          transferCurrency = 'usd',
          transferDescription1 = 'test description1',
          transferStatementDescriptor = 'descriptor',
          transferMetadata1 = {'foo': 'bar1'},
          transferDescription2 = 'test description2',
          transferMetadata2 = {'foo': 'bar2'};

      var recipient = await recipientCreation.create();
      var transfer = await (new TransferCreation()
        ..amount = transferAmount
        ..currency = transferCurrency
        ..recipient = recipient.id
        ..description = transferDescription1
        ..statementDescriptor = transferStatementDescriptor
        ..metadata = transferMetadata1).create();
      expect(transfer.amount, transferAmount);
      expect(transfer.currency, transferCurrency);
      expect(transfer.recipient, recipient.id);
      expect(transfer.description, transferDescription1);
      expect(transfer.statementDescriptor, transferStatementDescriptor);
      expect(transfer.metadata, transferMetadata1);
      transfer = await Transfer.retrieve(transfer.id, data: {'expand': ['balance_transaction']});
      // testing the expand functionality of retrieve
      expect(transfer.balanceTransaction, transfer.balanceTransactionExpand.id);
      expect(transfer.balanceTransactionExpand.amount, transferAmount * -1);
      // testing the TransferUpdate
      transfer = await (new TransferUpdate()
        ..description = transferDescription2
        ..metadata = transferMetadata2).update(transfer.id);
      expect(transfer.amount, transferAmount);
      expect(transfer.currency, transferCurrency);
      expect(transfer.recipient, recipient.id);
      expect(transfer.description, transferDescription2);
      expect(transfer.statementDescriptor, transferStatementDescriptor);
      expect(transfer.metadata, transferMetadata2);
      // testing transfer cancel
      try {
        await Transfer.cancel(transfer.id);
      } catch (e) {
        // transfer has already been submitted
        expect(e, new isInstanceOf<InvalidRequestErrorException>());
        expect(
            e.errorMessage, 'Transfers to non-Stripe accounts can currently only be reversed while they are pending.');
      }
    });

    test('List parameters Transfer', () async {

      // Transfer fields
      var transferAmount = 100,
          transferCurrency = 'usd',
          transferRecipient = 'self';

      for (var i = 0; i < 20; i++) {
        await (new TransferCreation()
          ..amount = transferAmount
          ..currency = transferCurrency
          ..recipient = transferRecipient).create();
      }

      var transfers = await Transfer.list(limit: 10);
      expect(transfers.data.length, 10);
      expect(transfers.hasMore, isTrue);
      transfers = await Transfer.list(limit: 10, startingAfter: transfers.data.last.id);
      expect(transfers.data.length, 10);
      // will also include transfers from past tests
      expect(transfers.hasMore, isTrue);
      transfers = await Transfer.list(limit: 10, endingBefore: transfers.data.first.id);
      expect(transfers.data.length, 10);
      expect(transfers.hasMore, isFalse);
    });
  });
}
