library event_tests;

import 'dart:convert';

import 'package:unittest/unittest.dart';

import '../../lib/stripe.dart';
import '../utils.dart' as utils;

var exampleAccount = """
    {
      "id": "evt_1046Ri41dfVNZFcqJ8BRwM05",
      "created": 1401075077,
      "livemode": false,
      "type": "transfer.created",
      "data": {
        "object": {
          "id": "tr_1046Ri41dfVNZFcqQ325IJCE",
          "object": "transfer",
          "created": 1401075076,
          "date": 1401235200,
          "livemode": false,
          "amount": 4141,
          "currency": "usd",
          "status": "pending",
          "type": "bank_account",
          "balance_transaction": "txn_1046Ri41dfVNZFcqmi4L1LrZ",
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
          "statement_description": null,
          "recipient": null,
          "account": null
        }
      },
      "object": "event",
      "pending_webhooks": 0,
      "request": null
    }""";


main(List<String> args) {

  utils.setApiKeyFromArgs(args);

  group('Event offline', () {

    test('fromMap() properly popullates all values', () {
      var map = JSON.decode(exampleAccount);

      var event = new Event.fromMap(map);

      expect(event.id, equals(map['id']));
      expect(event.created, equals(new DateTime.fromMillisecondsSinceEpoch(map['created'] * 1000)));
      expect(event.livemode, equals(map['livemode']));
      expect(event.type, equals(map['type']));
      expect(event.data.object, equals(map['data']['object']));

    });

  });

  group('Event online', () {

    setUp(() {
      return utils.setUp();
    });

    tearDown(() {
      return utils.tearDown();
    });

    test('List and retrieve Events', () {

      Customer testCustomer;
      Event testEvent;

      new CustomerCreation().create()
          .then((Customer customer) {
            testCustomer = customer;
            return Event.list(limit: 1, type: 'customer.created');
          })
          .then((EventCollection events) {
            testEvent = events.data.first;
            expect(testEvent.data.object['id'], equals(testCustomer.id));
            return Event.retrieve(testEvent.id);
          })
          .then((Event event) {
            expect(event.created, equals(testEvent.created));
            expect(event.data.object, equals(testEvent.data.object));
            expect(event.id, equals(testEvent.id));
            expect(event.livemode, equals(testEvent.livemode));
            expect(event.type, equals(testEvent.type));
          })
          .then(expectAsync((_) => true));

    });

  });

}