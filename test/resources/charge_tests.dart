library charge_tests;

import 'dart:async';
import 'dart:convert';

import 'package:unittest/unittest.dart';

import '../../lib/stripe.dart';
import '../utils.dart' as utils;


var exampleCharge = """
    {
      "id": "ch_14Vgs241dfVNZFcqCPsJ6tE3",
      "object": "charge",
      "created": 1409047690,
      "livemode": false,
      "paid": true,
      "amount": 100,
      "currency": "usd",
      "refunded": false,
      "card": {
        "id": "card_14Vgrn41dfVNZFcqRTHBOptX",
        "object": "card",
        "last4": "4242",
        "brand": "Visa",
        "funding": "credit",
        "exp_month": 12,
        "exp_year": 2015,
        "fingerprint": "2OcV4uXscDkio6R5",
        "country": "US",
        "name": null,
        "address_line1": null,
        "address_line2": null,
        "address_city": null,
        "address_state": null,
        "address_zip": null,
        "address_country": null,
        "cvc_check": null,
        "address_line1_check": null,
        "address_zip_check": null,
        "customer": "cus_4f0tFpk50P2eqR"
      },
      "captured": true,
      "refunds": {
        "object": "list",
        "total_count": 0,
        "has_more": false,
        "url": "/v1/charges/ch_14Vgs241dfVNZFcqCPsJ6tE3/refunds",
        "data": [
    
        ]
      },
      "balance_transaction": "txn_14Vgru41dfVNZFcqX95wJCtm",
      "failure_message": null,
      "failure_code": null,
      "amount_refunded": 0,
      "customer": "cus_4f0tFpk50P2eqR",
      "invoice": "in_14Vgs141dfVNZFcqQYhvqV4Q",
      "description": null,
      "dispute": null,
      "metadata": {
      },
      "statement_descriptor": null,
      "receipt_email": null
    }""";


