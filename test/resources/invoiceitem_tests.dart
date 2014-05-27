library invoiceitem_tests;

import 'dart:convert';
import 'dart:async';
import 'package:unittest/unittest.dart';

import '../../lib/stripe.dart';
import '../utils.dart' as utils;

var exampleAccount = """
    {
      "object": "invoiceitem",
      "id": "ii_1046ct41dfVNZFcq7D6Z8lys",
      "date": 1401116624,
      "amount": 100,
      "livemode": false,
      "proration": false,
      "currency": "usd",
      "customer": "cus_46ctVjlaQj7Nbr",
      "description": "My First Invoice Item (created for API docs)",
      "metadata": {
      },
      "invoice": null,
      "subscription": null
    }""";


main(List<String> args) {

  utils.setApiKeyFromArgs(args);

  group('Invoice item offline', () {

    test('fromMap() properly popullates all values', () {
      var map = JSON.decode(exampleAccount);

      var invoiceItem = new Invoiceitem.fromMap(map);

      expect(invoiceItem.id, equals(map['id']));
      expect(invoiceItem.date, equals(new DateTime.fromMillisecondsSinceEpoch(map['date'] * 1000)));
      expect(invoiceItem.amount, equals(map['amount']));
      expect(invoiceItem.livemode, equals(map['livemode']));
      expect(invoiceItem.proration, equals(map['proration']));
      expect(invoiceItem.currency, equals(map['currency']));
      expect(invoiceItem.customer, equals(map['customer']));
      expect(invoiceItem.description, equals(map['description']));
      expect(invoiceItem.metadata, equals(map['metadata']));
      expect(invoiceItem.invoice, equals(map['invoice']));
      expect(invoiceItem.subscription, equals(map['subscription']));

    });

  });

  group('Invoice item online', () {

    setUp(() {
      return utils.setUp();
    });

    tearDown(() {
      return utils.tearDown();
    });

    test('Create Invoice item minimal', () {

      // Customer fields
      Customer testCustomer;

      // Card fields
      String testCardNumber = '4242424242424242';
      int testCardExpMonth = 12;
      int testCardExpYear = 2014;

      // Charge fields
      int testChargeAmount = 100;
      String testChargeCurrency = 'usd';

      new CustomerCreation().create()
      .then((Customer customer) {
        testCustomer = customer;
        return (new CardCreation()
            ..number = testCardNumber
            ..expMonth = testCardExpMonth
            ..expYear = testCardExpYear
        ).create(testCustomer.id);
      })
      .then((Card card) {
        return (new InvoiceitemCreation()
            ..customer = testCustomer.id
            ..amount = testChargeAmount
            ..currency = testChargeCurrency
        ).create();
      })
      .then((Invoiceitem invoiceitem) {
        expect(invoiceitem.amount, equals(testChargeAmount));
        expect(invoiceitem.currency, equals(testChargeCurrency));
        expect(invoiceitem.customer, equals(testCustomer.id));
      })

      .then(expectAsync((_) => true));

    });

    test('Create Invoice item full', () {

      // Customer fields
      Customer testCustomer;

      // Card fields
      Card testCard;
      String testCardNumber = '4242424242424242';
      int testCardExpMonth = 12;
      int testCardExpYear = 2014;

      CardCreation testCardCreation = new CardCreation()
          ..number = testCardNumber
          ..expMonth = testCardExpMonth
          ..expYear = testCardExpYear;

      // Charge fields
      int testChargeAmount = 100;
      String testChargeCurrency = 'usd';

      // Plan fields
      Plan testPlan;
      String testPlanId = 'test plan id';
      int testPlanAmount = 200;
      String testPlanCurrency = 'usd';
      String testPlanInterval = 'month';
      String testPlanName = 'test plan name';


      // Subscription fields
      Subscription testSubscription;

      // Invoiceitem fields
      Invoiceitem testInvoiceitem;
      String testInvoiceitemCurrency = 'usd';
      int testInvoiceitemAmount1 = 200;
      String testInvoiceitemDescription1 = 'test description1';
      Map testInvoiceitemMetadata1 = {'foo': 'bar1'};

      int testInvoiceitemAmount2 = 220;
      String testInvoiceitemDescription2 = 'test description2';
      Map testInvoiceitemMetadata2 = {'foo': 'bar2'};

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
            return (
                new SubscriptionCreation()
                    ..plan = testPlan.id
            ).create(testCustomer.id);
          })
          .then((Subscription subscription) {
            testSubscription = subscription;
            return (new InvoiceitemCreation()
                ..customer = testCustomer.id
                ..amount = testInvoiceitemAmount1
                ..currency = testInvoiceitemCurrency
                ..subscription = subscription.id
                ..description = testInvoiceitemDescription1
                ..metadata = testInvoiceitemMetadata1
            ).create();
          })
          .then((Invoiceitem invoiceitem) {
            expect(invoiceitem.amount, equals(testInvoiceitemAmount1));
            expect(invoiceitem.currency, equals(testInvoiceitemCurrency));
            expect(invoiceitem.customer, equals(testCustomer.id));
            expect(invoiceitem.subscription, equals(testSubscription.id));
            expect(invoiceitem.description, equals(testInvoiceitemDescription1));
            expect(invoiceitem.metadata, equals(testInvoiceitemMetadata1));
            // seems that expanding currently does not work according to the API specification
            // testing retrieve
            return Invoiceitem.retrieve(invoiceitem.id);
          })
          .then((Invoiceitem invoiceitem) {
            expect(invoiceitem.amount, equals(testInvoiceitemAmount1));
            expect(invoiceitem.currency, equals(testChargeCurrency));
            expect(invoiceitem.customer, equals(testCustomer.id));
            expect(invoiceitem.subscription, equals(testSubscription.id));
            expect(invoiceitem.description, equals(testInvoiceitemDescription1));
            expect(invoiceitem.metadata, equals(testInvoiceitemMetadata1));
            // testing InvoiceitemUpdate
            return (new InvoiceitemUpdate()
                ..amount = testInvoiceitemAmount2
                ..description = testInvoiceitemDescription2
                ..metadata = testInvoiceitemMetadata2
            ).update(invoiceitem.id);
          })
          .then((Invoiceitem invoiceitem) {
            testInvoiceitem = invoiceitem;
            expect(invoiceitem.amount, equals(testInvoiceitemAmount2));
            expect(invoiceitem.description, equals(testInvoiceitemDescription2));
            expect(invoiceitem.metadata, equals(testInvoiceitemMetadata2));
            // testing delete
            return Invoiceitem.delete(invoiceitem.id);
          })
          .then((Map response) {
            expect(response['id'], equals(testInvoiceitem.id));
            expect(response['deleted'], isTrue);
          })
          .then(expectAsync((_) => true));

    });

    test('List parameters Invoiceitem', () {

      // Customer fields
      Customer testCustomer;

      // Card fields
      String testCardNumber = '4242424242424242';
      int testCardExpMonth = 12;
      int testCardExpYear = 2014;

      // Charge fields
      int testChargeAmount = 100;
      String testChargeCurrency = 'usd';




      List<Future> queue = [];
      for (var i = 0; i < 20; i++) {
        queue.add(
          new CustomerCreation().create()
              .then((Customer customer) {
                testCustomer = customer;
                return (new CardCreation()
                    ..number = testCardNumber
                    ..expMonth = testCardExpMonth
                    ..expYear = testCardExpYear
                ).create(testCustomer.id);
          })
          .then((Card card) {
            return (new InvoiceitemCreation()
                ..customer = testCustomer.id
                ..amount = testChargeAmount
                ..currency = testChargeCurrency
            ).create();
          })
        );
      }
      Future.wait(queue)
      .then((_) => Invoiceitem.list(limit: 10))
      .then((InvoiceitemCollection invoiceitems) {
        expect(invoiceitems.data.length, equals(10));
        expect(invoiceitems.hasMore, equals(true));
        return Invoiceitem.list(limit: 10, startingAfter: invoiceitems.data.last.id);
      })
      .then((InvoiceitemCollection invoiceitems) {
        expect(invoiceitems.data.length, equals(10));
        expect(invoiceitems.hasMore, equals(false));
        return Invoiceitem.list(limit: 10, endingBefore: invoiceitems.data.first.id);
      })
      .then((InvoiceitemCollection invoiceitems) {
        expect(invoiceitems.data.length, equals(10));
        expect(invoiceitems.hasMore, equals(false));
      })
      .then(expectAsync((_) => true));

    });


  });

}