part of stripe;

class Card extends Resource {
  int expMonth;
  int expYear;
  String last4;
  String country;
  String type;
  String name;
  String id;
  String customer;
  String addressLine1;
  String addressLine2;
  String addressZip;
  String addressCity;
  String addressState;
  String addressCountry;
  String addressZipCheck;
  String addressLine1Check;
  String cvcCheck;
  String fingerprint;

  Card.fromJson(Map map) : super.fromMap(map) {

  }


}