library charge_tests;

import "dart:convert";

import 'package:unittest/unittest.dart';

import '../../lib/stripe.dart';
import '../utils.dart' as utils;

var exampleObject = """
                    {
                      "id": "ch_103yOK2eZvKYlo2CnLNI8KAl",
                      "object": "charge",
                      "created": 1399217337,
                      "livemode": false,
                      "paid": true,
                      "amount": 500,
                      "currency": "usd",
                      "refunded": false,
                      "card": {
                        "id": "card_103yOK2eZvKYlo2CNWdHfG5K",
                        "object": "card",
                        "last4": "4242",
                        "type": "Visa",
                        "exp_month": 1,
                        "exp_year": 2050,
                        "fingerprint": "Xt5EWLLDS7FJjR1c",
                        "customer": null,
                        "country": "US",
                        "name": null,
                        "address_line1": null,
                        "address_line2": null,
                        "address_city": null,
                        "address_state": null,
                        "address_zip": null,
                        "address_country": null,
                        "cvc_check": "pass",
                        "address_line1_check": null,
                        "address_zip_check": null
                      },
                      "captured": true,
                      "refunds": [
                    
                      ],
                      "balance_transaction": "txn_103vub2eZvKYlo2Csszorw8e",
                      "failure_message": null,
                      "failure_code": null,
                      "amount_refunded": 0,
                      "customer": null,
                      "invoice": null,
                      "description": null,
                      "dispute": null,
                      "metadata": {
                      },
                      "statement_description": null
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
      expect(charge.disputed, equals(map["disputed"]));
      expect(charge.captured, equals(map["captured"]));
      expect(charge.failureMessage, equals(map["failureMessage"]));
      expect(charge.failureCode, equals(map["failureCode"]));
      expect(charge.amountRefunded, equals(map["amountRefunded"]));
      expect(charge.refunds.length, equals(map["refunds"].length));
      expect(charge.dispute, equals(map["dispute"]));
      expect(charge.balanceTransaction, equals(map["balanceTransaction"]));

    });
  });

}