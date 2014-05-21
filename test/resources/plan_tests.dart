library plan_tests;

import 'dart:convert';
import 'dart:async';

import 'package:unittest/unittest.dart';

import '../../lib/stripe.dart';
import '../utils.dart' as utils;

var examplePlan = """
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

  group('Plan offline', () {

    test('fromMap() properly popullates all values', () {

      var map = JSON.decode(examplePlan);

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

  });

  group('Plan online', () {

    setUp(() {
      return utils.setUp();
    });

    tearDown(() {
      return utils.tearDown();
    });

    test('PlanCreation minimal', () {
      // plan fields
      Plan testPlan;
      String testPlanId = 'test id';
      int testPlanAmount = 10;
      String testPlanCurrency = 'usd';
      String testPlanInterval = 'month';
      String testPlanName = 'test name';

      (new PlanCreation()
      ..id = testPlanId
      ..amount = testPlanAmount
      ..currency = testPlanCurrency
      ..interval = testPlanInterval
      ..name = testPlanName
      ).create()
      .then((Plan plan) {
        testPlan = plan;
        expect(plan.id, testPlanId);
        expect(plan.amount, equals(testPlanAmount));
        expect(plan.currency, equals(testPlanCurrency));
        expect(plan.interval, equals(testPlanInterval));
        expect(plan.name, equals(testPlanName));
      })
      .then(expectAsync((_) => true));
    });

    test('PlanCreation full', () {
      // plan fields
      Plan testPlan;
      String testPlanId = 'test id';
      int testPlanAmount = 10;
      String testPlanCurrency = 'usd';
      String testPlanInterval = 'month';
      int testPlanIntervalCount = 2;
      String testPlanName1 = 'test name';
      int testPlanTrialPeriodDays = 3;
      Map testPlanMetadata1 = {'foo': 'bar1'};
      String testPlanStatementDescription1 = 'description1';

      String testPlanName2 = 'test name2';
      Map testPlanMetadata2 = {'foo': 'bar2'};
      String testPlanStatementDescription2 = 'description2';

      (new PlanCreation()
          ..id = testPlanId
          ..amount = testPlanAmount
          ..currency = testPlanCurrency
          ..interval = testPlanInterval
          ..intervalCount = testPlanIntervalCount
          ..name = testPlanName1
          ..trialPeriodDays = testPlanTrialPeriodDays
          ..metadata = testPlanMetadata1
          ..statementDescription = testPlanStatementDescription1
      ).create()
      .then((Plan plan) {
        testPlan = plan;
        expect(plan.id, testPlanId);
        expect(plan.amount, equals(testPlanAmount));
        expect(plan.currency, equals(testPlanCurrency));
        expect(plan.interval, equals(testPlanInterval));
        expect(plan.intervalCount, equals(testPlanIntervalCount));
        expect(plan.name, equals(testPlanName1));
        expect(plan.trialPeriodDays, equals(testPlanTrialPeriodDays));
        expect(plan.metadata, equals(testPlanMetadata1));
        expect(plan.statementDescription, equals(testPlanStatementDescription1));
        return Plan.retrieve(plan.id);
      })
      // testing retrieve
      .then((Plan plan) {
        expect(plan.id, testPlanId);
        expect(plan.amount, equals(testPlanAmount));
        expect(plan.currency, equals(testPlanCurrency));
        expect(plan.interval, equals(testPlanInterval));
        expect(plan.intervalCount, equals(testPlanIntervalCount));
        expect(plan.name, equals(testPlanName1));
        expect(plan.trialPeriodDays, equals(testPlanTrialPeriodDays));
        expect(plan.metadata, equals(testPlanMetadata1));
        expect(plan.statementDescription, equals(testPlanStatementDescription1));
        return (new PlanUpdate()
            ..name = testPlanName2
            ..metadata = testPlanMetadata2
            ..statementDescription = testPlanStatementDescription2
        ).update(plan.id);
      })
      // testing update
      .then((Plan plan) {
        expect(plan.id, testPlanId);
        expect(plan.name, equals(testPlanName2));
        expect(plan.metadata, equals(testPlanMetadata2));
        expect(plan.statementDescription, equals(testPlanStatementDescription2));
      })

      .then(expectAsync((_) => true));
    });


    test('List parameters plan', () {
    // plan fields
    Plan testPlan;
    String testPlanId = 'test id';
    int testPlanAmount = 10;
    String testPlanCurrency = 'usd';
    String testPlanInterval = 'month';
    String testPlanName = 'test name';

      List<Future> queue = [];
      for (var i = 0; i < 20; i++) {
        queue.add((new PlanCreation()
        ..id = testPlanId + i.toString()
        ..amount = testPlanAmount
        ..currency = testPlanCurrency
        ..interval = testPlanInterval
        ..name = testPlanName + i.toString()
        ).create());
      }

      Future.wait(queue)
      .then((_) => Plan.list(limit: 10))
      .then((PlanCollection plans) {
        expect(plans.data.length, equals(10));
        expect(plans.hasMore, equals(true));
        return Plan.list(limit: 10, startingAfter: plans.data.last.id);
      })
      .then((PlanCollection plans) {
        expect(plans.data.length, equals(10));
        expect(plans.hasMore, equals(false));
        return Plan.list(limit: 10, endingBefore: plans.data.first.id);
      })
      .then((PlanCollection plans) {
        expect(plans.data.length, equals(10));
        expect(plans.hasMore, equals(false));
      })
      .then(expectAsync((_) => true));

    });

  });

}