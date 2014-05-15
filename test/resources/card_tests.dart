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
      new CustomerCreation().create()
        .then((Customer customer) {
          testCustomer = customer;
          expect(customer.id, new isInstanceOf<String>());
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
        })
        .then(expectAsync((_) => true));

    });

    test("CardCreation full", () {

      Customer testCustomer;
      Card testCard;
      String testCardNumber = "4242424242424242";
      int testCardExpMonth1 = 12;
      int testCardExpYear1 = 2014;
      int testCardCvc = 123;
      String testCardName1 = "Anita Bath";
      String testCardAddressLine1A = "Teststreet 2/39A";
      String testCardAddressLine2A = "line 2";
      String testCardAddressCity1 = "Vienna";
      String testCardAddressZip1 = "1050";
      String testCardAddressState1 = "Vienna";
      String testCardAddressCountry1 = "Austria";
      // for update tests
      String testCardAddressCity2 = "Laguna Beach";
      String testCardAddressCountry2 = "USA";
      String testCardAddressLine1B = "Addresslinestreet 12/42A";
      String testCardAddressLine2B = "additional address line";
      String testCardAddressState2 = "California";
      String testCardAddressZip2 = "92651";
      int testCardExpMonth2 = 3;
      int testCardExpYear2 = 2015;
      String testCardName2 = "Agatha Bath";

      new CustomerCreation().create()
        .then((Customer customer) {
          testCustomer = customer;
          expect(customer.id, new isInstanceOf<String>());
          return (
            new CardCreation()
                ..number = testCardNumber
                ..expMonth = testCardExpMonth1
                ..expYear = testCardExpYear1
                ..cvc = testCardCvc
                ..name = testCardName1
                ..addressLine1 = testCardAddressLine1A
                ..addressLine2 = testCardAddressLine2A
                ..addressCity = testCardAddressCity1
                ..addressZip = testCardAddressZip1
                ..addressState = testCardAddressState1
                ..addressCountry = testCardAddressCountry1
            ).create(testCustomer.id);
        })
        .then((Card card) {
          testCard = card;
          expect(card.id, new isInstanceOf<String>());
          expect(card.last4, equals(testCardNumber.substring(testCardNumber.length - 4)));
          expect(card.expMonth, equals(testCardExpMonth1));
          expect(card.expYear, equals(testCardExpYear1));
          expect(card.cvcCheck, equals("pass"));
          expect(card.name, equals(testCardName1));
          expect(card.addressLine1, equals(testCardAddressLine1A));
          expect(card.addressLine1Check, equals("pass"));
          expect(card.addressLine2, equals(testCardAddressLine2A));
          expect(card.addressCity, equals(testCardAddressCity1));
          expect(card.addressZip, equals(testCardAddressZip1));
          expect(card.addressZipCheck, equals("pass"));
          expect(card.addressState, equals(testCardAddressState1));
          expect(card.addressCountry, equals(testCardAddressCountry1));
          // testing the expand functionality of retrieve
          return Card.retrieve(testCustomer.id, card.id, data: {"expand": ["customer"]});
        })
        .then((Card card) {
          expect(card.customer, equals(testCustomer.id));
          expect(card.customerExpand.id, equals(testCustomer.id));
          return (new CardUpdate()
              ..addressCity = testCardAddressCity2
              ..addressCountry = testCardAddressCountry2
              ..addressLine1 = testCardAddressLine1B
              ..addressLine2 = testCardAddressLine2B
              ..addressState = testCardAddressState2
              ..addressZip = testCardAddressZip2
              ..expMonth = testCardExpMonth2
              ..expYear = testCardExpYear2
              ..name = testCardName2

          ).update(testCustomer.id, testCard.id);
        })
        .then((Card card) {
          expect(card.expMonth, equals(testCardExpMonth2));
          expect(card.expYear, equals(testCardExpYear2));
          expect(card.name, equals(testCardName2));
          expect(card.addressLine1, equals(testCardAddressLine1B));
          expect(card.addressLine1Check, equals("pass"));
          expect(card.addressLine2, equals(testCardAddressLine2B));
          expect(card.addressCity, equals(testCardAddressCity2));
          expect(card.addressZip, equals(testCardAddressZip2));
          expect(card.addressZipCheck, equals("pass"));
          expect(card.addressState, equals(testCardAddressState2));
          expect(card.addressCountry, equals(testCardAddressCountry2));
        })
        .then(expectAsync((_) => true));

    });


  });

}