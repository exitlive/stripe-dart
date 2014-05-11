library customer_tests;

import "dart:convert";

import 'package:unittest/unittest.dart';

import '../../lib/stripe.dart';
import '../utils.dart' as utils;

import "dart:async";

var exampleObject = """
                    {
                      "object": "customer",
                      "created": 1390621405,
                      "id": "cus_3N7bW2v8TfGKvk",
                      "livemode": false,
                      "description": "Random description",
                      "email": "test@example.com",
                      "delinquent": false,
                      "metadata": {
                        "test": "yeah"
                      },
                      "subscription": null,
                      "discount": null,
                      "account_balance": 0,
                      "currency": "usd",
                      "cards": {
                        "object": "list",
                        "count": 0,
                        "url": "/v1/customers/cus_3N7bW2v8TfGKvk/cards",
                        "data": [
                    
                        ]
                      },
                      "default_card": null
                    }""";


main(List<String> args) {

  utils.setApiKeyFromArgs(args);

  group('Customer', () {

    setUp(() {
      return utils.setUp();
    });

    tearDown(() {
      return utils.tearDown();
    });

    test("fromMap() properly popullates all values", () {
      var map = JSON.decode(exampleObject);

      var customer = new Customer.fromMap(map);

      expect(customer.created, equals(new DateTime.fromMillisecondsSinceEpoch(map["created"] * 1000)));
      expect(customer.id, equals(map["id"]));
      expect(customer.livemode, equals(map["livemode"]));
      expect(customer.description, equals(map["description"]));
      expect(customer.email, equals(map["email"]));
      expect(customer.delinquent, equals(map["delinquent"]));
      expect(customer.metadata, equals(map["metadata"]));
      expect(customer.subscription, equals(map["subscription"]));
      expect(customer.discount, equals(map["discount"]));
      expect(customer.accountBalance, equals(map["account_balance"]));
      expect(customer.currency, equals(map["currency"]));
      expect(customer.cards, new isInstanceOf<CustomerCardCollection>());
      expect(customer.cards.count, map["cards"]["count"]);
      expect(customer.cards.url, map["cards"]["url"]);
      expect(customer.defaultCard, equals(map["default_card"]));
    });

    test("CustomerCreation minimal", () {
      Customer testCustomer;
      Future future = new CustomerCreation().create();
      future.then((Customer customer) {
        testCustomer = customer;
        expect(customer.id, new isInstanceOf<String>());
      })
      .then((_) {
        return Customer.all().then((CustomerCollection customers) {
          expect(customers.data.length, 1);
          expect(customers.data.first.id, testCustomer.id);
        });
      });
      expect(future, completes);
    });

    test("CustomerCreation all", () {
      // Customer fields
      Customer testCustomer;
      int testAccountBalance = 100001;
      String testDescription = "test description";

      // Card fields
      String testNumber = "4242424242424242";
      int testExpMonth = 12;
      int testExpYear = 2015;
      String testName = "Mike Rotch";
      String testAddressLine1 = "Addresslinestreet 12/42A";
      String testAddressLine2 = "additional address line";
      String testAddressCity = "Laguna Beach";
      String testAddressZip = "92651";
      String testAddressCountry = "USA";


      CardCreation testCard = new CardCreation()
          ..number = testNumber
          ..expMonth = testExpMonth
          ..expYear = testExpYear
          ..cvc = 123 // this value can not be tested
          ..name = testName
          ..addressLine1 = testAddressLine1
          ..addressLine2 = testAddressLine2
          ..addressCity = testAddressCity
          ..addressZip = testAddressZip
          ..addressCountry = testAddressCountry;


      Future future = (
        new CustomerCreation()
            ..description = testDescription
            ..accountBalance = testAccountBalance
            ..card = testCard
      ).create();
      future.then((Customer customer) {
        testCustomer = customer;
        expect(customer.id, new isInstanceOf<String>());
        expect(customer.description, testDescription);
        expect(customer.accountBalance, testAccountBalance);
        expect(customer.cards.data.first.last4, testNumber.substring(testNumber.length - 4));
        expect(customer.cards.data.first.expMonth, testExpMonth);
        expect(customer.cards.data.first.expYear, testExpYear);
        expect(customer.cards.data.first.name, testName);
        expect(customer.cards.data.first.addressLine1, testAddressLine1);
        expect(customer.cards.data.first.addressLine2, testAddressLine2);
        expect(customer.cards.data.first.addressCity, testAddressCity);
        expect(customer.cards.data.first.addressZip, testAddressZip);
        expect(customer.cards.data.first.addressCountry, testAddressCountry);
        expect(customer.cards.data.first.addressLine1Check, "pass");
        expect(customer.cards.data.first.addressZipCheck, "pass");
        expect(customer.cards.data.first.cvcCheck, "pass");

      })
      .then((_) {
        return Customer.all().then((CustomerCollection customers) {
          expect(customers.data.length, 1);
          expect(customers.data.first.id, testCustomer.id);
        });
      });
      expect(future, completes);
    });

  });

}