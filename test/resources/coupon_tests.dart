library coupon_tests;

import 'dart:convert';
import 'dart:async';

import 'package:unittest/unittest.dart';

import '../../lib/stripe.dart';
import '../utils.dart' as utils;

var exampleObject = """
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

  group('Coupon', () {

    setUp(() {
      return utils.setUp();
    });

    tearDown(() {
      return utils.tearDown();
    });

    test('fromMap() properly popullates all values', () {
      var map = JSON.decode(exampleObject);

      var coupon = new Coupon.fromMap(map);

      expect(coupon.id, equals(map['id']));
      expect(coupon.created, equals(new DateTime.fromMillisecondsSinceEpoch(map['created'] * 1000)));
      expect(coupon.percentOff, equals(map['percent_off']));
      expect(coupon.amountOff, equals(map['amount_off']));
      expect(coupon.currency, equals(map['currency']));
      expect(coupon.livemode, equals(map['livemode']));
      expect(coupon.duration, equals(map['duration']));
      expect(coupon.redeemBy, equals(map['redeem_by']));
      expect(coupon.maxRedemptions, equals(map['max_redemptions']));
      expect(coupon.timesRedeemed, equals(map['times_redeemed']));
      expect(coupon.durationInMonths, equals(map['duration_in_months']));
      expect(coupon.valid, equals(map['valid']));
      expect(coupon.metadata, equals(map['metadata']));

    });

    test('CouponCreation minimal', () {

      // Coupon fields
      String testDuration = 'forever';
      int testPercentOff = 5;

      (new CouponCreation()
          ..duration = testDuration
          ..percentOff = testPercentOff
      ).create()
        .then((Coupon coupon) {
          expect(coupon.id, new isInstanceOf<String>());
          expect(coupon.duration, equals(testDuration));
          expect(coupon.percentOff, equals(testPercentOff));
        })
        .then(expectAsync((_) => true));

    });


    test('CouponCreation full', () {

      // Coupon fields
      String testId = 'test id';
      String testDuration = 'repeating';
      int testAmountOff = 10;
      String testCurrency = 'usd';
      int testDurationInMoths = 12;
      int testMaxRedemptions = 3;
      Map testMetadata = {'foo': 'bar'};
      int testRedeemBy = 1451520000;

      (new CouponCreation()
          ..id = testId
          ..duration = testDuration
          ..amountOff = testAmountOff
          ..currency = testCurrency
          ..durationInMonths = testDurationInMoths
          ..maxRedemptions = testMaxRedemptions
          ..metadata = testMetadata
          ..redeemBy = testRedeemBy
      ).create()
        .then((Coupon coupon) {
          expect(coupon.id, equals(testId));
          expect(coupon.duration, equals(testDuration));
          expect(coupon.amountOff, equals(testAmountOff));
          expect(coupon.currency, equals(testCurrency));
          expect(coupon.durationInMonths, equals(testDurationInMoths));
          expect(coupon.maxRedemptions, equals(testMaxRedemptions));
          expect(coupon.metadata, equals(testMetadata));
          expect(coupon.redeemBy, equals(testRedeemBy));
        })
        .then(expectAsync((_) => true));

    });
  });
}