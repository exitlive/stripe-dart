part of stripe;

/**
 * A dispute occurs when a customer questions your charge with their bank or
 * credit card company. When a customer disputes your charge, you're given the
 * opportunity to respond to the dispute with evidence that shows the charge is
 * legitimate.
 *
 * You can find more information about the dispute process in our
 * [disputes FAQ](https://stripe.com/help/disputes).
 */
class Dispute extends Resource {
  String charge;
  int amount;
  String status;
  String currency;
  int created;
  bool livemode;
  String evidence;
  int evidenceDueBy;
  String reason;
  String balanceTransaction;

  Dispute.fromMap(Map json) : super.fromMap(json) {

  }

}