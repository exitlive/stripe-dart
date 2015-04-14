library plan_tests;

import 'dart:convert';

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
      "statement_descriptor": null
    }""";


main(List<String> args) {

  utils.setApiKeyFromArgs(args);

  group('Plan offline', () {

    test('fromMap() properly popullates all values', () {

      var map = JSON.decode(examplePlan);
      var plan = new Plan.fromMap(map);
      expect(plan.created, new DateTime.fromMillisecondsSinceEpoch(map['created'] * 1000));
      expect(plan.id, map['id']);
      expect(plan.livemode, map['livemode']);
      expect(plan.interval, map['interval']);
      expect(plan.name, map['name']);
      expect(plan.amount, map['amount']);
      expect(plan.metadata, map['metadata']);
      expect(plan.currency, map['currency']);
      expect(plan.intervalCount, map['interval_count']);
      expect(plan.trialPeriodDays, map['trial_period_days']);
      expect(plan.currency, map['currency']);

    });

  });

  group('Plan online', () {

    tearDown(() {
      return utils.tearDown();
    });

    test('PlanCreation minimal', () async {

      // plan fields
      String testPlanId = 'test id';
      int testPlanAmount = 10;
      String testPlanCurrency = 'usd';
      String testPlanInterval = 'month';
      String testPlanName = 'test name';

      Plan plan = await (new PlanCreation()
          ..id = testPlanId
          ..amount = testPlanAmount
          ..currency = testPlanCurrency
          ..interval = testPlanInterval
          ..name = testPlanName
      ).create();
      expect(plan.id, testPlanId);
      expect(plan.amount, testPlanAmount);
      expect(plan.currency, testPlanCurrency);
      expect(plan.interval, testPlanInterval);
      expect(plan.name, testPlanName);

    });

    test('PlanCreation full', () async {

      // plan fields
      String testPlanId = 'test id';
      int testPlanAmount = 10;
      String testPlanCurrency = 'usd';
      String testPlanInterval = 'month';
      int testPlanIntervalCount = 2;
      String testPlanName1 = 'test name';
      int testPlanTrialPeriodDays = 3;
      Map testPlanMetadata1 = {'foo': 'bar1'};
      String testPlanStatementDescriptor1 = 'descriptor1';

      String testPlanName2 = 'test name2';
      Map testPlanMetadata2 = {'foo': 'bar2'};
      String testPlanStatementDescriptor2 = 'descriptor2';

      Plan plan = await (new PlanCreation()
          ..id = testPlanId
          ..amount = testPlanAmount
          ..currency = testPlanCurrency
          ..interval = testPlanInterval
          ..intervalCount = testPlanIntervalCount
          ..name = testPlanName1
          ..trialPeriodDays = testPlanTrialPeriodDays
          ..metadata = testPlanMetadata1
          ..statementDescriptor = testPlanStatementDescriptor1
      ).create();
      expect(plan.id, testPlanId);
      expect(plan.amount, testPlanAmount);
      expect(plan.currency, testPlanCurrency);
      expect(plan.interval, testPlanInterval);
      expect(plan.intervalCount, testPlanIntervalCount);
      expect(plan.name, testPlanName1);
      expect(plan.trialPeriodDays, testPlanTrialPeriodDays);
      expect(plan.metadata, testPlanMetadata1);
      expect(plan.statementDescriptor, testPlanStatementDescriptor1);
      plan = await Plan.retrieve(plan.id);
      expect(plan.id, testPlanId);
      expect(plan.amount, testPlanAmount);
      expect(plan.currency, testPlanCurrency);
      expect(plan.interval, testPlanInterval);
      expect(plan.intervalCount, testPlanIntervalCount);
      expect(plan.name, testPlanName1);
      expect(plan.trialPeriodDays, testPlanTrialPeriodDays);
      expect(plan.metadata, testPlanMetadata1);
      expect(plan.statementDescriptor, testPlanStatementDescriptor1);
      plan = await (new PlanUpdate()
          ..name = testPlanName2
          ..metadata = testPlanMetadata2
          ..statementDescriptor = testPlanStatementDescriptor2
      ).update(plan.id);
      // testing update
      expect(plan.id, testPlanId);
      expect(plan.name, testPlanName2);
      expect(plan.metadata, testPlanMetadata2);
      expect(plan.statementDescriptor, testPlanStatementDescriptor2);

    });

    test('Delete Plan', () async {

      // plan fields
      String testPlanId = 'test id';
      int testPlanAmount = 10;
      String testPlanCurrency = 'usd';
      String testPlanInterval = 'month';
      String testPlanName = 'test name';

      Plan plan = await (new PlanCreation()
          ..id = testPlanId
          ..amount = testPlanAmount
          ..currency = testPlanCurrency
          ..interval = testPlanInterval
          ..name = testPlanName
      ).create();
      expect(plan.id, testPlanId);
      expect(plan.amount, testPlanAmount);
      expect(plan.currency, testPlanCurrency);
      expect(plan.interval, testPlanInterval);
      expect(plan.name, testPlanName);
      Map response = await Plan.delete(plan.id);
      expect(response['deleted'], isTrue);
      expect(response['id'], plan.id);

    });

    test('List parameters plan', () async {

      // plan fields
      String testPlanId = 'test id';
      int testPlanAmount = 10;
      String testPlanCurrency = 'usd';
      String testPlanInterval = 'month';
      String testPlanName = 'test name';

      for (var i = 0; i < 20; i++) {
        await (new PlanCreation()
            ..id = testPlanId + i.toString()
            ..amount = testPlanAmount
            ..currency = testPlanCurrency
            ..interval = testPlanInterval
            ..name = testPlanName + i.toString()
        ).create();
      }
      PlanCollection plans = await Plan.list(limit: 10);
      expect(plans.data.length, 10);
      expect(plans.hasMore, true);
      plans = await Plan.list(limit: 10, startingAfter: plans.data.last.id);
      expect(plans.data.length, 10);
      expect(plans.hasMore, false);
      plans = await Plan.list(limit: 10, endingBefore: plans.data.first.id);
      expect(plans.data.length, 10);
      expect(plans.hasMore, false);

    });

  });

}