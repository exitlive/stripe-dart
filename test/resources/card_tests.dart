library card_tests;

import "dart:convert";
import "dart:async";

import 'package:unittest/unittest.dart';

import '../../lib/stripe.dart';
import '../utils.dart' as utils;

var exampleObject = """
                    {
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
                    }""";


main(List<String> args) {

  utils.setApiKeyFromArgs(args);

  group('Card', () {

    setUp(() {
      return utils.setUp();
    });

    tearDown(() {
      return utils.tearDown();
    });

    test("fromMap() properly popullates all values", () {
      var map = JSON.decode(exampleObject);

      var card = new Card.fromMap(map);

      expect(card.id, equals(map["id"]));
      expect(card.last4, equals(map["last4"]));
      expect(card.type, equals(map["type"]));
      expect(card.expMonth, equals(map["exp_month"]));
      expect(card.expYear, equals(map["exp_year"]));
      expect(card.fingerprint, equals(map["fingerprint"]));
      expect(card.customer, equals(map["customer"]));
      expect(card.addressLine1, equals(map["address_line1"]));
      expect(card.addressLine2, equals(map["address_line2"]));
      expect(card.addressCity, equals(map["address_city"]));
      expect(card.addressState, equals(map["address_state"]));
      expect(card.addressZip, equals(map["address_zip"]));
      expect(card.addressCountry, equals(map["address_country"]));
      expect(card.cvcCheck, equals(map["cvc_check"]));
      expect(card.addressLine1Check, equals(map["address_line1_check"]));
      expect(card.addressZipCheck, equals(map["address_zip_check"]));

    });

    test("CardCreation minimal", () {

      Customer testCustomer;
      Card testCard;
      String number = "4242424242424242";
      int expMonth = 12;
      int expYear = 2014;
      Future future = new CustomerCreation().create();
      future.then((Customer customer) {
        testCustomer = customer;
        expect(customer.id, new isInstanceOf<String>());
      })
      .then((_) {
        return (
            new CardCreation()
                    ..number = number
                    ..expMonth = expMonth
                    ..expYear = expYear
            ).create(testCustomer.id);
      })
      .then((Card card) {
        testCard = card;
        expect(card.id, new isInstanceOf<String>());
        expect(card.last4, equals(number.substring(number.length - 4)));
        expect(card.expMonth, equals(expMonth));
        expect(card.expYear, equals(expYear));

      });
      expect(future, completes);
    });


  });

}