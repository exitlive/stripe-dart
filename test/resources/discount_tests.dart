library discount_tests;

import 'dart:convert';

import 'package:unittest/unittest.dart';

import '../../lib/stripe.dart';
import '../utils.dart' as utils;


var exampleDiscount = """
    {
      "coupon": {
        "id": "25OFF",
        "created": 1400067246,
        "percent_off": 25,
        "amount_off": null,
        "currency": "usd",
        "object": "coupon",
        "livemode": false,
        "duration": "repeating",
        "redeem_by": null,
        "max_redemptions": null,
        "times_redeemed": 0,
        "duration_in_months": 3,
        "valid": true,
        "metadata": {
        }
      },
      "start": 1399314836,
      "object": "discount",
      "customer": "cus_41UmfewrwpkH2c",
      "subscription": null,
      "end": null
    }""";


main(List<String> args) {

  utils.setApiKeyFromArgs(args);

  group('Discount offline', () {

    test('fromMap() properly popullates all values', () {
      var map = JSON.decode(exampleDiscount);

      var discount = new Discount.fromMap(map);
      expect(discount.start, equals(new DateTime.fromMillisecondsSinceEpoch(map['start'] * 1000)));
      expect(discount.objectName, equals(map['object']));
      expect(discount.customer, equals(map['customer']));
      expect(discount.subscription, equals(map['subscription']));
      expect(discount.end, equals(map['end']));

      expect(discount.coupon.id, equals(map['coupon']['id']));
      expect(discount.coupon.created, equals(new DateTime.fromMillisecondsSinceEpoch(map['coupon']['created'] * 1000)));
      expect(discount.coupon.percentOff, equals(map['coupon']['percent_off']));
      expect(discount.coupon.amountOff, equals(map['coupon']['amount_off']));
      expect(discount.coupon.currency, equals(map['coupon']['currency']));
      expect(discount.coupon.objectName, equals(map['coupon']['object']));
      expect(discount.coupon.livemode, equals(map['coupon']['livemode']));
      expect(discount.coupon.duration, equals(map['coupon']['duration']));
      expect(discount.coupon.redeemBy, equals(map['coupon']['redeem_by']));
      expect(discount.coupon.maxRedemptions, equals(map['coupon']['max_redemptions']));
      expect(discount.coupon.timesRedeemed, equals(map['coupon']['times_redeemed']));
      expect(discount.coupon.durationInMonths, equals(map['coupon']['duration_in_months']));
      expect(discount.coupon.valid, equals(map['coupon']['valid']));
      expect(discount.coupon.metadata, equals(map['coupon']['metadata']));

    });

  });

  group('Discount online', () {

    setUp(() {
      return utils.setUp();
    });

    tearDown(() {
      return utils.tearDown();
    });

    test('delete from Customer', () {

      // Discount fields
      Discount testDiscount;

      // Customer fields
      Customer testCustomer;

      // Coupon fields
      String testCouponId = 'test coupon id';
      String testCouponDuration = 'forever';
      int testCouponPercentOff = 15;

      Coupon testCoupon;
      (new CouponCreation()
          ..id = testCouponId
          ..duration = testCouponDuration
          ..percentOff = testCouponPercentOff
      ).create()
      .then((Coupon coupon) {
        return (new CustomerCreation()
            ..coupon = coupon.id
        ).create();
      })
      .then((Customer customer) {
        testCustomer = customer;
        expect(customer.discount.coupon.percentOff, equals(testCouponPercentOff));
        testDiscount = customer.discount;
        return Discount.deleteForCustomer(customer.id);
      })
      .then((Map response) {
        expect(response['deleted'], isTrue);
        expect(response['id'], equals(testDiscount.id));
        return Customer.retrieve(testCustomer.id);
      })
      .then((Customer customer) {
        expect(customer.discount, isNull);
      })
      .then(expectAsync((_) => true));

    });


    test('delete from Subscription', () {

      // Discount fields
      Discount testDiscount;

      // Subscription fields
      Subscription testSubscription;

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

      // Coupon fields
      String testCouponId = 'test coupon id';
      String testCouponDuration = 'forever';
      int testCouponPercentOff = 15;

      Coupon testCoupon;

      (new CouponCreation()
          ..id = testCouponId
          ..duration = testCouponDuration
          ..percentOff = testCouponPercentOff
      ).create()
      .then((Coupon coupon) {
        testCoupon = coupon;
        return (new PlanCreation()
            ..id = testPlanId
            ..amount = testPlanAmount
            ..currency = testPlanCurrency
            ..interval = testPlanInterval
            ..name = testPlanName
        ).create();
      })
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
                ..coupon = testCoupon.id
        ).create(testCustomer.id);
      })
      .then((Subscription subscription) {
        testSubscription = subscription;
        expect(subscription.discount.coupon.percentOff, equals(testCouponPercentOff));
        testDiscount = subscription.discount;
        return Discount.deleteForSubscription(testCustomer.id, testSubscription.id);
      })
      .then((Map response) {
        expect(response['deleted'], isTrue);
        expect(response['id'], equals(testDiscount.id));
        return Subscription.retrieve(testCustomer.id, testSubscription.id);
      })
      .then((Subscription subscription) {
        expect(subscription.discount, isNull);

      })
      .then(expectAsync((_) => true));

    });

  });

}