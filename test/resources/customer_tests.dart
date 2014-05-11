library customer_tests;

import "dart:convert";

import 'package:unittest/unittest.dart';

import '../../lib/stripe.dart';
import '../utils.dart' as utils;

import "dart:async";

var exampleObject = """
                    {
                      "object": "customer",
                      "created": 1390621405,
                      "id": "cus_3N7bW2v8TfGKvk",
                      "livemode": false,
                      "description": "Random description",
                      "email": "test@example.com",
                      "delinquent": false,
                      "metadata": {
                        "test": "yeah"
                      },
                      "subscription": null,
                      "discount": null,
                      "account_balance": 0,
                      "currency": "usd",
                      "cards": {
                        "object": "list",
                        "count": 0,
                        "url": "/v1/customers/cus_3N7bW2v8TfGKvk/cards",
                        "data": [
                    
                        ]
                      },
                      "default_card": null
                    }""";


main(List<String> args) {

  utils.setApiKeyFromArgs(args);

  group('Customer', () {

    setUp(() {
      return utils.setUp();
    });

    tearDown(() {
      return utils.tearDown();
    });

    test("fromMap() properly popullates all values", () {
      var map = JSON.decode(exampleObject);

      var customer = new Customer.fromMap(map);

      expect(customer.created, equals(new DateTime.fromMillisecondsSinceEpoch(map["created"] * 1000)));
      expect(customer.id, equals(map["id"]));
      expect(customer.livemode, equals(map["livemode"]));
      expect(customer.description, equals(map["description"]));
      expect(customer.email, equals(map["email"]));
      expect(customer.delinquent, equals(map["delinquent"]));
      expect(customer.metadata, equals(map["metadata"]));
      expect(customer.subscription, equals(map["subscription"]));
      expect(customer.discount, equals(map["discount"]));
      expect(customer.accountBalance, equals(map["account_balance"]));
      expect(customer.currency, equals(map["currency"]));
      expect(customer.cards, new isInstanceOf<CustomerCardCollection>());
      expect(customer.cards.count, map["cards"]["count"]);
      expect(customer.cards.url, map["cards"]["url"]);
      expect(customer.defaultCard, equals(map["default_card"]));
    });

    test("CustomerCreation minimal", () {
      Future future = new CustomerCreation().create();
      future.then((Customer customer) {
        expect(customer.id, new isInstanceOf<String>());
      });
      expect(future, completes);
    });


    // TODO: add plan, quantity and trialEnd
    test("CustomerCreation full", () {

      // Card fields
      String testNumber = "4242424242424242";
      int testExpMonth = 12;
      int testExpYear = 2015;
      String testName = "Mike Rotch";
      String testAddressLine1 = "Addresslinestreet 12/42A";
      String testAddressLine2 = "additional address line";
      String testAddressCity = "Laguna Beach";
      String testAddressZip = "92651";
      String testAddressCountry = "USA";

      CardCreation testCard = new CardCreation()
          ..number = testNumber
          ..expMonth = testExpMonth
          ..expYear = testExpYear
          ..cvc = 123 // this value can not be tested
          ..name = testName
          ..addressLine1 = testAddressLine1
          ..addressLine2 = testAddressLine2
          ..addressCity = testAddressCity
          ..addressZip = testAddressZip
          ..addressCountry = testAddressCountry;

      // Coupon fields
      String testId = "test id";
      String testDuration = "repeating";
      int testAmountOff = 10;
      String testCurrency = "usd";
      int testDurationInMoths = 12;
      int testMaxRedemptions = 3;
      Map testMetadata = {"foo": "bar"};
      int testRedeemBy = 1451520000;

      Coupon testCoupon;
      CouponCreation testCouponCreation = new CouponCreation()
          ..id = testId
          ..duration = testDuration
          ..amountOff = testAmountOff
          ..currency = testCurrency
          ..durationInMonths = testDurationInMoths
          ..maxRedemptions = testMaxRedemptions
          ..metadata = testMetadata
          ..redeemBy = testRedeemBy;

      // Customer fields
      int testAccountBalance = 100001;
      String testDescription = "test description";
      String testEmail = "test@test.com";
      // testMetatdata already defined in the Coupon fields
      // Map testMetadata = {"foo": "bar"};

      CustomerCreation testCustomerCreation = new CustomerCreation()
          ..accountBalance = testAccountBalance
          ..card = testCard
          ..coupon = testId
          ..description = testDescription
          ..email = testEmail
          ..metadata = testMetadata;

      Future future = testCouponCreation.create()

      .then((Coupon coupon) {
        testCoupon = coupon;
        return testCustomerCreation.create();
      })

      .then((Customer customer) {

        expect(customer.id, new isInstanceOf<String>());
        expect(customer.accountBalance, testAccountBalance);

        // card tests
        expect(customer.cards.data.first.last4, testNumber.substring(testNumber.length - 4));
        expect(customer.cards.data.first.expMonth, testExpMonth);
        expect(customer.cards.data.first.expYear, testExpYear);
        expect(customer.cards.data.first.name, testName);
        expect(customer.cards.data.first.addressLine1, testAddressLine1);
        expect(customer.cards.data.first.addressLine2, testAddressLine2);
        expect(customer.cards.data.first.addressCity, testAddressCity);
        expect(customer.cards.data.first.addressZip, testAddressZip);
        expect(customer.cards.data.first.addressCountry, testAddressCountry);
        expect(customer.cards.data.first.addressLine1Check, "pass");
        expect(customer.cards.data.first.addressZipCheck, "pass");
        expect(customer.cards.data.first.cvcCheck, "pass");

        // coupon tests
        expect(customer.discount.coupon.id, testId);
        expect(customer.discount.coupon.duration, testDuration);
        expect(customer.discount.coupon.amountOff, testAmountOff);
        expect(customer.discount.coupon.currency, testCurrency);
        expect(customer.discount.coupon.durationInMonths, testDurationInMoths);
        expect(customer.discount.coupon.maxRedemptions, testMaxRedemptions);
        expect(customer.discount.coupon.metadata, testMetadata);
        expect(customer.discount.coupon.redeemBy, testRedeemBy);
        expect(customer.discount.start.runtimeType, int);
        expect(customer.discount.end.runtimeType, int);
        expect(customer.discount.subscription, null);
        expect(customer.discount.customer, customer.id);

        expect(customer.description, testDescription);
        expect(customer.email, testEmail);
        expect(customer.metadata, testMetadata);

      });

      expect(future, completes);
    });
  });
}