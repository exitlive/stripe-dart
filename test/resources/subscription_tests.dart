library subscription_tests;

import 'dart:async';
import 'dart:convert';

import 'package:unittest/unittest.dart';

import '../../lib/stripe.dart';
import '../utils.dart' as utils;


var exampleSubscription = """
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
        "statement_description": null
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
    }""";


main(List<String> args) {

  utils.setApiKeyFromArgs(args);

  group('Subscription offline', () {

    test('fromMap() properly popullates all values', () {

      var map = JSON.decode(exampleSubscription);
      var subscription = new Subscription.fromMap(map);
      expect(subscription.id, equals(map['id']));
      expect(subscription.plan.interval, equals(map['plan']['interval']));
      expect(subscription.plan.name, equals(map['plan']['name']));
      expect(subscription.plan.created, equals(new DateTime.fromMillisecondsSinceEpoch(map['plan']['created'] * 1000)));
      expect(subscription.plan.amount, equals(map['plan']['amount']));
      expect(subscription.plan.currency, equals(map['plan']['currency']));
      expect(subscription.plan.id, equals(map['plan']['id']));
      expect(subscription.plan.livemode, equals(map['plan']['livemode']));
      expect(subscription.plan.intervalCount, equals(map['plan']['interval_count']));
      expect(subscription.plan.trialPeriodDays, equals(map['plan']['trial_period_days']));
      expect(subscription.plan.metadata, equals(map['plan']['metadata']));
      expect(subscription.plan.statementDescription, equals(map['plan']['statement_description']));
      expect(subscription.start, equals(new DateTime.fromMillisecondsSinceEpoch(map['start'] * 1000)));
      expect(subscription.status, equals(map['status']));
      expect(subscription.customer, equals(map['customer']));
      expect(subscription.cancelAtPeriodEnd, equals(map['cancel_at_period_end']));
      expect(subscription.currentPeriodStart, equals(new DateTime.fromMillisecondsSinceEpoch(map['current_period_start'] * 1000)));
      expect(subscription.currentPeriodEnd, equals(new DateTime.fromMillisecondsSinceEpoch(map['current_period_end'] * 1000)));
      expect(subscription.endedAt, equals(map['endet_at']));
      expect(subscription.trialStart, equals(map['trial_start']));
      expect(subscription.trialEnd, equals(map['trial_end']));
      expect(subscription.canceledAt, equals(map['canceled_at']));
      expect(subscription.quantity, equals(map['quantity']));
      expect(subscription.applicationFeePercent, equals(map['application_fee_percent']));
      expect(subscription.discount, equals(map['discount']));
      expect(subscription.metadata, equals(map['metadata']));

    });

  });

  group('Subscription online', () {

    setUp(() {
      return utils.setUp();
    });

    tearDown(() {
      return utils.tearDown();
    });

    test('SubscriptionCreation minimal', () {

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
            expect(subscription.plan.id, equals(testPlanId));
            expect(subscription.customer, equals(testCustomer.id));
          })
          .then(expectAsync((_) => true));

    });


    test('SubscriptionCreation full', () {

      // Coupon fields
      Coupon testCoupon1;
      String testCouponId1 = 'test coupon id1';
      String testCouponDuration1 = 'forever';
      int testCouponPercentOff1 = 15;

      CouponCreation testCouponCreation1 = new CouponCreation()
          ..id = testCouponId1
          ..duration = testCouponDuration1
          ..percentOff = testCouponPercentOff1;

      Coupon testCoupon2;
      String testCouponId2 = 'test coupon id2';
      String testCouponDuration2 = 'forever';
      int testCouponPercentOff2 = 10;

      CouponCreation testCouponCreation2 = new CouponCreation()
          ..id = testCouponId2
          ..duration = testCouponDuration2
          ..percentOff = testCouponPercentOff2;

      // Customer fields
      Customer testCustomer;

      // Card fields
      Card testCard1;
      String testCardNumber1 = '4242424242424242';
      int testCardExpMonth1 = 12;
      int testCardExpYear1 = 2015;

      CardCreation testCardCreation1 = new CardCreation()
          ..number = testCardNumber1 // only the last 4 digits can be tested
          ..expMonth = testCardExpMonth1
          ..expYear = testCardExpYear1;

      Card testCard2;
      String testCardNumber2 = '5555555555554444';
      int testCardExpMonth2 = 3;
      int testCardExpYear2 = 2016;

      CardCreation testCardCreation2 = new CardCreation()
          ..number = testCardNumber2 // only the last 4 digits can be tested
          ..expMonth = testCardExpMonth2
          ..expYear = testCardExpYear2;

      // Plan fields
      Plan testPlan1;
      String testPlanId1 = 'test plan id1';
      int testPlanAmount1 = 100;
      String testPlanCurrency1 = 'usd';
      String testPlanInterval1 = 'month';
      String testPlanName1 = 'test plan name1';

      PlanCreation testPlanCreation1 = new PlanCreation()
          ..id = testPlanId1
          ..amount = testPlanAmount1
          ..currency = testPlanCurrency1
          ..interval = testPlanInterval1
          ..name = testPlanName1;

      Plan testPlan2;
      String testPlanId2 = 'test plan id2';
      int testPlanAmount2 = 200;
      String testPlanCurrency2 = 'usd';
      String testPlanInterval2 = 'month';
      String testPlanName2 = 'test plan name2';

      PlanCreation testPlanCreation2 = new PlanCreation()
          ..id = testPlanId2
          ..amount = testPlanAmount2
          ..currency = testPlanCurrency2
          ..interval = testPlanInterval2
          ..name = testPlanName2;

      // Subscription fields
      int testSubscriptionTrialEnd1 = new DateTime.now().add(new Duration(days: 30)).millisecondsSinceEpoch ~/ 1000;
      int testSubscriptionQuantity1 = 3;
      // application_fee_percent can only be tested with OAuth key
      Map testSubscriptionMetadata1 = {'foo': 'bar1'};

      int testSubscriptionTrialEnd2 = new DateTime.now().add(new Duration(days: 60)).millisecondsSinceEpoch ~/ 1000;
      int testSubscriptionQuantity2 = 1;
      // application_fee_percent can only be tested with OAuth key
      Map testSubscriptionMetadata2 = {'foo': 'bar2'};

      testPlanCreation1.create()
          .then((Plan plan) {
            testPlan1 = plan;
            return testPlanCreation2.create();
          })
          .then((Plan plan) {
            testPlan2 = plan;
            return testCouponCreation1.create();
          })
          .then((Coupon coupon) {
            testCoupon1 = coupon;
            return testCouponCreation2.create();
          })
          .then((Coupon coupon) {
            testCoupon2 = coupon;
            return new CustomerCreation().create();
          })
          .then((Customer customer) {
            testCustomer = customer;
            return (
                new SubscriptionCreation()
                    ..plan = testPlan1.id
                    ..coupon = testCoupon1.id
                    ..trialEnd = testSubscriptionTrialEnd1
                    ..card = testCardCreation1
                    ..quantity = testSubscriptionQuantity1
                    ..metadata = testSubscriptionMetadata1
            ).create(testCustomer.id);
          })
          .then((Subscription subscription) {
            expect(subscription.plan.id, equals(testPlanId1));
            expect(subscription.discount.coupon.percentOff, equals(testCouponPercentOff1));
            expect(subscription.trialEnd, equals(new DateTime.fromMillisecondsSinceEpoch(testSubscriptionTrialEnd1 * 1000)));
            expect(subscription.customer, equals(testCustomer.id));
            expect(subscription.quantity, equals(testSubscriptionQuantity1));
            expect(subscription.metadata, equals(testSubscriptionMetadata1));
            return Subscription.retrieve(testCustomer.id, subscription.id , data: {'expand': ['customer']});
          })
          // testing the expand functionality of retrieve
          .then((Subscription subscription) {
            expect(subscription.customer, equals(subscription.customerExpand.id));

            // testing the CustomerUpdate
            return (new SubscriptionUpdate()
                ..plan = testPlan2.id
                ..coupon = testCoupon2.id
                ..trialEnd = testSubscriptionTrialEnd2
                ..card = testCardCreation2
                ..quantity = testSubscriptionQuantity2
                ..metadata = testSubscriptionMetadata2
            ).update(testCustomer.id, subscription.id);
          })
          .then((Subscription subscription) {
            expect(subscription.plan.id, equals(testPlanId2));
            expect(subscription.discount.coupon.percentOff, equals(testCouponPercentOff2));
            expect(subscription.trialEnd, equals(new DateTime.fromMillisecondsSinceEpoch(testSubscriptionTrialEnd2 * 1000)));
            expect(subscription.customer, equals(testCustomer.id));
            expect(subscription.quantity, equals(testSubscriptionQuantity2));
            expect(subscription.metadata, equals(testSubscriptionMetadata2));
            return Subscription.cancel(testCustomer.id, subscription.id);
          })
          // testing cancel
          .then((Subscription subscription) {
            expect(subscription.status, equals('canceled'));
            expect(subscription.cancelAtPeriodEnd, isFalse);
          })
          .then(expectAsync((_) => true));

    });

    test('List parameters subscription', () {

      // Card fields
      Customer testCustomer;

      // Card fields
      Card testCard;
      String testCardNumber = '4242424242424242';
      int testCardExpMonth = 12;
      int testCardExpYear = 2015;

      CardCreation testCardCreation = new CardCreation()
          ..number = testCardNumber // only the last 4 digits can be tested
          ..expMonth = testCardExpMonth
          ..expYear = testCardExpYear;

      // Plan fields
      Plan testPlan;
      String testPlanId = 'test plan id';
      int testPlanAmount = 100;
      String testPlanCurrency = 'usd';
      String testPlanInterval = 'month';
      String testPlanName = 'test plan name';

      PlanCreation testPlanCreation = new PlanCreation()
          ..id = testPlanId
          ..amount = testPlanAmount
          ..currency = testPlanCurrency
          ..interval = testPlanInterval
          ..name = testPlanName;

      (new CustomerCreation()
          ..card = testCardCreation
      ).create()
          .then((Customer customer) {
            testCustomer = customer;
            return testPlanCreation.create();
          })
          .then((Plan plan) {
            testPlan = plan;
            List<Future> queue = [];
            for (var i = 0; i < 20; i++) {
              queue.add(
                (new SubscriptionCreation()
                    ..plan = plan.id
                ).create(testCustomer.id)
              );
            }
            return Future.wait(queue);
          })
          .then((_) => Subscription.list(testCustomer.id, limit: 10))
          .then((SubscriptionCollection subscriptions) {
            expect(subscriptions.data.length, equals(10));
            expect(subscriptions.hasMore, equals(true));
            return Subscription.list(testCustomer.id, limit: 10, startingAfter: subscriptions.data.last.id);
          })
          .then((SubscriptionCollection subscriptions) {
            expect(subscriptions.data.length, equals(10));
            expect(subscriptions.hasMore, equals(false));
            return Subscription.list(testCustomer.id, limit: 10, endingBefore: subscriptions.data.first.id);
          })
          .then((SubscriptionCollection subscriptions) {
            expect(subscriptions.data.length, equals(10));
            expect(subscriptions.hasMore, equals(false));
          })
          .then(expectAsync((_) => true));

    });

  });

}