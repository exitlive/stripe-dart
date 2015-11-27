library charge_tests;

import 'dart:convert';

import 'package:unittest/unittest.dart';

import '../../lib/stripe.dart';
import '../utils.dart' as utils;

import 'balance_transaction_tests.dart' as balance_transaction;
import 'card_tests.dart' as card;
import 'customer_tests.dart' as customer;
import 'dispute_tests.dart' as dispute;
import 'refund_tests.dart' as refund;
import 'invoice_tests.dart' as invoice;
import '../resources/shipping_tests.dart' as shipping;

var example = '''
    {
      "id": "ch_15tbwd41dfVNZFcq48lWk5V2",
      "object": "charge",
      "livemode": false,
      "amount": 100,
      "captured": true,
      "created": 1429524963,
      "currency": "usd",
      "paid": true,
      "refunded": false,
      "refunds": ${refund.collectionExample},
      "source": ${card.example},
      "status": "succeeded",
      "amount_refunded": 0,
      "balance_transaction": ${balance_transaction.example},
      "customer": ${customer.example},
      "description": "description",
      "dispute": ${dispute.example},
      "failure_code": "failure_code",
      "failure_message": "failure_message",      
      "invoice": ${invoice.example},      
      "metadata": ${utils.metadataExample},
      "receipt_email": "test@test.com",
      "receipt_number": "receipt_number",
      "application_fee": "application_fee",
      "destination": "destination",
      "fraud_details": {"user_report": "safe"},
      "shipping": ${shipping.example},
      "statement_descriptor": "statement_descriptor"
    }''';

