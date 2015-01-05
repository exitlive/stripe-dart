library invoice_tests;

import 'dart:convert';

import 'package:unittest/unittest.dart';

import '../../lib/stripe.dart';
import '../utils.dart' as utils;


var exampleInvoice = """
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
              "statement_descriptor": null
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

      var map = JSON.decode(exampleInvoice);
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
      expect(invoice.lines.data.first.plan.statementDescriptor, equals(map['lines']['data'][0]['plan']['statement_descriptor']));
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

    test('InvoiceCreation minimal', () {

      // Customer fields
      Customer testCustomer;

      new CustomerCreation().create()
          .then((Customer customer) {
            return (new InvoiceCreation()
                ..customer = customer.id
            ).create();
          })
          .then((Invoice invoice) {
            expect(invoice.customer, equals(testCustomer.id));
          })
          .catchError((e) {
            // nothing to invoice for a new customer
            expect(e, new isInstanceOf<InvalidRequestErrorException>());
            expect(e.errorMessage, equals('Nothing to invoice for customer'));
          })
          .then(expectAsync((_) => true));

    });

    test('InvoiceCreation full', () {

      // Customer fields
      Customer testCustomer;

      // Card fields
      Card testCard;
      String testCardNumber = '5555555555554444';
      int testCardExpMonth = 3;
      int testCardExpYear = 2016;

      CardCreation testCardCreation = new CardCreation()
          ..number = testCardNumber // only the last 4 digits can be tested
          ..expMonth = testCardExpMonth
          ..expYear = testCardExpYear;

      // Plan fields
      Plan testPlan;
      String testPlanId = 'test plan id';
      int testPlanAmount = 200;
      String testPlanCurrency = 'usd';
      String testPlanInterval = 'month';
      String testPlanName = 'test plan name';

      // Charge fields
      int testChargeAmount = 100;
      String testChargeCurrency = 'usd';

      // Invoice fields
      String testInvoiceDescription = 'test description';
      Map testInvoiceMetadata = {'foo': 'bar'};

      (new PlanCreation()
          ..id = testPlanId
          ..amount = testPlanAmount
          ..currency = testPlanCurrency
          ..interval = testPlanInterval
          ..name = testPlanName
      ).create()
          .then((Plan plan) {
            testPlan = plan;
            return new CustomerCreation().create();
          })
          .then((Customer customer) {
            testCustomer = customer;
            return testCardCreation.create(testCustomer.id);
          })
          .then((Card card) {
            testCard = card;
            return (new ChargeCreation()
                ..amount = testChargeAmount
                ..currency = testChargeCurrency
                ..customer = testCustomer.id
            ).create();
          })
          .then((Charge charge) {
            return (
                new SubscriptionCreation()
                    ..plan = testPlan.id
            ).create(testCustomer.id);
          })
          .then((Subscription subscription) {
            return (new InvoiceCreation()
                ..customer = testCustomer.id
                ..description = testInvoiceDescription
                ..metadata = testInvoiceMetadata
                ..subscription = subscription.id
            ).create();
          })
          .catchError((e) {
            // nothing to invoice for a new customer
            expect(e, new isInstanceOf<InvalidRequestErrorException>());
            expect(e.errorMessage, equals('Nothing to invoice for subscription'));
          })
          .then(expectAsync((_) => true));

    });

  });

}