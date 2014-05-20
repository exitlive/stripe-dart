library subscription_tests;

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
      Coupon testCoupon;
      String testCouponId = 'test coupon id1';
      String testCouponDuration = 'forever';
      int testCouponPercentOff = 15;

      CouponCreation testCouponCreation = new CouponCreation()
          ..id = testCouponId
          ..duration = testCouponDuration
          ..percentOff = testCouponPercentOff;

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
      Plan testPlan;
      String testPlanId = 'test plan id';
      int testPlanAmount = 200;
      String testPlanCurrency = 'usd';
      String testPlanInterval = 'month';
      String testPlanName = 'test plan name';

      // Subscription fields
      int testSubscriptionTrialEnd = new DateTime.now().add(new Duration(days: 60)).millisecondsSinceEpoch ~/ 1000;
      int testSubscriptionQuantity = 3;
      // application_fee_percent can only be tested with OAuth key
      Map testSubscriptionMetadata = {'foo': 'bar'};

      (new PlanCreation()
          ..id = testPlanId
          ..amount = testPlanAmount
          ..currency = testPlanCurrency
          ..interval = testPlanInterval
          ..name = testPlanName
      ).create()
          .then((Plan plan) {
            testPlan = plan;
            return testCouponCreation.create();
          })
          .then((Coupon coupon) {
            testCoupon = coupon;
            return new CustomerCreation().create();
          })
          .then((Customer customer) {
            testCustomer = customer;
            return testCardCreation1.create(testCustomer.id);
          })
          .then((Card card) {
            testCard1 = card;
            return (
                new SubscriptionCreation()
                    ..plan = testPlan.id
                    ..coupon = testCoupon.id
                    ..trialEnd = testSubscriptionTrialEnd
                    ..card = testCardCreation2
                    ..quantity = testSubscriptionQuantity
                    ..metadata = testSubscriptionMetadata

            ).create(testCustomer.id);
          })
          .then((Subscription subscription) {
            expect(subscription.plan.id, equals(testPlanId));
            expect(subscription.discount.coupon.percentOff, equals(testCouponPercentOff));
            expect(subscription.trialEnd, equals(new DateTime.fromMillisecondsSinceEpoch(testSubscriptionTrialEnd * 1000)));
            expect(subscription.customer, equals(testCustomer.id));
            expect(subscription.quantity, equals(testSubscriptionQuantity));
            expect(subscription.metadata, equals(testSubscriptionMetadata));
          })
          .then(expectAsync((_) => true));
    });

  });
}