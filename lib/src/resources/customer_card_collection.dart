part of stripe;

class CustomerCardCollection extends ApiResource {

  List<Card> data;
  int count;
  String url;

  CustomerCardCollection.fromMap(Map json) : super.fromMap(json) {

  }

}