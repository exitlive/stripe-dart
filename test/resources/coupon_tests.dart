library coupon_tests;

import 'dart:convert';

import 'package:unittest/unittest.dart';

import '../../lib/stripe.dart';
import '../utils.dart' as utils;

var exampleCoupon = """
    {
      "id": "50-pc-forever-once",
      "created": 1397741615,
      "percent_off": 50,
      "amount_off": null,
      "currency": "usd",
      "object": "coupon",
      "livemode": false,
      "duration": "forever",
      "redeem_by": 1397748842,
      "max_redemptions": null,
      "times_redeemed": 0,
      "duration_in_months": null,
      "valid": false,
      "metadata": {
      }
    }""";


main(List<String> args) {

  utils.setApiKeyFromArgs(args);

  group('Coupon offline', () {

    test('fromMap() properly popullates all values', () {
      var map = JSON.decode(exampleCoupon);

      var coupon = new Coupon.fromMap(map);

      expect(coupon.id, map['id']);
      expect(coupon.created, new DateTime.fromMillisecondsSinceEpoch(map['created'] * 1000));
      expect(coupon.percentOff, map['percent_off']);
      expect(coupon.amountOff, map['amount_off']);
      expect(coupon.currency, map['currency']);
      expect(coupon.livemode, map['livemode']);
      expect(coupon.duration, map['duration']);
      expect(coupon.redeemBy, map['redeem_by']);
      expect(coupon.maxRedemptions, map['max_redemptions']);
      expect(coupon.timesRedeemed, map['times_redeemed']);
      expect(coupon.durationInMonths, map['duration_in_months']);
      expect(coupon.valid, map['valid']);
      expect(coupon.metadata, map['metadata']);

    });

  });

  group('Coupon online', () {

    tearDown(() {
      return utils.tearDown();
    });

    test('CouponCreation minimal', () async {

      // Coupon fields
      String testDuration = 'forever';
      int testPercentOff = 5;

      Coupon coupon = await (new CouponCreation()
          ..duration = testDuration
          ..percentOff = testPercentOff
      ).create();
      expect(coupon.id, new isInstanceOf<String>());
      expect(coupon.duration, testDuration);
      expect(coupon.percentOff, testPercentOff);

    });


    test('CouponCreation full', () async {

      // Coupon fields
      String testId = 'test id';
      String testDuration = 'repeating';
      int testAmountOff = 10;
      String testCurrency = 'usd';
      int testDurationInMoths = 12;
      int testMaxRedemptions = 3;
      Map testMetadata = {'foo': 'bar'};
      int testRedeemBy = 1451520000;

      Coupon coupon = await (new CouponCreation()
          ..id = testId
          ..duration = testDuration
          ..amountOff = testAmountOff
          ..currency = testCurrency
          ..durationInMonths = testDurationInMoths
          ..maxRedemptions = testMaxRedemptions
          ..metadata = testMetadata
          ..redeemBy = testRedeemBy
      ).create();
      expect(coupon.id, testId);
      expect(coupon.duration, testDuration);
      expect(coupon.amountOff, testAmountOff);
      expect(coupon.currency, testCurrency);
      expect(coupon.durationInMonths, testDurationInMoths);
      expect(coupon.maxRedemptions, testMaxRedemptions);
      expect(coupon.metadata, testMetadata);
      expect(coupon.redeemBy, testRedeemBy);
      coupon = await Coupon.retrieve(coupon.id);
      // testing retrieve
      expect(coupon.id, testId);
      expect(coupon.duration, testDuration);
      expect(coupon.amountOff, testAmountOff);
      expect(coupon.currency, testCurrency);
      expect(coupon.durationInMonths, testDurationInMoths);
      expect(coupon.maxRedemptions, testMaxRedemptions);
      expect(coupon.metadata, testMetadata);
      expect(coupon.redeemBy, testRedeemBy);

    });

    test('Delete Coupon', () async {

      // Coupon fields
      String testDuration = 'forever';
      int testPercentOff = 5;

      Coupon coupon = await (new CouponCreation()
          ..duration = testDuration
          ..percentOff = testPercentOff
      ).create();
      expect(coupon.id, new isInstanceOf<String>());
      expect(coupon.duration, testDuration);
      expect(coupon.percentOff, testPercentOff);
      Map response = await Coupon.delete(coupon.id);
      expect(response['deleted'], isTrue);
      expect(response['id'], coupon.id);

    });

    test('List parameters Coupon', () async {

      // Coupon fields
      String testDuration = 'forever';
      int testPercentOff = 5;
      for (var i = 0; i < 20; i++) {
        await (new CouponCreation()
            ..duration = testDuration
            ..percentOff = testPercentOff
        ).create();
      }

      CouponCollection coupons = await Coupon.list(limit: 10);
      expect(coupons.data.length, 10);
      expect(coupons.hasMore, isTrue);
      coupons = await Coupon.list(limit: 10, startingAfter: coupons.data.last.id);
      expect(coupons.data.length, 10);
      expect(coupons.hasMore, isFalse);
      coupons = await Coupon.list(limit: 10, endingBefore: coupons.data.first.id);
      expect(coupons.data.length, 10);
      expect(coupons.hasMore, isFalse);

    });

  });

}