# Stripe Dart

[![Build Status](https://drone.io/github.com/exitlive/stripe-dart/status.png)](https://drone.io/github.com/exitlive/stripe-dart/latest)


Stripe API (version 2014-12-22) implemented in dart.

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

The majority of the tests rely on connecting to a real Stripe Account in
testmode.
Therefore all tests expect your API **Test** Secret Key as the first script
argument and your account must be set to **US**. Testcoverage is limited (some
tests would require livemode and or OAuth).


## License

Copyright (c) 2014 Matias Meno (m@tias.me), Martin Flucka (martin.flucka@gmail.com)

The MIT License

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

