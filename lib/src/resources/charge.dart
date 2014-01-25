part of stripe;

/**
 * To charge a credit or a debit card, you create a new charge object.
 *
 * You can retrieve and refund individual charges as well as list all charges.
 *
 * Charges are identified by a unique random ID.
 */
class Charge extends Resource {

  int amount;
  int created;
  String currency;
  String id;
  bool livemode;
  bool paid;
  bool refunded;
  bool disputed;
  bool captured;
  String description;
  String failureMessage;
  String failureCode;
  int amountRefunded;
  String customer;
  String invoice;
  List<Refund> refunds;
  Card card;
  Dispute dispute;
  String balanceTransaction;
  Map<String, String> metadata;

  Charge.fromJson(Map json) : super.fromMap(json) {

  }


}