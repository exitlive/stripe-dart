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
      expect(charge.id, map['id']);
      expect(charge.created, new DateTime.fromMillisecondsSinceEpoch(map['created'] * 1000));
      expect(charge.livemode, map['livemode']);
      expect(charge.paid, map['paid']);
      expect(charge.amount, map['amount']);
      expect(charge.currency, map['currency']);
      expect(charge.refunded, map['refunded']);
      expect(charge.customer, map['customer']);
      expect(charge.card, new isInstanceOf<Card>());
      expect(charge.card.id, new Card.fromMap(map['card']).id);
      expect(charge.description, map['description']);
      expect(charge.metadata, map['metadata']);
      expect(charge.statement_descriptor, map['statement_descriptor']);
      expect(charge.captured, map['captured']);
      expect(charge.failureMessage, map['failureMessage']);
      expect(charge.failureCode, map['failureCode']);
      expect(charge.amountRefunded, map['amountRefunded']);
      expect(charge.refunds.data.length, map['refunds']['data'].length);
      expect(charge.dispute, map['dispute']);
      expect(charge.balanceTransaction, map['balance_transaction']);

    });

  });

  group('Charge online', () {

    tearDown(() {
      return utils.tearDown();
    });

    test('ChargeCreation minimal', () async {

      // Card fields
      String cardNumber = '4242424242424242';
      int cardExpMonth = 12;
      int cardExpYear = 2016;
      // Charge fields
      int chargeAmount = 100;
      String chargeCurrency = 'usd';
      Customer customer = await new CustomerCreation().create();
      await (new CardCreation()
          ..number = cardNumber
          ..expMonth = cardExpMonth
          ..expYear = cardExpYear
      ).create(customer.id);
      Charge charge = await (new ChargeCreation()
          ..amount = chargeAmount
          ..currency = chargeCurrency
          ..customer = customer.id
      ).create();
      expect(charge.amount, chargeAmount);
      expect(charge.currency, chargeCurrency);

    });

    test('ChargeCreation full', () async {

      // Card fields
      String cardNumber = '4242424242424242';
      int cardExpMonth = 12;
      int cardExpYear = 2016;

      // Charge fields
      int chargeAmount = 100;
      String chargeCurrency = 'usd';
      String chargeDescription1 = 'test description1';
      String chargeDescription2 = 'test description2';
      Map chargeMetadata1 = {'foo': 'bar1'};
      Map chargeMetadata2 = {'foo': 'bar2'};
      bool chargeCapture = false;
      String chargeStatementDescriptor = 'test descriptor';
      // application_fee can not be tested

      Customer customer = await new CustomerCreation().create();
      await (new CardCreation()
          ..number = cardNumber
          ..expMonth = cardExpMonth
          ..expYear = cardExpYear
      ).create(customer.id);
      Charge charge = await (new ChargeCreation()
          ..amount = chargeAmount
          ..currency = chargeCurrency
          ..customer = customer.id
          ..description = chargeDescription1
          ..metadata = chargeMetadata1
          ..capture = chargeCapture
          ..statementDescriptor = chargeStatementDescriptor
      ).create();
      expect(charge.amount, chargeAmount);
      expect(charge.currency, chargeCurrency);
      expect(charge.description, chargeDescription1);
      expect(charge.metadata, chargeMetadata1);
      expect(charge.captured, chargeCapture);
      expect(charge.statement_descriptor, chargeStatementDescriptor);
      // testing the expand functionality of retrieve
      charge = await Charge.retrieve(charge.id, data: {'expand': ['balance_transaction', 'customer', 'invoice']});
      expect(charge.customer, charge.customerExpand.id);

      // testing the ChargeUpdate
      charge = await (new ChargeUpdate()
          ..description = chargeDescription2
          ..metadata = chargeMetadata2
      ).update(charge.id);
      expect(charge.description, chargeDescription2);
      expect(charge.metadata, chargeMetadata2);

    });

    test('Refund a Charge', () async {

      // Card fields
      String cardNumber = '4242424242424242';
      int cardExpMonth = 12;
      int cardExpYear = 2016;

      // Charge fields
      int chargeAmount = 100;
      int chargeRefundAmount = 90;
      String chargeCurrency = 'usd';
      // application_fee can not be tested

      Customer customer = await new CustomerCreation().create();
      await (new CardCreation()
          ..number = cardNumber
          ..expMonth = cardExpMonth
          ..expYear = cardExpYear
      ).create(customer.id);
      Charge charge = await (new ChargeCreation()
          ..amount = chargeAmount
          ..currency = chargeCurrency
          ..customer = customer.id
      ).create();
      charge = await Charge.refund(charge.id, amount: chargeRefundAmount);
      expect(charge.refunds.data.first.amount, chargeRefundAmount);

    });

    test('Capture a Charge', () async {

      // Card fields
      String cardNumber = '4242424242424242';
      int cardExpMonth = 12;
      int cardExpYear = 2016;

      // Charge fields
      int chargeAmount = 100;
      int chargeCaptureAmount = 90;
      String chargeCurrency = 'usd';
      // application_fee can not be tested

      Customer customer = await new CustomerCreation().create();
      await (new CardCreation()
          ..number = cardNumber
          ..expMonth = cardExpMonth
          ..expYear = cardExpYear
      ).create(customer.id);
      Charge charge = await (new ChargeCreation()
          ..amount = chargeAmount
          ..currency = chargeCurrency
          ..customer = customer.id
          ..capture = false
      ).create();
      charge = await Charge.capture(charge.id, amount: chargeCaptureAmount);
      expect(charge.captured, isTrue);

    });

    test('List parameters charge', () async {

      String cardNumber = '4242424242424242';
      int cardExpMonth = 12;
      int cardExpYear = 2016;

      Customer customer = await new CustomerCreation().create();
      await (new CardCreation()
          ..number = cardNumber
          ..expMonth = cardExpMonth
          ..expYear = cardExpYear
      ).create(customer.id);
      for (var i = 0; i < 20; i++) {
        // Charge fields
        int chargeAmount = 100;
        String chargeCurrency = 'usd';
        // application_fee can not be tested

        await (new ChargeCreation()
            ..amount = chargeAmount
            ..currency = chargeCurrency
            ..customer = customer.id
            ..capture = false
        ).create();
      }
      ChargeCollection charges = await Charge.list(customer: customer.id, limit: 10);
      expect(charges.data.length, 10);
      expect(charges.hasMore, isTrue);
      charges = await Charge.list(customer: customer.id, limit: 10, startingAfter: charges.data.last.id);
      expect(charges.data.length, 10);
      expect(charges.hasMore, isFalse);
      charges = await Charge.list(customer: customer.id, limit: 10, endingBefore: charges.data.first.id);
      expect(charges.data.length, 10);
      expect(charges.hasMore, isFalse);

    });

  });

}