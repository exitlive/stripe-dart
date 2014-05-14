library customer_tests;

import "dart:convert";
import "dart:async";

import 'package:unittest/unittest.dart';

import '../../lib/stripe.dart';
import '../utils.dart' as utils;


var exampleObject = """
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
      expect(customer.subscriptions, new isInstanceOf<SubscriptionCollection>());
      expect(customer.discount, equals(map["discount"]));
      expect(customer.accountBalance, equals(map["account_balance"]));
      expect(customer.currency, equals(map["currency"]));
      expect(customer.cards, new isInstanceOf<CardCollection>());
      expect(customer.cards.data.length, equals(map["cards"]["data"].length));
      expect(customer.cards.url, equals(map["cards"]["url"]));
      expect(customer.defaultCard, equals(map["default_card"]));
    });

    test("CustomerCreation minimal", () {
      Future future = new CustomerCreation().create();
      future.then((Customer customer) {
        expect(customer.id, new isInstanceOf<String>());
      });
      expect(future, completes);
    });


    // TODO: quantity and trialEnd
    test("CustomerCreation full", () {

      // Card fields
      String testCardNumber = "4242424242424242";
      int testCardExpMonth = 12;
      int testCardExpYear = 2015;

      CardCreation testCard = new CardCreation()
          ..number = testCardNumber // only the last 4 digits can be tested
          ..expMonth = testCardExpMonth
          ..expYear = testCardExpYear;

      // Coupon fields
      String testCouponId = "test coupon id";
      String testCouponDuration = "forever";
      int testCouponPercentOff = 15;

      Coupon testCoupon;
      CouponCreation testCouponCreation = new CouponCreation()
          ..id = testCouponId
          ..duration = testCouponDuration
          ..percentOff = testCouponPercentOff;

      // Plan fields
      String testPlanId = "test plan id";
      int testPlanAmount = 200;
      String testPlanCurrency = "usd";
      String testPlanInterval = "month";
      String testPlanName = "test plan name";

      Plan testPlan;
      PlanCreation testPlanCreation = new PlanCreation()
          ..id = testPlanId
          ..amount = testPlanAmount
          ..currency = testPlanCurrency
          ..interval = testPlanInterval
          ..name = testPlanName;

      // Customer fields
      int testCustomerAccountBalance = 100001;
      String testCustomerDescription = "test description";
      String testCustomerEmail = "test@test.com";
      Map testCustomerMetadata = {"foo": "bar"};
      int testCustomerQuantity = 5;
      int testCustomerTrialEnd = new DateTime.now().add(new Duration(days: 60)).millisecondsSinceEpoch ~/ 1000;

      CustomerCreation testCustomerCreation = new CustomerCreation()
          ..accountBalance = testCustomerAccountBalance
          ..card = testCard
          ..coupon = testCouponId
          ..description = testCustomerDescription
          ..email = testCustomerEmail
          ..metadata = testCustomerMetadata
          ..plan = testPlanId
          ..quantity = testCustomerQuantity
          ..trialEnd = testCustomerTrialEnd;

      Future future = testCouponCreation.create()

      .then((Coupon coupon) {
        testCoupon = coupon;
        return testPlanCreation.create();
      })
      .then((Plan plan) {
        testPlan = plan;
        return testCustomerCreation.create();
      })

      .then((Customer customer) {

        expect(customer.id, new isInstanceOf<String>());
        expect(customer.accountBalance, equals(testCustomerAccountBalance));

        // card tests
        expect(customer.cards.data.first.last4, equals(testCardNumber.substring(testCardNumber.length - 4)));
        expect(customer.cards.data.first.expMonth, equals(testCardExpMonth));
        expect(customer.cards.data.first.expYear, equals(testCardExpYear));

        // coupon tests
        expect(customer.discount.coupon.id, equals(testCouponId));
        expect(customer.discount.coupon.duration, equals(testCouponDuration));
        expect(customer.discount.coupon.percentOff, equals(testCouponPercentOff));
        expect(customer.discount.start.runtimeType, equals(int));
        expect(customer.discount.subscription, equals(null));
        expect(customer.discount.customer, equals(customer.id));

        expect(customer.description, equals(testCustomerDescription));
        expect(customer.email, equals(testCustomerEmail));

        // plan / subscription tests
        Subscription subscription = customer.subscriptions.data.first;
        expect(subscription.customer, equals(customer.id));
        expect(subscription.applicationFeePercent, equals(null));
        expect(subscription.cancelAtPeriodEnd, equals(false));
        expect(subscription.canceledAt, equals(null));
        expect(subscription.discount, equals(null));
        expect(subscription.endedAt, equals(null));
        expect(subscription.quantity, equals(null));
        expect(subscription.status, equals("trialing"));
        expect(subscription.trialEnd, equals(testCustomerTrialEnd));
        expect(subscription.plan, new isInstanceOf<Plan>());
        Plan plan = subscription.plan;
        expect(plan.amount, equals(testPlanAmount));
        expect(plan.currency, equals(testPlanCurrency));
        expect(plan.id, equals(testPlanId));
        expect(plan.interval, equals(testPlanInterval));
        expect(plan.name, equals(testPlanName));

        return customer;

      })
      // testing the expand functionality of retrieve
      .then((Customer customer) => Customer.retrieve(customer.id, data: {"expand": ["default_card"]}))
      .then((Customer customer) {
        expect(customer.defaultCard, equals(customer.defaultCardExpand.id));
        expect(customer.defaultCardExpand.last4, equals(testCardNumber.substring(testCardNumber.length - 4)));

        return new Future.value();

      });
      expect(future, completes);
    });

    test("List parameters customer", () {
      List<Future> queue = [];
      for (var i = 0; i < 20; i++) {
        queue.add(new CustomerCreation().create());
      }

      Future future = Future.wait(queue)
          .then((_) => Customer.list(limit: 10))
          .then((CustomerCollection customers) {
            expect(customers.data.length, equals(10));
            expect(customers.hasMore, equals(true));
            return Customer.list(limit: 10, startingAfter: customers.data.last.id);
          })
          .then((CustomerCollection customers) {
            expect(customers.data.length, equals(10));
            expect(customers.hasMore, equals(false));
            return Customer.list(limit: 10, endingBefore: customers.data.first.id);
          })
          .then((CustomerCollection customers) {
            expect(customers.data.length, equals(10));
            expect(customers.hasMore, equals(false));
            return new Future.value();
          });

      expect(future, completes);

    });

  });
}