library card_tests;

import 'dart:async';
import 'dart:convert';

import 'package:unittest/unittest.dart';

import '../../lib/stripe.dart';
import '../utils.dart' as utils;


var exampleCard = """
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

  group('Card offline', () {

    test('fromMap() properly popullates all values', () {

      var map = JSON.decode(exampleCard);
      var card = new Card.fromMap(map);
      expect(card.id, equals(map['id']));
      expect(card.last4, equals(map['last4']));
      expect(card.type, equals(map['type']));
      expect(card.expMonth, equals(map['exp_month']));
      expect(card.expYear, equals(map['exp_year']));
      expect(card.fingerprint, equals(map['fingerprint']));
      expect(card.customer, equals(map['customer']));
      expect(card.addressLine1, equals(map['address_line1']));
      expect(card.addressLine2, equals(map['address_line2']));
      expect(card.addressCity, equals(map['address_city']));
      expect(card.addressState, equals(map['address_state']));
      expect(card.addressZip, equals(map['address_zip']));
      expect(card.addressCountry, equals(map['address_country']));
      expect(card.cvcCheck, equals(map['cvc_check']));
      expect(card.addressLine1Check, equals(map['address_line1_check']));
      expect(card.addressZipCheck, equals(map['address_zip_check']));

    });

  });

  group('Card online', () {

    setUp(() {
      return utils.setUp();
    });

    tearDown(() {
      return utils.tearDown();
    });

    test('CardCreation minimal', () async {

      String number = '4242424242424242';
      int expMonth = 12;
      int expYear = 2016;
      Customer customer = await new CustomerCreation().create();
      expect(customer.id, new isInstanceOf<String>());
      Card card = await (new CardCreation()
          ..number = number
          ..expMonth = expMonth
          ..expYear = expYear
      ).create(customer.id);
      expect(card.id, new isInstanceOf<String>());
      expect(card.last4, equals(number.substring(number.length - 4)));
      expect(card.expMonth, equals(expMonth));
      expect(card.expYear, equals(expYear));

    });

    test('CardCreation full', () async {

      String testCardNumber = '4242424242424242';
      int testCardExpMonth1 = 12;
      int testCardExpYear1 = 2016;
      int testCardCvc = 123;
      String testCardName1 = 'Anita Bath';
      String testCardAddressLine1A = 'Teststreet 2/39A';
      String testCardAddressLine2A = 'line 2';
      String testCardAddressCity1 = 'Vienna';
      String testCardAddressZip1 = '1050';
      String testCardAddressState1 = 'Vienna';
      String testCardAddressCountry1 = 'Austria';
      // for update tests
      String testCardAddressCity2 = 'Laguna Beach';
      String testCardAddressCountry2 = 'USA';
      String testCardAddressLine1B = 'Addresslinestreet 12/42A';
      String testCardAddressLine2B = 'additional address line';
      String testCardAddressState2 = 'California';
      String testCardAddressZip2 = '92651';
      int testCardExpMonth2 = 3;
      int testCardExpYear2 = 2016;
      String testCardName2 = 'Agatha Bath';
      Customer customer = await new CustomerCreation().create();
      expect(customer.id, new isInstanceOf<String>());
      Card card = await (new CardCreation()
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
      ).create(customer.id);
      expect(card.id, new isInstanceOf<String>());
      expect(card.last4, equals(testCardNumber.substring(testCardNumber.length - 4)));
      expect(card.expMonth, equals(testCardExpMonth1));
      expect(card.expYear, equals(testCardExpYear1));
      expect(card.cvcCheck, equals('pass'));
      expect(card.name, equals(testCardName1));
      expect(card.addressLine1, equals(testCardAddressLine1A));
      expect(card.addressLine1Check, equals('pass'));
      expect(card.addressLine2, equals(testCardAddressLine2A));
      expect(card.addressCity, equals(testCardAddressCity1));
      expect(card.addressZip, equals(testCardAddressZip1));
      expect(card.addressZipCheck, equals('pass'));
      expect(card.addressState, equals(testCardAddressState1));
      expect(card.addressCountry, equals(testCardAddressCountry1));
      // testing the expand functionality of retrieve
      card = await Card.retrieve(customer.id, card.id, data: {'expand': ['customer']});
      expect(card.customer, equals(customer.id));
      expect(card.customerExpand.id, equals(customer.id));
      // testing the CardUpdate
      card = await (new CardUpdate()
          ..addressCity = testCardAddressCity2
          ..addressCountry = testCardAddressCountry2
          ..addressLine1 = testCardAddressLine1B
          ..addressLine2 = testCardAddressLine2B
          ..addressState = testCardAddressState2
          ..addressZip = testCardAddressZip2
          ..expMonth = testCardExpMonth2
          ..expYear = testCardExpYear2
          ..name = testCardName2
      ).update(customer.id, card.id);
      expect(card.expMonth, equals(testCardExpMonth2));
      expect(card.expYear, equals(testCardExpYear2));
      expect(card.name, equals(testCardName2));
      expect(card.addressLine1, equals(testCardAddressLine1B));
      expect(card.addressLine1Check, equals('pass'));
      expect(card.addressLine2, equals(testCardAddressLine2B));
      expect(card.addressCity, equals(testCardAddressCity2));
      expect(card.addressZip, equals(testCardAddressZip2));
      expect(card.addressZipCheck, equals('pass'));
      expect(card.addressState, equals(testCardAddressState2));
      expect(card.addressCountry, equals(testCardAddressCountry2));

    });

    test('Delete card', () async {

      String number = '4242424242424242';
      int expMonth = 12;
      int expYear = 2016;
      Customer customer = await new CustomerCreation().create();
      expect(customer.id, new isInstanceOf<String>());
      Card card = await (new CardCreation()
          ..number = number
          ..expMonth = expMonth
          ..expYear = expYear
      ).create(customer.id);
      Map response = await Card.delete(customer.id, card.id);
      expect(response['deleted'], isTrue);
      expect(response['id'], equals(card.id));

    });

    test('List parameters card', () async {

      String number = '4242424242424242';
      int expMonth = 12;
      int expYear = 2016;
      Customer customer = await new CustomerCreation().create();
      List<Future> queue = [];
      for (var i = 0; i < 20; i++) {
        await (new CardCreation()
            ..number = number
            ..expMonth = expMonth
            ..expYear = expYear
        ).create(customer.id);
      }
      CardCollection cards = await Card.list(customer.id, limit: 10);
      expect(cards.data.length, equals(10));
      expect(cards.hasMore, equals(true));
      cards = await Card.list(customer.id, limit: 10, startingAfter: cards.data.last.id);
      expect(cards.data.length, equals(10));
      expect(cards.hasMore, equals(false));
      cards = await Card.list(customer.id, limit: 10, endingBefore: cards.data.first.id);
      expect(cards.data.length, equals(10));
      expect(cards.hasMore, equals(false));

    });

  });

}