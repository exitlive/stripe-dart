library subscription_tests;

import 'dart:convert';

import 'package:unittest/unittest.dart';

import '../../lib/stripe.dart';
import '../utils.dart' as utils;

var example = '''
    {
      "id": "sub_43wlRGGERnM2nU",
      "plan": {
        "interval": "month",
        "name": "New plan name",
        "created": 1386247539,
        "amount": 2000,
        "currency": "usd",
        "id": "gold21323",
        "object": "plan",
        "livemode": false,
        "interval_count": 1,
        "trial_period_days": null,
        "metadata": {
        },
        "statement_descriptor": null
      },
      "object": "subscription",
      "start": 1400498611,
      "status": "active",
      "customer": "cus_43vyiOaVQ6zjp4",
      "cancel_at_period_end": false,
      "current_period_start": 1400498611,
      "current_period_end": 1403177011,
      "ended_at": null,
      "trial_start": null,
      "trial_end": null,
      "canceled_at": null,
      "quantity": 1,
      "application_fee_percent": null,
      "discount": null,
      "metadata": {
      }
    }''';

var collectionExample = '''
    {
      "object": "list",
      "total_count": 1,
      "has_more": false,
      "url": "/v1/customers/cus_43vyiOaVQ6zjp4/subscriptions",
      "data": [${example}]
    }''';

