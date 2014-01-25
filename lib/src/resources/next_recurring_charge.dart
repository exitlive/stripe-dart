part of stripe;


class NextRecurringCharge extends Resource {
  int amount;
  String date;

  NextRecurringCharge.fromMap(Map json) : super.fromMap(json) {

  }

}