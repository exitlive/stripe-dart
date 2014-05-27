# Stripe Dart

[![Build Status](https://drone.io/github.com/enyo/stripe-dart/status.png)](https://drone.io/github.com/enyo/stripe-dart/latest)


Stripe API implemented in dart.

Most of the model class documentations have been taken from the
[stripe documentation](https://stripe.com/docs).

This implementation is based on the official Stripe Java and NodeJS API wrappers
and written as a proper native dart library.


## Usage

```dart
import "package:stripe/stripe.dart";

main() {

  StripeService.apiKey = "sk_test_BQokikJOvBiI2HlWgH4olfQ2";

  var card = new CardCreation()
      ..number = "123123123";

  new CustomerCreation()
      ..description = "Customer for test@example.com"
      ..card = card
      ..create()
      .then((Customer customer) => print(customer))
      .catchError((e) => handleError(e));

}
```

## Tests

The majority of the tests rely on connecting to a real Stripe Account in testmode.
Therefore all tests expect your API Test Secret Key as the first script argument.
Testcoverage is limited (some tests would require livemode and or OAuth)