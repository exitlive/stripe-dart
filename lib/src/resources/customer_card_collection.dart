part of stripe;

class CustomerCardCollection extends ApiResource {

  final String objectName = "list";

  List<Card> get data {
    var value;
    if ((value = _dataMap["data"]) == null) return null;
    else {
      var cards = new List<Card>();

      for (var cardData in value) {
        cards.add(new Card.fromMap(cardData));
      }

      return cards;
    }
  }

  int get count => _dataMap["count"];

  String get url => _dataMap["url"];

  CustomerCardCollection.fromMap(Map dataMap) : super.fromMap(dataMap);

}