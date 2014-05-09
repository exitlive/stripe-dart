library test_utils;

import "dart:async";
import "dart:io";

import "../lib/stripe.dart";


setApiKeyFromArgs(List<String> args) {
  if (args.length < 1) {
    print("Error. Most tests can not execute without a Stripe API key.");
    print("Provide your stripe API key as the first command line argument!");
    exit(2);
  }
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
      List<Future> processQueue = [];
      for (Customer customer in customers.data) {
        processQueue.add(Customer.delete(customer.id).then((_) => print("Delete customer: ${customer.id}")));
      }
      return processQueue;
    }).then((List<Future> futures) {
      return Future.wait(futures);
    });
}