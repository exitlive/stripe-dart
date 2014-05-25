library invoice_tests;

import 'dart:convert';

import 'package:unittest/unittest.dart';

import '../../lib/stripe.dart';
import '../utils.dart' as utils;

var exampleAccount = """
    {
      "date": 1400855490,
      "id": "in_1045Uh41dfVNZFcqMyRp9Tml",
      "period_start": 1400855477,
      "period_end": 1400855490,
      "lines": {
        "data": [
          {
            "id": "sub_46DlDCMkK4GpF4",
            "object": "line_item",
            "type": "subscription",
            "livemode": true,
            "amount": 2000,
            "currency": "usd",
            "proration": false,
            "period": {
              "start": 1403701532,
              "end": 1406293532
            },
            "quantity": 1,
            "plan": {
              "interval": "month",
              "name": "Gold Special",
              "created": 1401023132,
              "amount": 2000,
              "currency": "usd",
              "id": "gold",
              "object": "plan",
              "livemode": false,
              "interval_count": 1,
              "trial_period_days": null,
              "metadata": {
              },
              "statement_description": null
            },
            "description": null,
            "metadata": {
            }
          }
        ],
        "count": 1,
        "object": "list",
        "url": "/v1/invoices/in_1045Uh41dfVNZFcqMyRp9Tml/lines"
      },
      "subtotal": 100,
      "total": 100,
      "customer": "cus_46Dls5hxVhuWPH",
      "object": "invoice",
      "attempted": true,
      "closed": true,
      "paid": true,
      "livemode": false,
      "attempt_count": 0,
      "amount_due": 100,
      "currency": "usd",
      "starting_balance": 0,
      "ending_balance": 0,
      "next_payment_attempt": null,
      "webhooks_delivered_at": 1400855491,
      "charge": "ch_1045Uh41dfVNZFcqAVSZLtiP",
      "discount": null,
      "application_fee": null,
      "subscription": "sub_45Uh2ly6rObFnk",
      "metadata": {
      },
      "description": null
    }""";


main(List<String> args) {

  utils.setApiKeyFromArgs(args);

  group('Invoice offline', () {

    test('fromMap() properly popullates all values', () {
      var map = JSON.decode(exampleAccount);

      var invoice = new Invoice.fromMap(map);
      
      expect(invoice.date, equals(new DateTime.fromMillisecondsSinceEpoch(map['date'] * 1000)));
      expect(invoice.id, equals(map['id']));
      expect(invoice.periodStart, equals(new DateTime.fromMillisecondsSinceEpoch(map['period_start'] * 1000)));
      expect(invoice.periodEnd, equals(new DateTime.fromMillisecondsSinceEpoch(map['period_end'] * 1000)));
      expect(invoice.lines.data.first.id, equals(map['lines']['data'][0]['id']));
      expect(invoice.lines.data.first.type, equals(map['lines']['data'][0]['type']));
      expect(invoice.lines.data.first.livemode, equals(map['lines']['data'][0]['livemode']));
      expect(invoice.lines.data.first.amount, equals(map['lines']['data'][0]['amount']));
      expect(invoice.lines.data.first.currency, equals(map['lines']['data'][0]['currency']));
      expect(invoice.lines.data.first.proration, equals(map['lines']['data'][0]['proration']));
      expect(invoice.lines.data.first.period.start, equals(map['lines']['data'][0]['period']['start']));
      expect(invoice.lines.data.first.period.end, equals(map['lines']['data'][0]['period']['end']));
      expect(invoice.lines.data.first.quantity, equals(map['lines']['data'][0]['quantity']));
      expect(invoice.lines.data.first.plan.interval, equals(map['lines']['data'][0]['plan']['interval']));
      expect(invoice.lines.data.first.plan.name, equals(map['lines']['data'][0]['plan']['name']));
      expect(invoice.lines.data.first.plan.created, equals(new DateTime.fromMillisecondsSinceEpoch(map['lines']['data'][0]['plan']['created'] * 1000)));
      expect(invoice.lines.data.first.plan.amount, equals(map['lines']['data'][0]['plan']['amount']));
      expect(invoice.lines.data.first.plan.currency, equals(map['lines']['data'][0]['plan']['currency']));
      expect(invoice.lines.data.first.plan.id, equals(map['lines']['data'][0]['plan']['id']));
      expect(invoice.lines.data.first.plan.livemode, equals(map['lines']['data'][0]['plan']['livemode']));
      expect(invoice.lines.data.first.plan.intervalCount, equals(map['lines']['data'][0]['plan']['interval_count']));
      expect(invoice.lines.data.first.plan.trialPeriodDays, equals(map['lines']['data'][0]['plan']['trialPeriodDays']));
      expect(invoice.lines.data.first.plan.metadata, equals(map['lines']['data'][0]['plan']['metadata']));
      expect(invoice.lines.data.first.plan.statementDescription, equals(map['lines']['data'][0]['plan']['statement_description']));
      expect(invoice.lines.data.first.description, equals(map['lines']['data'][0]['description']));
      expect(invoice.lines.data.first.metadata, equals(map['lines']['data'][0]['metadata']));
      expect(invoice.lines.url, equals(map['lines']['url']));
      expect(invoice.subtotal, equals(map['subtotal']));
      expect(invoice.total, equals(map['total']));
      expect(invoice.customer, equals(map['customer']));
      expect(invoice.attempted, equals(map['attempted']));
      expect(invoice.closed, equals(map['closed']));
      expect(invoice.livemode, equals(map['livemode']));
      expect(invoice.attemptCount, equals(map['attempt_count']));
      expect(invoice.amountDue, equals(map['amount_due']));
      expect(invoice.currency, equals(map['currency']));
      expect(invoice.startingBalance, equals(map['starting_balance']));
      expect(invoice.endingBalance, equals(map['ending_balance']));
      expect(invoice.nextPaymentAttempt, equals(map['next_payment_attempt']));
      expect(invoice.webhooksDeliveredAt, equals(new DateTime.fromMillisecondsSinceEpoch(map['webhooks_delivered_at'] * 1000)));
      expect(invoice.charge, equals(map['charge']));
      expect(invoice.discount, equals(map['discount']));
      expect(invoice.applicationFee, equals(map['application_fee']));
      expect(invoice.subscription, equals(map['subscription']));
      expect(invoice.metadata, equals(map['metadata']));
      expect(invoice.description, equals(map['description']));
      

    });

  });

  group('Invoice online', () {

    setUp(() {
      return utils.setUp();
    });

    tearDown(() {
      return utils.tearDown();
    });

    test('Invoice Account', () {

      

    });

  });

}