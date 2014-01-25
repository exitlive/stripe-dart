part of stripe;

/**
 * Refunds can't be created by the library.
 *
 * If you want to create a refund, use [Charge.refund].
 */
class Refund extends Resource {

  int amount;

  String currency;

  int created;

  String balanceTransaction;


  Refund.fromMap(Map json) : super.fromMap(json) {

  }

}