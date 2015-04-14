library invoiceitem_tests;

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
      Invoiceitem invoiceitem = await (new InvoiceitemCreation()
          ..customer = customer.id
          ..amount = testChargeAmount
          ..currency = testChargeCurrency
      ).create();
      expect(invoiceitem.amount, equals(testChargeAmount));
      expect(invoiceitem.currency, equals(testChargeCurrency));
      expect(invoiceitem.customer, equals(customer.id));

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
      Invoiceitem invoiceitem = await (new InvoiceitemCreation()
          ..customer = customer.id
          ..amount = testInvoiceitemAmount1
          ..currency = testInvoiceitemCurrency
          ..subscription = subscription.id
          ..description = testInvoiceitemDescription1
          ..metadata = testInvoiceitemMetadata1
      ).create();
      expect(invoiceitem.amount, equals(testInvoiceitemAmount1));
      expect(invoiceitem.currency, equals(testInvoiceitemCurrency));
      expect(invoiceitem.customer, equals(customer.id));
      expect(invoiceitem.subscription, equals(subscription.id));
      expect(invoiceitem.description, equals(testInvoiceitemDescription1));
      expect(invoiceitem.metadata, equals(testInvoiceitemMetadata1));
      // seems that expanding currently does not work according to the API specification
      // testing retrieve
      invoiceitem = await Invoiceitem.retrieve(invoiceitem.id);
      expect(invoiceitem.amount, equals(testInvoiceitemAmount1));
      expect(invoiceitem.currency, equals(testChargeCurrency));
      expect(invoiceitem.customer, equals(customer.id));
      expect(invoiceitem.subscription, equals(subscription.id));
      expect(invoiceitem.description, equals(testInvoiceitemDescription1));
      expect(invoiceitem.metadata, equals(testInvoiceitemMetadata1));
      // testing InvoiceitemUpdate
      invoiceitem = await (new InvoiceitemUpdate()
          ..amount = testInvoiceitemAmount2
          ..description = testInvoiceitemDescription2
          ..metadata = testInvoiceitemMetadata2
      ).update(invoiceitem.id);
      expect(invoiceitem.amount, equals(testInvoiceitemAmount2));
      expect(invoiceitem.description, equals(testInvoiceitemDescription2));
      expect(invoiceitem.metadata, equals(testInvoiceitemMetadata2));
      // testing delete
      Map response = await Invoiceitem.delete(invoiceitem.id);
      expect(response['id'], equals(invoiceitem.id));
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
        await (new InvoiceitemCreation()
            ..customer = customer.id
            ..amount = testChargeAmount
            ..currency = testChargeCurrency
        ).create();
      }

      InvoiceitemCollection invoiceitems = await Invoiceitem.list(limit: 10);
      expect(invoiceitems.data.length, equals(10));
      expect(invoiceitems.hasMore, equals(true));
      invoiceitems = await Invoiceitem.list(limit: 10, startingAfter: invoiceitems.data.last.id);
      expect(invoiceitems.data.length, equals(10));
      expect(invoiceitems.hasMore, equals(false));
      invoiceitems = await Invoiceitem.list(limit: 10, endingBefore: invoiceitems.data.first.id);
      expect(invoiceitems.data.length, equals(10));
      expect(invoiceitems.hasMore, equals(false));

    });

  });

}