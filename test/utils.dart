library test_utils;

import "../lib/stripe.dart";

setApiKeyFromArgs(List<String> args) {
  for (String arg in args) {
    print(arg);
  }
  StripeService.apiKey = args.first;
}