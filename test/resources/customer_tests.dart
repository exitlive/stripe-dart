library customer_tests;

import 'dart:convert';

import 'package:unittest/unittest.dart';

import '../../lib/stripe.dart';
import '../utils.dart' as utils;


var exampleCustomer = """
    {
      "object": "customer",
      "created": 1399894618,
      "id": "cus_41KOaI2C3BNEc7",
      "livemode": false,
      "description": null,
      "email": null,
      "delinquent": false,
      "metadata": {
      },
      "subscriptions": {
        "object": "list",
        "total_count": 0,
        "has_more": false,
        "url": "/v1/customers/cus_41KOaI2C3BNEc7/subscriptions",
        "data": [
    
        ]
      },
      "discount": null,
      "account_balance": 0,
      "currency": "usd",
      "cards": {
        "object": "list",
        "has_more": false,
        "url": "/v1/customers/cus_41KOaI2C3BNEc7/cards",
        "data": [
        ]
      },
      "default_card": null
    }""";


main(List<String> args) {

  utils.setApiKeyFromArgs(args);

  group('Customer offline', () {

    test('fromMap() properly popullates all values', () {

      var map = JSON.decode(exampleCustomer);
      var customer = new Customer.fromMap(map);
      expect(customer.created, new DateTime.fromMillisecondsSinceEpoch(map['created'] * 1000));
      expect(customer.id, map['id']);
      expect(customer.livemode, map['livemode']);
      expect(customer.description, map['description']);
      expect(customer.email, map['email']);
      expect(customer.delinquent, map['delinquent']);
      expect(customer.metadata, map['metadata']);
      expect(customer.subscriptions, new isInstanceOf<SubscriptionCollection>());
      expect(customer.discount, map['discount']);
      expect(customer.accountBalance, map['account_balance']);
      expect(customer.currency, map['currency']);
      expect(customer.cards, new isInstanceOf<CardCollection>());
      expect(customer.cards.data.length, map['cards']['data'].length);
      expect(customer.cards.url, map['cards']['url']);
      expect(customer.defaultCard, map['default_card']);

    });

  });

  group('Customer online', () {

    tearDown(() {
      return utils.tearDown();
    });

    test('CustomerCreation minimal', () async {

      Customer customer = await new CustomerCreation().create();
      expect(customer.id, new isInstanceOf<String>());

    });


    test('CustomerCreation full', () async {

      // Card fields
      String testCardNumber1 = '4242424242424242';
      int testCardExpMonth1 = 12;
      int testCardExpYear1 = 2016;

      CardCreation testCardCreation1 = new CardCreation()
          ..number = testCardNumber1 // only the last 4 digits can be tested
          ..expMonth = testCardExpMonth1
          ..expYear = testCardExpYear1;

      String testCardNumber2 = '5555555555554444';
      int testCardExpMonth2 = 3;
      int testCardExpYear2 = 2016;

      CardCreation testCardCreation2 = new CardCreation()
          ..number = testCardNumber2 // only the last 4 digits can be tested
          ..expMonth = testCardExpMonth2
          ..expYear = testCardExpYear2;

      // Coupon fields
      String testCouponId1 = 'test coupon id1';
      String testCouponDuration1 = 'forever';
      int testCouponPercentOff1 = 15;

      CouponCreation testCouponCreation1 = new CouponCreation()
          ..id = testCouponId1
          ..duration = testCouponDuration1
          ..percentOff = testCouponPercentOff1;

      String testCouponId2 = 'test coupon id2';
      String testCouponDuration2 = 'forever';
      int testCouponPercentOff2 = 20;

      CouponCreation testCouponCreation2 = new CouponCreation()
          ..id = testCouponId2
          ..duration = testCouponDuration2
          ..percentOff = testCouponPercentOff2;

      // Plan fields
      String testPlanId = 'test plan id';
      int testPlanAmount = 200;
      String testPlanCurrency = 'usd';
      String testPlanInterval = 'month';
      String testPlanName = 'test plan name';

      PlanCreation testPlanCreation = new PlanCreation()
          ..id = testPlanId
          ..amount = testPlanAmount
          ..currency = testPlanCurrency
          ..interval = testPlanInterval
          ..name = testPlanName;

      // Customer fields
      int testCustomerAccountBalance1 = 100001;
      String testCustomerDescription1 = 'test description1';
      String testCustomerEmail1 = 'test1@test.com';
      Map testCustomerMetadata1 = {'foo': 'bar1'};
      int testCustomerQuantity = 5;
      int testCustomerTrialEnd = new DateTime.now().add(new Duration(days: 60)).millisecondsSinceEpoch ~/ 1000;
      // for update tests
      int testCustomerAccountBalance2 = 200002;
      String testCustomerDescription2 = 'test description2';
      String testCustomerEmail2 = 'test2@test.com';
      Map testCustomerMetadata2 = {'foo': 'bar2'};

      CustomerCreation testCustomerCreation = new CustomerCreation()
          ..accountBalance = testCustomerAccountBalance1
          ..card = testCardCreation1
          ..coupon = testCouponId1
          ..description = testCustomerDescription1
          ..email = testCustomerEmail1
          ..metadata = testCustomerMetadata1
          ..plan = testPlanId
          ..quantity = testCustomerQuantity
          ..trialEnd = testCustomerTrialEnd;

      await testCouponCreation1.create();
      await testCouponCreation2.create();
      await testPlanCreation.create();
      Customer customer = await testCustomerCreation.create();
      expect(customer.id, new isInstanceOf<String>());

      // card tests
      expect(customer.cards.data.first.last4, testCardNumber1.substring(testCardNumber1.length - 4));
      expect(customer.cards.data.first.expMonth, testCardExpMonth1);
      expect(customer.cards.data.first.expYear, testCardExpYear1);

      // coupon tests
      expect(customer.discount.coupon.id, testCouponId1);
      expect(customer.discount.coupon.duration, testCouponDuration1);
      expect(customer.discount.coupon.percentOff, testCouponPercentOff1);
      expect(customer.discount.start.runtimeType, DateTime);
      expect(customer.discount.subscription, isNull);
      expect(customer.discount.customer, customer.id);

      expect(customer.description, testCustomerDescription1);
      expect(customer.email, testCustomerEmail1);

      // plan / subscription tests
      Subscription subscription = customer.subscriptions.data.first;
      expect(subscription.customer, customer.id);
      expect(subscription.applicationFeePercent, isNull);
      expect(subscription.cancelAtPeriodEnd, isFalse);
      expect(subscription.canceledAt, isNull);
      expect(subscription.discount, isNull);
      expect(subscription.endedAt, isNull);
      expect(subscription.quantity, testCustomerQuantity);
      expect(subscription.status, 'trialing');
      expect(subscription.trialEnd, new DateTime.fromMillisecondsSinceEpoch(testCustomerTrialEnd * 1000));
      expect(subscription.plan, new isInstanceOf<Plan>());
      expect(subscription.plan.amount, testPlanAmount);
      expect(subscription.plan.currency, testPlanCurrency);
      expect(subscription.plan.id, testPlanId);
      expect(subscription.plan.interval, testPlanInterval);
      expect(subscription.plan.name, testPlanName);
      InvoiceCollection invoices = await Invoice.list(customer: customer.id);
      expect(invoices.data.first.startingBalance, testCustomerAccountBalance1);
      customer = await Customer.retrieve(customer.id, data: {'expand': ['default_card']});
      // testing the expand functionality of retrieve
      expect(customer.defaultCard, customer.defaultCardExpand.id);
      expect(customer.defaultCardExpand.last4, testCardNumber1.substring(testCardNumber1.length - 4));

      // testing the CustomerUpdate
      Customer updatedCustomer = await (new CustomerUpdate()
          ..accountBalance = testCustomerAccountBalance2
          ..card = testCardCreation2
          ..coupon = testCouponId2
          ..description = testCustomerDescription2
          ..email = testCustomerEmail2
          ..metadata = testCustomerMetadata2
      ).update(customer.id);
      expect(updatedCustomer.accountBalance, testCustomerAccountBalance2);
      expect(updatedCustomer.defaultCard, isNot(customer.defaultCard));
      expect(updatedCustomer.discount.coupon.percentOff, testCouponPercentOff2);
      expect(updatedCustomer.description, testCustomerDescription2);
      expect(updatedCustomer.email, testCustomerEmail2);
      expect(updatedCustomer.metadata, testCustomerMetadata2);

    });

    test('Delete Customer', () async {

      Customer customer = await new CustomerCreation().create();
      Map response = await Customer.delete(customer.id);
      expect(response['deleted'], isTrue);
      expect(response['id'], customer.id);

    });

    test('List parameters Customer', () async {

      for (var i = 0; i < 20; i++) {
        await new CustomerCreation().create();
      }

      CustomerCollection customers = await Customer.list(limit: 10);
      expect(customers.data.length, 10);
      expect(customers.hasMore, isTrue);
      customers = await Customer.list(limit: 10, startingAfter: customers.data.last.id);
      expect(customers.data.length, 10);
      expect(customers.hasMore, isFalse);
      customers = await Customer.list(limit: 10, endingBefore: customers.data.first.id);
      expect(customers.data.length, 10);
      expect(customers.hasMore, isFalse);

    });

  });

}