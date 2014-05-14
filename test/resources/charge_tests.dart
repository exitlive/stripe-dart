library charge_tests;

import "dart:convert";

import 'package:unittest/unittest.dart';

import '../../lib/stripe.dart';
import '../utils.dart' as utils;

var exampleObject = """
                    {
                      "id": "ch_1041NW41dfVNZFcqslnvTHtc",
                      "object": "charge",
                      "created": 1399906241,
                      "livemode": false,
                      "paid": true,
                      "amount": 100991,
                      "currency": "usd",
                      "refunded": false,
                      "card": {
                        "id": "card_1041NW41dfVNZFcqYa3VUHqf",
                        "object": "card",
                        "last4": "4242",
                        "type": "Visa",
                        "exp_month": 12,
                        "exp_year": 2015,
                        "fingerprint": "2OcV4uXscDkio6R5",
                        "customer": "cus_41NWbNsIkcUEee",
                        "country": "US",
                        "name": "Mike Rotch",
                        "address_line1": "Addresslinestreet 12/42A",
                        "address_line2": "additional address line",
                        "address_city": "Laguna Beach",
                        "address_state": null,
                        "address_zip": "92651",
                        "address_country": "USA",
                        "cvc_check": "pass",
                        "address_line1_check": "pass",
                        "address_zip_check": "pass"
                      },
                      "captured": true,
                      "refunds": [
                    
                      ],
                      "balance_transaction": "txn_1041NT41dfVNZFcqhWETcQzJ",
                      "failure_message": null,
                      "failure_code": null,
                      "amount_refunded": 0,
                      "customer": "cus_41NWbNsIkcUEee",
                      "invoice": "in_1041NW41dfVNZFcqeK3pYfSi",
                      "description": null,
                      "dispute": null,
                      "metadata": {
                      },
                      "statement_description": "statement descr"
                    }""";


main(List<String> args) {

  utils.setApiKeyFromArgs(args);

  group('Charge', () {

    setUp(() {
      return utils.setUp();
    });

    tearDown(() {
      return utils.tearDown();
    });

    test("fromMap() properly popullates all values", () {
      var map = JSON.decode(exampleObject);

      var charge = new Charge.fromMap(map);

      expect(charge.id, equals(map["id"]));
      expect(charge.created, equals(new DateTime.fromMillisecondsSinceEpoch(map["created"] * 1000)));
      expect(charge.livemode, equals(map["livemode"]));
      expect(charge.paid, equals(map["paid"]));
      expect(charge.amount, equals(map["amount"]));
      expect(charge.currency, equals(map["currency"]));
      expect(charge.refunded, equals(map["refunded"]));
      expect(charge.customer, equals(map["customer"]));
      expect(charge.card, new isInstanceOf<Card>());
      expect(charge.card.id, new Card.fromMap(map["card"]).id);
      expect(charge.description, equals(map["description"]));
      expect(charge.metadata, equals(map["metadata"]));
      expect(charge.statement_description, equals(map["statement_description"]));
      expect(charge.captured, equals(map["captured"]));
      expect(charge.failureMessage, equals(map["failureMessage"]));
      expect(charge.failureCode, equals(map["failureCode"]));
      expect(charge.amountRefunded, equals(map["amountRefunded"]));
      expect(charge.refunds.length, equals(map["refunds"].length));
      expect(charge.dispute, equals(map["dispute"]));
      expect(charge.balanceTransaction, equals(map["balance_transaction"]));

    });
  });

}