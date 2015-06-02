library plan_tests;

import 'dart:convert';

import 'package:unittest/unittest.dart';

import '../../lib/stripe.dart';
import '../utils.dart' as utils;

var examplePlan = '''
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
    }''';

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
      var planId = 'test id',
          planAmount = 10,
          planCurrency = 'usd',
          planInterval = 'month',
          planName = 'test name';

      var plan = await (new PlanCreation()
        ..id = planId
        ..amount = planAmount
        ..currency = planCurrency
        ..interval = planInterval
        ..name = planName).create();
      expect(plan.id, planId);
      expect(plan.amount, planAmount);
      expect(plan.currency, planCurrency);
      expect(plan.interval, planInterval);
      expect(plan.name, planName);
    });

    test('PlanCreation full', () async {

      // plan fields
      var planId = 'test id',
          planAmount = 10,
          planCurrency = 'usd',
          planInterval = 'month',
          planIntervalCount = 2,
          planName1 = 'test name',
          planTrialPeriodDays = 3,
          planMetadata1 = {'foo': 'bar1'},
          planStatementDescriptor1 = 'descriptor1',
          planName2 = 'test name2',
          planMetadata2 = {'foo': 'bar2'},
          planStatementDescriptor2 = 'descriptor2';

      var plan = await (new PlanCreation()
        ..id = planId
        ..amount = planAmount
        ..currency = planCurrency
        ..interval = planInterval
        ..intervalCount = planIntervalCount
        ..name = planName1
        ..trialPeriodDays = planTrialPeriodDays
        ..metadata = planMetadata1
        ..statementDescriptor = planStatementDescriptor1).create();
      expect(plan.id, planId);
      expect(plan.amount, planAmount);
      expect(plan.currency, planCurrency);
      expect(plan.interval, planInterval);
      expect(plan.intervalCount, planIntervalCount);
      expect(plan.name, planName1);
      expect(plan.trialPeriodDays, planTrialPeriodDays);
      expect(plan.metadata, planMetadata1);
      expect(plan.statementDescriptor, planStatementDescriptor1);
      plan = await Plan.retrieve(plan.id);
      expect(plan.id, planId);
      expect(plan.amount, planAmount);
      expect(plan.currency, planCurrency);
      expect(plan.interval, planInterval);
      expect(plan.intervalCount, planIntervalCount);
      expect(plan.name, planName1);
      expect(plan.trialPeriodDays, planTrialPeriodDays);
      expect(plan.metadata, planMetadata1);
      expect(plan.statementDescriptor, planStatementDescriptor1);
      plan = await (new PlanUpdate()
        ..name = planName2
        ..metadata = planMetadata2
        ..statementDescriptor = planStatementDescriptor2).update(plan.id);
      // testing update
      expect(plan.id, planId);
      expect(plan.name, planName2);
      expect(plan.metadata, planMetadata2);
      expect(plan.statementDescriptor, planStatementDescriptor2);
    });

    test('Delete Plan', () async {

      // plan fields
      var planId = 'test id',
          planAmount = 10,
          planCurrency = 'usd',
          planInterval = 'month',
          planName = 'test name';

      var plan = await (new PlanCreation()
        ..id = planId
        ..amount = planAmount
        ..currency = planCurrency
        ..interval = planInterval
        ..name = planName).create();
      expect(plan.id, planId);
      expect(plan.amount, planAmount);
      expect(plan.currency, planCurrency);
      expect(plan.interval, planInterval);
      expect(plan.name, planName);
      var response = await Plan.delete(plan.id);
      expect(response['deleted'], isTrue);
      expect(response['id'], plan.id);
    });

    test('List parameters plan', () async {

      // plan fields
      var planId = 'test id',
          planAmount = 10,
          planCurrency = 'usd',
          planInterval = 'month',
          planName = 'test name';

      for (var i = 0; i < 20; i++) {
        await (new PlanCreation()
          ..id = planId + i.toString()
          ..amount = planAmount
          ..currency = planCurrency
          ..interval = planInterval
          ..name = planName + i.toString()).create();
      }
      var plans = await Plan.list(limit: 10);
      expect(plans.data.length, 10);
      expect(plans.hasMore, isTrue);
      plans = await Plan.list(limit: 10, startingAfter: plans.data.last.id);
      expect(plans.data.length, 10);
      expect(plans.hasMore, isFalse);
      plans = await Plan.list(limit: 10, endingBefore: plans.data.first.id);
      expect(plans.data.length, 10);
      expect(plans.hasMore, isFalse);
    });
  });
}