main(List<String> args) {

  utils.setApiKeyFromArgs(args);

  group('Charge offline', () {

    test('fromMap() properly popullates all values', () {

      var map = JSON.decode(exampleCharge);
      var charge = new Charge.fromMap(map);
      expect(charge.id, equals(map['id']));
      expect(charge.created, equals(new DateTime.fromMillisecondsSinceEpoch(map['created'] * 1000)));
      expect(charge.livemode, equals(map['livemode']));
      expect(charge.paid, equals(map['paid']));
      expect(charge.amount, equals(map['amount']));
      expect(charge.currency, equals(map['currency']));
      expect(charge.refunded, equals(map['refunded']));
      expect(charge.customer, equals(map['customer']));
      expect(charge.card, new isInstanceOf<Card>());
      expect(charge.card.id, new Card.fromMap(map['card']).id);
      expect(charge.description, equals(map['description']));
      expect(charge.metadata, equals(map['metadata']));
      expect(charge.statement_descriptor, equals(map['statement_descriptor']));
      expect(charge.captured, equals(map['captured']));
      expect(charge.failureMessage, equals(map['failureMessage']));
      expect(charge.failureCode, equals(map['failureCode']));
      expect(charge.amountRefunded, equals(map['amountRefunded']));
      expect(charge.refunds.data.length, equals(map['refunds']['data'].length));
      expect(charge.dispute, equals(map['dispute']));
      expect(charge.balanceTransaction, equals(map['balance_transaction']));

    });

  });

  group('Charge online', () {

    setUp(() {
      return utils.setUp();
    });

    tearDown(() {
      return utils.tearDown();
    });

    test('ChargeCreation minimal', () {

      // Customer fields
      Customer testCustomer;
      // Card fields
      String testCardNumber = '4242424242424242';
      int testCardExpMonth = 12;
      int testCardExpYear = 2015;
      // Charge fields
      int testChargeAmount = 100;
      String testChargeCurrency = 'usd';
      new CustomerCreation().create()
          .then((Customer customer) {
            testCustomer = customer;
            return (new CardCreation()
                ..number = testCardNumber
                ..expMonth = testCardExpMonth
                ..expYear = testCardExpYear
            ).create(testCustomer.id);
          })
          .then((Card card) {
            return (new ChargeCreation()
                ..amount = testChargeAmount
                ..currency = testChargeCurrency
                ..customer = testCustomer.id
            ).create();
          })
          .then((Charge charge) {
            expect(charge.amount, equals(testChargeAmount));
            expect(charge.currency, equals(testChargeCurrency));
          })
          .then(expectAsync((_) => true));

    });

    test('ChargeCreation full', () {

      // Customer fields
      Customer testCustomer;

      // Card fields
      String testCardNumber = '4242424242424242';
      int testCardExpMonth = 12;
      int testCardExpYear = 2015;

      // Charge fields
      Charge testCharge;
      int testChargeAmount = 100;
      String testChargeCurrency = 'usd';
      String testChargeDescription1 = 'test description1';
      String testChargeDescription2 = 'test description2';
      Map testChargeMetadata1 = {'foo': 'bar1'};
      Map testChargeMetadata2 = {'foo': 'bar2'};
      bool testChargeCapture = false;
      String testChargeStatementDescriptor = 'test descriptor';
      // application_fee can not be tested

      new CustomerCreation().create()
          .then((Customer customer) {
            testCustomer = customer;
            return (new CardCreation()
                ..number = testCardNumber
                ..expMonth = testCardExpMonth
                ..expYear = testCardExpYear
            ).create(testCustomer.id);
          })
          .then((Card card) {
            return (new ChargeCreation()
                ..amount = testChargeAmount
                ..currency = testChargeCurrency
                ..customer = testCustomer.id
                ..description = testChargeDescription1
                ..metadata = testChargeMetadata1
                ..capture = testChargeCapture
                ..statementDescriptor = testChargeStatementDescriptor
            ).create();
          })
          .then((Charge charge) {
            testCharge = charge;
            expect(charge.amount, equals(testChargeAmount));
            expect(charge.currency, equals(testChargeCurrency));
            expect(charge.description, equals(testChargeDescription1));
            expect(charge.metadata, equals(testChargeMetadata1));
            expect(charge.captured, equals(testChargeCapture));
            expect(charge.statement_descriptor, equals(testChargeStatementDescriptor));
            // testing the expand functionality of retrieve
            return Charge.retrieve(charge.id, data: {'expand': ['balance_transaction', 'customer', 'invoice']});
          })
          .then((Charge charge) {
            expect(charge.customer, equals(charge.customerExpand.id));

            // testing the ChargeUpdate
            return (new ChargeUpdate()
                ..description = testChargeDescription2
                ..metadata = testChargeMetadata2
            ).update(testCharge.id);
          })
          .then((Charge charge) {
            testCharge = charge;
            expect(charge.description, equals(testChargeDescription2));
            expect(charge.metadata, equals(testChargeMetadata2));
          })
          .then(expectAsync((_) => true));

    });

    test('Refund a Charge', () {

      // Customer fields
      Customer testCustomer;

      // Card fields
      String testCardNumber = '4242424242424242';
      int testCardExpMonth = 12;
      int testCardExpYear = 2015;

      // Charge fields
      int testChargeAmount = 100;
      int testChargeRefundAmount = 90;
      String testChargeCurrency = 'usd';
      // application_fee can not be tested

      new CustomerCreation().create()
          .then((Customer customer) {
            testCustomer = customer;
            return (new CardCreation()
                ..number = testCardNumber
                ..expMonth = testCardExpMonth
                ..expYear = testCardExpYear
            ).create(testCustomer.id);
          })
          .then((Card card) {
            return (new ChargeCreation()
                ..amount = testChargeAmount
                ..currency = testChargeCurrency
                ..customer = testCustomer.id
            ).create();
          })
          .then((Charge charge) => Charge.refund(charge.id, amount: testChargeRefundAmount))
          .then((Charge charge) {
            expect(charge.refunds.data.first.amount, testChargeRefundAmount);
          })
          .then(expectAsync((_) => true));

    });

    test('Capture a Charge', () {

      // Customer fields
      Customer testCustomer;

      // Card fields
      String testCardNumber = '4242424242424242';
      int testCardExpMonth = 12;
      int testCardExpYear = 2015;

      // Charge fields
      int testChargeAmount = 100;
      int testChargeCaptureAmount = 90;
      String testChargeCurrency = 'usd';
      // application_fee can not be tested

      new CustomerCreation().create()
          .then((Customer customer) {
            testCustomer = customer;
            return (new CardCreation()
                ..number = testCardNumber
                ..expMonth = testCardExpMonth
                ..expYear = testCardExpYear
            ).create(testCustomer.id);
          })
          .then((Card card) {
            return (new ChargeCreation()
                ..amount = testChargeAmount
                ..currency = testChargeCurrency
                ..customer = testCustomer.id
                ..capture = false
            ).create();
          })
          .then((Charge charge) => Charge.capture(charge.id, amount: testChargeCaptureAmount))
          .then((Charge charge) {
            expect(charge.captured, true);
          })
          .then(expectAsync((_) => true));

    });

    test('List parameters charge', () {

      // Customer fields
      Customer testCustomer;

      // Card fields
      Card testCard;
      String testCardNumber = '4242424242424242';
      int testCardExpMonth = 12;
      int testCardExpYear = 2015;

      new CustomerCreation().create()
          .then((Customer customer) {
            testCustomer = customer;
            return (new CardCreation()
                ..number = testCardNumber
                ..expMonth = testCardExpMonth
                ..expYear = testCardExpYear
            ).create(testCustomer.id);
          })
          .then((Card card) {
            testCard = card;
            List<Future> queue = [];
            for (var i = 0; i < 20; i++) {
              // Charge fields
              int testChargeAmount = 100;
              int testChargeCaptureAmount = 90;
              String testChargeCurrency = 'usd';
              // application_fee can not be tested
              queue.add(
                  (new ChargeCreation()
                      ..amount = testChargeAmount
                      ..currency = testChargeCurrency
                      ..customer = testCustomer.id
                      ..capture = false
                  ).create()
              );
            }
            return Future.wait(queue);
          })
          .then((_) => Charge.list(customer: testCustomer.id, limit: 10))
          .then((ChargeCollection charge) {
            expect(charge.data.length, equals(10));
            expect(charge.hasMore, equals(true));
            return Charge.list(customer: testCustomer.id, limit: 10, startingAfter: charge.data.last.id);
          })
          .then((ChargeCollection charge) {
            expect(charge.data.length, equals(10));
            expect(charge.hasMore, equals(false));
            return Charge.list(customer: testCustomer.id, limit: 10, endingBefore: charge.data.first.id);
          })
          .then((ChargeCollection charge) {
            expect(charge.data.length, equals(10));
            expect(charge.hasMore, equals(false));
          })
          .then(expectAsync((_) => true));

    });

  });

}