main(List<String> args) {
  utils.setApiKeyFromArgs(args);

  group('Charge offline', () {
    test('fromMap() properly popullates all values', () {
      var map = JSON.decode(example);
      var charge = new Charge.fromMap(map);
      expect(charge.id, map['id']);
      expect(charge.livemode, map['livemode']);
      expect(charge.amount, map['amount']);
      expect(charge.captured, map['captured']);
      expect(charge.created, new DateTime.fromMillisecondsSinceEpoch(map['created'] * 1000));
      expect(charge.currency, map['currency']);
      expect(charge.paid, map['paid']);
      expect(charge.refunded, map['refunded']);
      expect(charge.refunds.toMap(), new RefundCollection.fromMap(map['refunds']).toMap());
      expect(charge.source.toMap(), new Card.fromMap(map['source']).toMap());
      expect(charge.status, map['status']);
      expect(charge.amountRefunded, map['amountRefunded']);
      expect(
          charge.balanceTransactionExpand.toMap(), new BalanceTransaction.fromMap(map['balance_transaction']).toMap());
      expect(charge.customerExpand.toMap(), new Customer.fromMap(map['customer']).toMap());
      expect(charge.description, map['description']);
      expect(charge.dispute.toMap(), new Dispute.fromMap(map['dispute']).toMap());
      expect(charge.failureCode, map['failureCode']);
      expect(charge.failureMessage, map['failureMessage']);
      expect(charge.invoiceExpand.toMap(), new Invoice.fromMap(map['invoice']).toMap());
      expect(charge.metadata, map['metadata']);
      expect(charge.receiptEmail, map['receipt_email']);
      expect(charge.receiptNumber, map['receipt_number']);
      expect(charge.applicationFee, map['application_fee']);
      expect(charge.destination, map['destination']);
      expect(charge.fraudDetails, map['fraud_details']);
      expect(charge.shipping.toMap(), new Shipping.fromMap(map['shipping']).toMap());
      expect(charge.statement_descriptor, map['statement_descriptor']);
    });
  });

  group('Charge online', () {
    tearDown(() {
      return utils.tearDown();
    });

    test('Create minimal', () async {
      // Card fields
      var cardNumber = '4242424242424242',
          cardExpMonth = 12,
          cardExpYear = 2016,

          // Charge fields
          chargeAmount = 100,
          chargeCurrency = 'usd';

      var customer = await new CustomerCreation().create();
      await (new CardCreation()
        ..number = cardNumber
        ..expMonth = cardExpMonth
        ..expYear = cardExpYear).create(customer.id);
      var charge = await (new ChargeCreation()
        ..amount = chargeAmount
        ..currency = chargeCurrency
        ..customer = customer.id).create();
      expect(charge.amount, chargeAmount);
      expect(charge.currency, chargeCurrency);
    });

    test('Create full', () async {
      // Card fields
      var cardNumber = '4242424242424242',
          cardExpMonth = 12,
          cardExpYear = 2016,

          // Charge fields
          chargeAmount = 100,
          chargeCurrency = 'usd',
          chargeDescription1 = 'test description1',
          chargeDescription2 = 'test description2',
          chargeMetadata1 = {'foo': 'bar1'},
          chargeMetadata2 = {'foo': 'bar2'},
          chargeCapture = false,
          chargeStatementDescriptor = 'test descriptor';
      // application_fee can not be tested

      var customer = await new CustomerCreation().create();
      await (new CardCreation()
        ..number = cardNumber
        ..expMonth = cardExpMonth
        ..expYear = cardExpYear).create(customer.id);
      var charge = await (new ChargeCreation()
        ..amount = chargeAmount
        ..currency = chargeCurrency
        ..customer = customer.id
        ..description = chargeDescription1
        ..metadata = chargeMetadata1
        ..capture = chargeCapture
        ..statementDescriptor = chargeStatementDescriptor).create();
      expect(charge.amount, chargeAmount);
      expect(charge.currency, chargeCurrency);
      expect(charge.description, chargeDescription1);
      expect(charge.metadata, chargeMetadata1);
      expect(charge.captured, chargeCapture);
      expect(charge.statement_descriptor, chargeStatementDescriptor);
      // testing the expand functionality of retrieve
      charge = await Charge.retrieve(charge.id, data: {
        'expand': ['balance_transaction', 'customer', 'invoice']
      });
      expect(charge.customer, charge.customerExpand.id);

      // testing the ChargeUpdate
      charge = await (new ChargeUpdate()
        ..description = chargeDescription2
        ..metadata = chargeMetadata2).update(charge.id);
      expect(charge.description, chargeDescription2);
      expect(charge.metadata, chargeMetadata2);
    });

    test('Capture', () async {
      // Card fields
      var cardNumber = '4242424242424242',
          cardExpMonth = 12,
          cardExpYear = 2016,

          // Charge fields
          chargeAmount = 100,
          chargeCaptureAmount = 90,
          chargeCurrency = 'usd';
      // application_fee can not be tested

      var customer = await new CustomerCreation().create();
      await (new CardCreation()
        ..number = cardNumber
        ..expMonth = cardExpMonth
        ..expYear = cardExpYear).create(customer.id);
      var charge = await (new ChargeCreation()
        ..amount = chargeAmount
        ..currency = chargeCurrency
        ..customer = customer.id
        ..capture = false).create();
      charge = await Charge.capture(charge.id, amount: chargeCaptureAmount);
      expect(charge.captured, isTrue);
    });

    test('List parameters', () async {
      var cardNumber = '4242424242424242', cardExpMonth = 12, cardExpYear = 2016;

      var customer = await new CustomerCreation().create();
      await (new CardCreation()
        ..number = cardNumber
        ..expMonth = cardExpMonth
        ..expYear = cardExpYear).create(customer.id);
      for (var i = 0; i < 20; i++) {
        // Charge fields
        var chargeAmount = 100, chargeCurrency = 'usd';
        // application_fee can not be tested

        await (new ChargeCreation()
          ..amount = chargeAmount
          ..currency = chargeCurrency
          ..customer = customer.id
          ..capture = false).create();
      }
      var charges = await Charge.list(customer: customer.id, limit: 10);
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
