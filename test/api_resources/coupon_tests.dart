library coupon_tests;

import 'dart:convert';

import 'package:unittest/unittest.dart';

import '../../lib/stripe.dart';
import '../utils.dart' as utils;

var exampleCoupon = '''
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
    }''';

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
      var couponDuration = 'forever',
          couponPercentOff = 5;

      var coupon = await (new CouponCreation()
        ..duration = couponDuration
        ..percentOff = couponPercentOff).create();
      expect(coupon.id, new isInstanceOf<String>());
      expect(coupon.duration, couponDuration);
      expect(coupon.percentOff, couponPercentOff);
    });

    test('CouponCreation full', () async {

      // Coupon fields
      var couponId = 'test id',
          couponDuration = 'repeating',
          couponAmountOff = 10,
          couponCurrency = 'usd',
          couponDurationInMoths = 12,
          couponMaxRedemptions = 3,
          couponMetadata = {'foo': 'bar'},
          couponRedeemBy = 1451520000;

      var coupon = await (new CouponCreation()
        ..id = couponId
        ..duration = couponDuration
        ..amountOff = couponAmountOff
        ..currency = couponCurrency
        ..durationInMonths = couponDurationInMoths
        ..maxRedemptions = couponMaxRedemptions
        ..metadata = couponMetadata
        ..redeemBy = couponRedeemBy).create();
      expect(coupon.id, couponId);
      expect(coupon.duration, couponDuration);
      expect(coupon.amountOff, couponAmountOff);
      expect(coupon.currency, couponCurrency);
      expect(coupon.durationInMonths, couponDurationInMoths);
      expect(coupon.maxRedemptions, couponMaxRedemptions);
      expect(coupon.metadata, couponMetadata);
      expect(coupon.redeemBy, couponRedeemBy);
      coupon = await Coupon.retrieve(coupon.id);
      // testing retrieve
      expect(coupon.id, couponId);
      expect(coupon.duration, couponDuration);
      expect(coupon.amountOff, couponAmountOff);
      expect(coupon.currency, couponCurrency);
      expect(coupon.durationInMonths, couponDurationInMoths);
      expect(coupon.maxRedemptions, couponMaxRedemptions);
      expect(coupon.metadata, couponMetadata);
      expect(coupon.redeemBy, couponRedeemBy);
    });

    test('Delete Coupon', () async {

      // Coupon fields
      var couponDuration = 'forever',
          couponPercentOff = 5;

      var coupon = await (new CouponCreation()
        ..duration = couponDuration
        ..percentOff = couponPercentOff).create();
      expect(coupon.id, new isInstanceOf<String>());
      expect(coupon.duration, couponDuration);
      expect(coupon.percentOff, couponPercentOff);
      var response = await Coupon.delete(coupon.id);
      expect(response['deleted'], isTrue);
      expect(response['id'], coupon.id);
    });

    test('List parameters Coupon', () async {

      // Coupon fields
      var couponDuration = 'forever',
          couponPercentOff = 5;
      for (var i = 0; i < 20; i++) {
        await (new CouponCreation()
          ..duration = couponDuration
          ..percentOff = couponPercentOff).create();
      }

      var coupons = await Coupon.list(limit: 10);
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
