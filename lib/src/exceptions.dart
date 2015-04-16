part of stripe;

class InvalidDataReceivedException implements Exception {
  final String errorMessage;

  InvalidDataReceivedException(this.errorMessage);

  String toString() => 'Invalid data received: ${errorMessage}.';
}

/// Missing argument errors indicate that not all required arguments were set for
/// the request.
class MissingArgumentException implements Exception {
  final String errorMessage;

  MissingArgumentException(this.errorMessage);

  String toString() => 'Missing arguments for this request: ${errorMessage}.';
}

/// Exceptions thrown by Stripe
abstract class StripeApiException implements Exception {
  final String errorMessage;

  StripeApiException(this.errorMessage);
}

/// Invalid request errors arise when your request has invalid parameters.
class InvalidRequestErrorException extends StripeApiException {
  InvalidRequestErrorException(String errorMessage) : super(errorMessage);

  String toString() => 'Invalid request: ${errorMessage}.';
}

/// Card errors are the most common type of error you should expect to handle.
/// They result when the user enters a card that can't be charged for some reason.
class CardErrorException extends StripeApiException {

  /// A short string from amongst those listed on the right describing the kind
  /// of card error that occurred.
  final String code;

  /// The parameter the error relates to if the error is parameter-specific. You
  /// can use this to display a message near the correct form field, for example.
  final String param;

  CardErrorException(String errorMessage, this.code, this.param) : super(errorMessage);

  String toString() => 'Card error: ${errorMessage}.';
}

/// API errors cover any other type of problem (e.g. a temporary problem with
/// Stripe's servers) and should turn up only very infrequently.
class ApiErrorException extends StripeApiException {
  ApiErrorException(String errorMessage) : super(errorMessage);

  String toString() => 'Invalid request: ${errorMessage}.';
}

/// Invalid request errors arise when your request has invalid parameters.
class BadRequestException extends StripeApiException {
  BadRequestException(String errorMessage) : super(errorMessage);

  String toString() => 'Bad request: ${errorMessage}.';
}
