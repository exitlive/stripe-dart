library plan_tests;

import 'dart:convert';

import 'package:unittest/unittest.dart';

import '../../lib/stripe.dart';
import '../utils.dart' as utils;

var exampleObject = """
    {
      "interval": "month",
      "name": "Gold Special",
      "created": 1399650846,
      "amount": 2000,
      "currency": "usd",
      "id": "gold",
      "object": "plan",
      "livemode": false,
      "interval_count": 1,
      "trial_period_days": null,
      "metadata": {
      },
      "statement_description": null
    }""";


main(List<String> args) {

  utils.setApiKeyFromArgs(args);

  group('Plan', () {

    setUp(() {
      return utils.setUp();
    });

    tearDown(() {
      return utils.tearDown();
    });

    test('fromMap() properly popullates all values', () {
      var map = JSON.decode(exampleObject);

      var plan = new Plan.fromMap(map);

      expect(plan.created, equals(new DateTime.fromMillisecondsSinceEpoch(map['created'] * 1000)));
      expect(plan.id, equals(map['id']));
      expect(plan.livemode, equals(map['livemode']));
      expect(plan.interval, equals(map['interval']));
      expect(plan.name, equals(map['name']));
      expect(plan.amount, equals(map['amount']));
      expect(plan.metadata, equals(map['metadata']));
      expect(plan.currency, equals(map['currency']));
      expect(plan.intervalCount, equals(map['interval_count']));
      expect(plan.trialPeriodDays, equals(map['trial_period_days']));
      expect(plan.currency, equals(map['currency']));

    });

    test('PlanCreation minimal', () {
      Plan testPlan;
      String testId = 'test id';
      int testAmount = 10;
      String testCurrency = 'usd';
      String testInterval = 'month';
      String testName = 'test name';
      (new PlanCreation()
          ..id = testId
          ..amount = testAmount
          ..currency = testCurrency
          ..interval = testInterval
          ..name = testName
      ).create()
          .then((Plan plan) {
            testPlan = plan;
            expect(plan.id, new isInstanceOf<String>());
            expect(plan.amount, equals(testAmount));
            expect(plan.currency, equals(testCurrency));
            expect(plan.interval, equals(testInterval));
            expect(plan.name, equals(testName));
          })
          .then(expectAsync((_) => true));
    });

  });

}