library customer_tests;

import 'dart:convert';

import 'package:unittest/unittest.dart';

import '../../lib/stripe.dart';
import '../utils.dart' as utils;

var example = '''
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
    }''';

main(List<String> args) {
  utils.setApiKeyFromArgs(args);

  group('Customer offline', () {
    test('fromMap() properly popullates all values', () {
      var map = JSON.decode(example);
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
      var customer = await new CustomerCreation().create();
      expect(customer.id, new isInstanceOf<String>());
    });

    test('CustomerCreation full', () async {

      // Card fields
      var cardNumber1 = '4242424242424242',
          cardExpMonth1 = 12,
          cardExpYear1 = 2016;

      var cardCreation1 = new CardCreation()
        ..number = cardNumber1 // only the last 4 digits can be tested
        ..expMonth = cardExpMonth1
        ..expYear = cardExpYear1;

      var cardNumber2 = '5555555555554444',
          cardExpMonth2 = 3,
          cardExpYear2 = 2016;

      var cardCreation2 = new CardCreation()
        ..number = cardNumber2 // only the last 4 digits can be tested
        ..expMonth = cardExpMonth2
        ..expYear = cardExpYear2;

      // Coupon fields
      var couponId1 = 'test coupon id1',
          couponDuration1 = 'forever',
          couponPercentOff1 = 15;

      var couponCreation1 = new CouponCreation()
        ..id = couponId1
        ..duration = couponDuration1
        ..percentOff = couponPercentOff1;

      var couponId2 = 'test coupon id2',
          couponDuration2 = 'forever',
          couponPercentOff2 = 20;

      var couponCreation2 = new CouponCreation()
        ..id = couponId2
        ..duration = couponDuration2
        ..percentOff = couponPercentOff2;

      // Plan fields
      var planId = 'test plan id',
          planAmount = 200,
          planCurrency = 'usd',
          planInterval = 'month',
          planName = 'test plan name';

      var planCreation = new PlanCreation()
        ..id = planId
        ..amount = planAmount
        ..currency = planCurrency
        ..interval = planInterval
        ..name = planName;

      // Customer fields
      var customerAccountBalance1 = 100001,
          customerDescription1 = 'test description1',
          customerEmail1 = 'test1@test.com',
          customerMetadata1 = {'foo': 'bar1'},
          customerQuantity = 5,
          customerTrialEnd = new DateTime.now().add(new Duration(days: 60)).millisecondsSinceEpoch ~/ 1000,
          // for update tests
          customerAccountBalance2 = 200002,
          customerDescription2 = 'test description2',
          customerEmail2 = 'test2@test.com',
          customerMetadata2 = {'foo': 'bar2'};

      var customerCreation = new CustomerCreation()
        ..accountBalance = customerAccountBalance1
        ..card = cardCreation1
        ..coupon = couponId1
        ..description = customerDescription1
        ..email = customerEmail1
        ..metadata = customerMetadata1
        ..plan = planId
        ..quantity = customerQuantity
        ..trialEnd = customerTrialEnd;

      await couponCreation1.create();
      await couponCreation2.create();
      await planCreation.create();
      var customer = await customerCreation.create();
      expect(customer.id, new isInstanceOf<String>());

      // card tests
      expect(customer.cards.data.first.last4, cardNumber1.substring(cardNumber1.length - 4));
      expect(customer.cards.data.first.expMonth, cardExpMonth1);
      expect(customer.cards.data.first.expYear, cardExpYear1);

      // coupon tests
      expect(customer.discount.coupon.id, couponId1);
      expect(customer.discount.coupon.duration, couponDuration1);
      expect(customer.discount.coupon.percentOff, couponPercentOff1);
      expect(customer.discount.start.runtimeType, DateTime);
      expect(customer.discount.subscription, isNull);
      expect(customer.discount.customer, customer.id);

      expect(customer.description, customerDescription1);
      expect(customer.email, customerEmail1);

      // plan / subscription tests
      var subscription = customer.subscriptions.data.first;
      expect(subscription.customer, customer.id);
      expect(subscription.applicationFeePercent, isNull);
      expect(subscription.cancelAtPeriodEnd, isFalse);
      expect(subscription.canceledAt, isNull);
      expect(subscription.discount, isNull);
      expect(subscription.endedAt, isNull);
      expect(subscription.quantity, customerQuantity);
      expect(subscription.status, 'trialing');
      expect(subscription.trialEnd, new DateTime.fromMillisecondsSinceEpoch(customerTrialEnd * 1000));
      expect(subscription.plan, new isInstanceOf<Plan>());
      expect(subscription.plan.amount, planAmount);
      expect(subscription.plan.currency, planCurrency);
      expect(subscription.plan.id, planId);
      expect(subscription.plan.interval, planInterval);
      expect(subscription.plan.name, planName);
      var invoices = await Invoice.list(customer: customer.id);
      expect(invoices.data.first.startingBalance, customerAccountBalance1);
      customer = await Customer.retrieve(customer.id, data: {'expand': ['default_card']});
      // testing the expand functionality of retrieve
      expect(customer.defaultCard, customer.defaultCardExpand.id);
      expect(customer.defaultCardExpand.last4, cardNumber1.substring(cardNumber1.length - 4));

      // testing the CustomerUpdate
      var updatedCustomer = await (new CustomerUpdate()
        ..accountBalance = customerAccountBalance2
        ..card = cardCreation2
        ..coupon = couponId2
        ..description = customerDescription2
        ..email = customerEmail2
        ..metadata = customerMetadata2).update(customer.id);
      expect(updatedCustomer.accountBalance, customerAccountBalance2);
      expect(updatedCustomer.defaultCard, isNot(customer.defaultCard));
      expect(updatedCustomer.discount.coupon.percentOff, couponPercentOff2);
      expect(updatedCustomer.description, customerDescription2);
      expect(updatedCustomer.email, customerEmail2);
      expect(updatedCustomer.metadata, customerMetadata2);
    });

    test('Delete Customer', () async {
      var customer = await new CustomerCreation().create();
      var response = await Customer.delete(customer.id);
      expect(response['deleted'], isTrue);
      expect(response['id'], customer.id);
    });

    test('List parameters Customer', () async {
      for (var i = 0; i < 20; i++) {
        await new CustomerCreation().create();
      }

      var customers = await Customer.list(limit: 10);
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
