library charge_tests;

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
        "exp_year": 2016,
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

    tearDown(() {
      return utils.tearDown();
    });

    test('ChargeCreation minimal', () async {

      // Card fields
      String testCardNumber = '4242424242424242';
      int testCardExpMonth = 12;
      int testCardExpYear = 2016;
      // Charge fields
      int testChargeAmount = 100;
      String testChargeCurrency = 'usd';
      Customer customer = await new CustomerCreation().create();
      await (new CardCreation()
          ..number = testCardNumber
          ..expMonth = testCardExpMonth
          ..expYear = testCardExpYear
      ).create(customer.id);
      Charge charge = await (new ChargeCreation()
          ..amount = testChargeAmount
          ..currency = testChargeCurrency
          ..customer = customer.id
      ).create();
      expect(charge.amount, equals(testChargeAmount));
      expect(charge.currency, equals(testChargeCurrency));

    });

    test('ChargeCreation full', () async {

      // Card fields
      String testCardNumber = '4242424242424242';
      int testCardExpMonth = 12;
      int testCardExpYear = 2016;

      // Charge fields
      int testChargeAmount = 100;
      String testChargeCurrency = 'usd';
      String testChargeDescription1 = 'test description1';
      String testChargeDescription2 = 'test description2';
      Map testChargeMetadata1 = {'foo': 'bar1'};
      Map testChargeMetadata2 = {'foo': 'bar2'};
      bool testChargeCapture = false;
      String testChargeStatementDescriptor = 'test descriptor';
      // application_fee can not be tested

      Customer customer = await new CustomerCreation().create();
      await (new CardCreation()
          ..number = testCardNumber
          ..expMonth = testCardExpMonth
          ..expYear = testCardExpYear
      ).create(customer.id);
      Charge charge = await (new ChargeCreation()
          ..amount = testChargeAmount
          ..currency = testChargeCurrency
          ..customer = customer.id
          ..description = testChargeDescription1
          ..metadata = testChargeMetadata1
          ..capture = testChargeCapture
          ..statementDescriptor = testChargeStatementDescriptor
      ).create();
      expect(charge.amount, equals(testChargeAmount));
      expect(charge.currency, equals(testChargeCurrency));
      expect(charge.description, equals(testChargeDescription1));
      expect(charge.metadata, equals(testChargeMetadata1));
      expect(charge.captured, equals(testChargeCapture));
      expect(charge.statement_descriptor, equals(testChargeStatementDescriptor));
      // testing the expand functionality of retrieve
      charge = await Charge.retrieve(charge.id, data: {'expand': ['balance_transaction', 'customer', 'invoice']});
      expect(charge.customer, equals(charge.customerExpand.id));

      // testing the ChargeUpdate
      charge = await (new ChargeUpdate()
          ..description = testChargeDescription2
          ..metadata = testChargeMetadata2
      ).update(charge.id);
      expect(charge.description, equals(testChargeDescription2));
      expect(charge.metadata, equals(testChargeMetadata2));

    });

    test('Refund a Charge', () async {

      // Card fields
      String testCardNumber = '4242424242424242';
      int testCardExpMonth = 12;
      int testCardExpYear = 2016;

      // Charge fields
      int testChargeAmount = 100;
      int testChargeRefundAmount = 90;
      String testChargeCurrency = 'usd';
      // application_fee can not be tested

      Customer customer = await new CustomerCreation().create();
      await (new CardCreation()
          ..number = testCardNumber
          ..expMonth = testCardExpMonth
          ..expYear = testCardExpYear
      ).create(customer.id);
      Charge charge = await (new ChargeCreation()
          ..amount = testChargeAmount
          ..currency = testChargeCurrency
          ..customer = customer.id
      ).create();
      charge = await Charge.refund(charge.id, amount: testChargeRefundAmount);
      expect(charge.refunds.data.first.amount, testChargeRefundAmount);

    });

    test('Capture a Charge', () async {

      // Card fields
      String testCardNumber = '4242424242424242';
      int testCardExpMonth = 12;
      int testCardExpYear = 2016;

      // Charge fields
      int testChargeAmount = 100;
      int testChargeCaptureAmount = 90;
      String testChargeCurrency = 'usd';
      // application_fee can not be tested

      Customer customer = await new CustomerCreation().create();
      await (new CardCreation()
          ..number = testCardNumber
          ..expMonth = testCardExpMonth
          ..expYear = testCardExpYear
      ).create(customer.id);
      Charge charge = await (new ChargeCreation()
          ..amount = testChargeAmount
          ..currency = testChargeCurrency
          ..customer = customer.id
          ..capture = false
      ).create();
      charge = await Charge.capture(charge.id, amount: testChargeCaptureAmount);
      expect(charge.captured, true);

    });

    test('List parameters charge', () async {

      String testCardNumber = '4242424242424242';
      int testCardExpMonth = 12;
      int testCardExpYear = 2016;

      Customer customer = await new CustomerCreation().create();
      await (new CardCreation()
          ..number = testCardNumber
          ..expMonth = testCardExpMonth
          ..expYear = testCardExpYear
      ).create(customer.id);
      for (var i = 0; i < 20; i++) {
        // Charge fields
        int testChargeAmount = 100;
        String testChargeCurrency = 'usd';
        // application_fee can not be tested

        await (new ChargeCreation()
            ..amount = testChargeAmount
            ..currency = testChargeCurrency
            ..customer = customer.id
            ..capture = false
        ).create();
      }
      ChargeCollection charges = await Charge.list(customer: customer.id, limit: 10);
      expect(charges.data.length, equals(10));
      expect(charges.hasMore, equals(true));
      charges = await Charge.list(customer: customer.id, limit: 10, startingAfter: charges.data.last.id);
      expect(charges.data.length, equals(10));
      expect(charges.hasMore, equals(false));
      charges = await Charge.list(customer: customer.id, limit: 10, endingBefore: charges.data.first.id);
      expect(charges.data.length, equals(10));
      expect(charges.hasMore, equals(false));

    });

  });

}