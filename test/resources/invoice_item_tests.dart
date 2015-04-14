library invoice_item_tests;

import 'dart:convert';

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
      var invoiceItem = new InvoiceItem.fromMap(map);
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

    test('Create Invoice item minimal', () async {

      // Card fields
      String testCardNumber = '4242424242424242';
      int testCardExpMonth = 12;
      int testCardExpYear = 2016;

      // Charge fields
      int testChargeAmount = 100;
      String testChargeCurrency = 'usd';

      Customer customer = await new CustomerCreation().create();
      await (new CardCreation()
          ..number = testCardNumber
          ..expMonth = testCardExpMonth
          ..expYear = testCardExpYear
      ).create(customer.id);
      InvoiceItem invoiceItem = await (new InvoiceItemCreation()
          ..customer = customer.id
          ..amount = testChargeAmount
          ..currency = testChargeCurrency
      ).create();
      expect(invoiceItem.amount, equals(testChargeAmount));
      expect(invoiceItem.currency, equals(testChargeCurrency));
      expect(invoiceItem.customer, equals(customer.id));

    });

    test('Create Invoice item full', () async {

      // Card fields
      String testCardNumber = '4242424242424242';
      int testCardExpMonth = 12;
      int testCardExpYear = 2016;

      CardCreation testCardCreation = new CardCreation()
          ..number = testCardNumber
          ..expMonth = testCardExpMonth
          ..expYear = testCardExpYear;

      // Charge fields
      String testChargeCurrency = 'usd';

      // Plan fields
      String testPlanId = 'test plan id';
      int testPlanAmount = 200;
      String testPlanCurrency = 'usd';
      String testPlanInterval = 'month';
      String testPlanName = 'test plan name';

      // Invoiceitem fields
      String testInvoiceitemCurrency = 'usd';
      int testInvoiceitemAmount1 = 200;
      String testInvoiceitemDescription1 = 'test description1';
      Map testInvoiceitemMetadata1 = {'foo': 'bar1'};

      int testInvoiceitemAmount2 = 220;
      String testInvoiceitemDescription2 = 'test description2';
      Map testInvoiceitemMetadata2 = {'foo': 'bar2'};

      Plan plan = await (new PlanCreation()
          ..id = testPlanId
          ..amount = testPlanAmount
          ..currency = testPlanCurrency
          ..interval = testPlanInterval
          ..name = testPlanName
      ).create();
      Customer customer = await new CustomerCreation().create();
      await testCardCreation.create(customer.id);
      Subscription subscription = await (new SubscriptionCreation()
          ..plan = plan.id
      ).create(customer.id);
      InvoiceItem invoiceItem = await (new InvoiceItemCreation()
          ..customer = customer.id
          ..amount = testInvoiceitemAmount1
          ..currency = testInvoiceitemCurrency
          ..subscription = subscription.id
          ..description = testInvoiceitemDescription1
          ..metadata = testInvoiceitemMetadata1
      ).create();
      expect(invoiceItem.amount, equals(testInvoiceitemAmount1));
      expect(invoiceItem.currency, equals(testInvoiceitemCurrency));
      expect(invoiceItem.customer, equals(customer.id));
      expect(invoiceItem.subscription, equals(subscription.id));
      expect(invoiceItem.description, equals(testInvoiceitemDescription1));
      expect(invoiceItem.metadata, equals(testInvoiceitemMetadata1));
      // seems that expanding currently does not work according to the API specification
      // testing retrieve
      invoiceItem = await InvoiceItem.retrieve(invoiceItem.id);
      expect(invoiceItem.amount, equals(testInvoiceitemAmount1));
      expect(invoiceItem.currency, equals(testChargeCurrency));
      expect(invoiceItem.customer, equals(customer.id));
      expect(invoiceItem.subscription, equals(subscription.id));
      expect(invoiceItem.description, equals(testInvoiceitemDescription1));
      expect(invoiceItem.metadata, equals(testInvoiceitemMetadata1));
      // testing InvoiceitemUpdate
      invoiceItem = await (new InvoiceItemUpdate()
          ..amount = testInvoiceitemAmount2
          ..description = testInvoiceitemDescription2
          ..metadata = testInvoiceitemMetadata2
      ).update(invoiceItem.id);
      expect(invoiceItem.amount, equals(testInvoiceitemAmount2));
      expect(invoiceItem.description, equals(testInvoiceitemDescription2));
      expect(invoiceItem.metadata, equals(testInvoiceitemMetadata2));
      // testing delete
      Map response = await InvoiceItem.delete(invoiceItem.id);
      expect(response['id'], equals(invoiceItem.id));
      expect(response['deleted'], isTrue);

    });

    test('List parameters Invoiceitem', () async {

      // Card fields
      String testCardNumber = '4242424242424242';
      int testCardExpMonth = 12;
      int testCardExpYear = 2016;

      // Charge fields
      int testChargeAmount = 100;
      String testChargeCurrency = 'usd';

      Customer customer = await new CustomerCreation().create();

      await (new CardCreation()
          ..number = testCardNumber
          ..expMonth = testCardExpMonth
          ..expYear = testCardExpYear
      ).create(customer.id);

      for (var i = 0; i < 20; i++) {
        await (new InvoiceItemCreation()
            ..customer = customer.id
            ..amount = testChargeAmount
            ..currency = testChargeCurrency
        ).create();
      }

      InvoiceItemCollection invoiceItems = await InvoiceItem.list(limit: 10);
      expect(invoiceItems.data.length, equals(10));
      expect(invoiceItems.hasMore, equals(true));
      invoiceItems = await InvoiceItem.list(limit: 10, startingAfter: invoiceItems.data.last.id);
      expect(invoiceItems.data.length, equals(10));
      expect(invoiceItems.hasMore, equals(false));
      invoiceItems = await InvoiceItem.list(limit: 10, endingBefore: invoiceItems.data.first.id);
      expect(invoiceItems.data.length, equals(10));
      expect(invoiceItems.hasMore, equals(false));

    });

  });

}