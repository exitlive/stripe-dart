# Stripe Dart

> This library is not finished yet. **Do not use.**  
> It will be ready to go in a few weeks.

Stripe API implemented in dart.

Most of the model class documentations have been taken from the
[stripe documentation](https://stripe.com/docs).

This implementation is based on the official Stripe Java and NodeJS API wrappers
and written as a proper native dart library.


## Usage

```dart
import "stripe" as stripe;

stripe.Customer.create({ "email": "customer@example.com" })
  .then((Customer customer) => print(customer))
  .catchError((e) => handleError(e));
``` 