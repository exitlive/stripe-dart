library discount_tests;

import "dart:convert";

import 'package:unittest/unittest.dart';

import '../../lib/stripe.dart';
import '../utils.dart' as utils;


var exampleObject = """
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

  group('Discount', () {


    test("fromMap() properly popullates all values", () {
      var map = JSON.decode(exampleObject);

      var discount = new Discount.fromMap(map);
      expect(discount.start, equals(new DateTime.fromMillisecondsSinceEpoch(map["start"] * 1000)));
      expect(discount.objectName, equals(map["object"]));
      expect(discount.customer, equals(map["customer"]));
      expect(discount.subscription, equals(map["subscription"]));
      expect(discount.end, equals(map["end"]));

      expect(discount.coupon.id, equals(map["coupon"]["id"]));
      expect(discount.coupon.created, equals(new DateTime.fromMillisecondsSinceEpoch(map["coupon"]["created"] * 1000)));
      expect(discount.coupon.percentOff, equals(map["coupon"]["percent_off"]));
      expect(discount.coupon.amountOff, equals(map["coupon"]["amount_off"]));
      expect(discount.coupon.currency, equals(map["coupon"]["currency"]));
      expect(discount.coupon.objectName, equals(map["coupon"]["object"]));
      expect(discount.coupon.livemode, equals(map["coupon"]["livemode"]));
      expect(discount.coupon.duration, equals(map["coupon"]["duration"]));
      expect(discount.coupon.redeemBy, equals(map["coupon"]["redeem_by"]));
      expect(discount.coupon.maxRedemptions, equals(map["coupon"]["max_redemptions"]));
      expect(discount.coupon.timesRedeemed, equals(map["coupon"]["times_redeemed"]));
      expect(discount.coupon.durationInMonths, equals(map["coupon"]["duration_in_months"]));
      expect(discount.coupon.valid, equals(map["coupon"]["valid"]));
      expect(discount.coupon.metadata, equals(map["coupon"]["metadata"]));

    });


  });

}