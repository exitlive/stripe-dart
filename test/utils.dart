library test_utils;

import "dart:async";

import "../lib/stripe.dart";


setApiKeyFromArgs(List<String> args) {
  StripeService.apiKey = args.first;
}

Future setUp() {
  print("Test Setup");
  return new Future.value();
}

Future tearDown() {
  print("Test Teardown");
  return Customer.all()
  .then((CustomerCollection customers) {

    for (Customer customer in customers.data) {
      Customer.delete(customer.id).then((_) => print("Delete customer: ${customer.id}"));
    }
  });
}