main(List<String> args) {
  utils.setApiKeyFromArgs(args);

  group('Subscription offline', () {
    test('fromMap() properly popullates all values', () {
      var map = JSON.decode(example);
      var subscription = new Subscription.fromMap(map);
      expect(subscription.id, map['id']);
      expect(subscription.plan.interval, map['plan']['interval']);
      expect(subscription.plan.name, map['plan']['name']);
      expect(subscription.plan.created, new DateTime.fromMillisecondsSinceEpoch(map['plan']['created'] * 1000));
      expect(subscription.plan.amount, map['plan']['amount']);
      expect(subscription.plan.currency, map['plan']['currency']);
      expect(subscription.plan.id, map['plan']['id']);
      expect(subscription.plan.livemode, map['plan']['livemode']);
      expect(subscription.plan.intervalCount, map['plan']['interval_count']);
      expect(subscription.plan.trialPeriodDays, map['plan']['trial_period_days']);
      expect(subscription.plan.metadata, map['plan']['metadata']);
      expect(subscription.plan.statementDescriptor, map['plan']['statement_descriptor']);
      expect(subscription.start, new DateTime.fromMillisecondsSinceEpoch(map['start'] * 1000));
      expect(subscription.status, map['status']);
      expect(subscription.customer, map['customer']);
      expect(subscription.cancelAtPeriodEnd, map['cancel_at_period_end']);
      expect(
          subscription.currentPeriodStart, new DateTime.fromMillisecondsSinceEpoch(map['current_period_start'] * 1000));
      expect(subscription.currentPeriodEnd, new DateTime.fromMillisecondsSinceEpoch(map['current_period_end'] * 1000));
      expect(subscription.endedAt, map['endet_at']);
      expect(subscription.trialStart, map['trial_start']);
      expect(subscription.trialEnd, map['trial_end']);
      expect(subscription.canceledAt, map['canceled_at']);
      expect(subscription.quantity, map['quantity']);
      expect(subscription.applicationFeePercent, map['application_fee_percent']);
      expect(subscription.discount, map['discount']);
      expect(subscription.metadata, map['metadata']);
    });
  });

  group('Subscription online', () {
    tearDown(() {
      return utils.tearDown();
    });

    test('Create minimal', () async {
      // Card fields
      var cardNumber = '5555555555554444', cardExpMonth = 3, cardExpYear = 2016;

      var cardCreation = new CardCreation()
        ..number = cardNumber // only the last 4 digits can be tested
        ..expMonth = cardExpMonth
        ..expYear = cardExpYear;

      // Plan fields
      var planId = 'test plan id',
          planAmount = 200,
          planCurrency = 'usd',
          planInterval = 'month',
          planName = 'test plan name';

      var plan = await (new PlanCreation()
        ..id = planId
        ..amount = planAmount
        ..currency = planCurrency
        ..interval = planInterval
        ..name = planName).create();
      var customer = await new CustomerCreation().create();
      await cardCreation.create(customer.id);
      var subscription = await (new SubscriptionCreation()..plan = plan.id).create(customer.id);
      expect(subscription.plan.id, planId);
      expect(subscription.customer, customer.id);
    });

    test('Create full', () async {
      // Coupon fields
      var couponId1 = 'test coupon id1', couponDuration1 = 'forever', couponPercentOff1 = 15;

      var couponCreation1 = new CouponCreation()
        ..id = couponId1
        ..duration = couponDuration1
        ..percentOff = couponPercentOff1;

      var couponId2 = 'test coupon id2', couponDuration2 = 'forever', couponPercentOff2 = 10;

      var couponCreation2 = new CouponCreation()
        ..id = couponId2
        ..duration = couponDuration2
        ..percentOff = couponPercentOff2;

      // Card fields
      var cardNumber1 = '4242424242424242', cardExpMonth1 = 12, cardExpYear1 = 2016;

      var cardCreation1 = new CardCreation()
        ..number = cardNumber1 // only the last 4 digits can be tested
        ..expMonth = cardExpMonth1
        ..expYear = cardExpYear1;

      var cardNumber2 = '5555555555554444', cardExpMonth2 = 3, cardExpYear2 = 2016;

      var cardCreation2 = new CardCreation()
        ..number = cardNumber2 // only the last 4 digits can be tested
        ..expMonth = cardExpMonth2
        ..expYear = cardExpYear2;

      // Plan fields
      var planId1 = 'test plan id1',
          planAmount1 = 100,
          planCurrency1 = 'usd',
          planInterval1 = 'month',
          planName1 = 'test plan name1';

      var planCreation1 = new PlanCreation()
        ..id = planId1
        ..amount = planAmount1
        ..currency = planCurrency1
        ..interval = planInterval1
        ..name = planName1;

      var planId2 = 'test plan id2',
          planAmount2 = 200,
          planCurrency2 = 'usd',
          planInterval2 = 'month',
          planName2 = 'test plan name2';

      var planCreation2 = new PlanCreation()
        ..id = planId2
        ..amount = planAmount2
        ..currency = planCurrency2
        ..interval = planInterval2
        ..name = planName2;

      // Subscription fields
      var subscriptionTrialEnd1 = new DateTime.now().add(new Duration(days: 30)).millisecondsSinceEpoch ~/ 1000,
          subscriptionQuantity1 = 3,
          // application_fee_percent can only be tested with OAuth key
          subscriptionMetadata1 = {'foo': 'bar1'},
          subscriptionTrialEnd2 = new DateTime.now().add(new Duration(days: 60)).millisecondsSinceEpoch ~/ 1000,
          subscriptionQuantity2 = 1,
          // application_fee_percent can only be tested with OAuth key
          subscriptionMetadata2 = {'foo': 'bar2'};

      var plan1 = await planCreation1.create();
      var plan2 = await planCreation2.create();
      var coupon1 = await couponCreation1.create();
      var coupon2 = await couponCreation2.create();
      var customer = await new CustomerCreation().create();
      var subscription = await (new SubscriptionCreation()
        ..plan = plan1.id
        ..coupon = coupon1.id
        ..trialEnd = subscriptionTrialEnd1
        ..card = cardCreation1
        ..quantity = subscriptionQuantity1
        ..metadata = subscriptionMetadata1).create(customer.id);
      expect(subscription.plan.id, planId1);
      expect(subscription.discount.coupon.percentOff, couponPercentOff1);
      expect(subscription.trialEnd, new DateTime.fromMillisecondsSinceEpoch(subscriptionTrialEnd1 * 1000));
      expect(subscription.customer, customer.id);
      expect(subscription.quantity, subscriptionQuantity1);
      expect(subscription.metadata, subscriptionMetadata1);
      subscription = await Subscription.retrieve(customer.id, subscription.id, data: {
        'expand': ['customer']
      });
      // testing the expand functionality of retrieve
      expect(subscription.customer, subscription.customerExpand.id);

      // testing the CustomerUpdate
      subscription = await (new SubscriptionUpdate()
        ..plan = plan2.id
        ..coupon = coupon2.id
        ..trialEnd = subscriptionTrialEnd2
        ..card = cardCreation2
        ..quantity = subscriptionQuantity2
        ..metadata = subscriptionMetadata2).update(customer.id, subscription.id);
      expect(subscription.plan.id, planId2);
      expect(subscription.discount.coupon.percentOff, couponPercentOff2);
      expect(subscription.trialEnd, new DateTime.fromMillisecondsSinceEpoch(subscriptionTrialEnd2 * 1000));
      expect(subscription.customer, customer.id);
      expect(subscription.quantity, subscriptionQuantity2);
      expect(subscription.metadata, subscriptionMetadata2);
      subscription = await Subscription.cancel(customer.id, subscription.id);
      // testing cancel
      expect(subscription.status, 'canceled');
      expect(subscription.cancelAtPeriodEnd, isFalse);
    });

    test('List parameters', () async {
      // Card fields
      var cardNumber = '4242424242424242', cardExpMonth = 12, cardExpYear = 2016;

      var cardCreation = new CardCreation()
        ..number = cardNumber // only the last 4 digits can be tested
        ..expMonth = cardExpMonth
        ..expYear = cardExpYear;

      // Plan fields
      var planId = 'test plan id',
          planAmount = 100,
          planCurrency = 'usd',
          planInterval = 'month',
          planName = 'test plan name';

      var planCreation = new PlanCreation()
        ..id = planId
        ..amount = planAmount
        ..currency = planCurrency
        ..interval = planInterval
        ..name = planName;

      var customer = await (new CustomerCreation()..source = cardCreation).create();
      var plan = await planCreation.create();
      for (var i = 0; i < 20; i++) {
        await (new SubscriptionCreation()..plan = plan.id).create(customer.id);
      }
      var subscriptions = await Subscription.list(customer.id, limit: 10);
      expect(subscriptions.data.length, 10);
      expect(subscriptions.hasMore, isTrue);
      subscriptions = await Subscription.list(customer.id, limit: 10, startingAfter: subscriptions.data.last.id);
      expect(subscriptions.data.length, 10);
      expect(subscriptions.hasMore, isFalse);
      subscriptions = await Subscription.list(customer.id, limit: 10, endingBefore: subscriptions.data.first.id);
      expect(subscriptions.data.length, 10);
      expect(subscriptions.hasMore, isFalse);
    });
  });
}
