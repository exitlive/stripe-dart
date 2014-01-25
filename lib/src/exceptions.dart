part of stripe;

class InvalidDataReceived implements Exception {
  String errorMessage;
  InvalidDataReceived(this.errorMessage);

  String toString() => "Invalid data received: #{errorMessage}.";
}