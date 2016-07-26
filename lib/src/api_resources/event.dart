part of stripe;

/// [Event](https://stripe.com/docs/api/curl#events)
class Event extends ApiResource {
  String get id => _dataMap['id'];

  final String object = 'event';

  static var _path = 'events';

  bool get livemode => _dataMap['livemode'];

  DateTime get created => _getDateTimeFromMap('created');

  EventData get data {
    var value = _dataMap['data'];
    if (value == null)
      return null;
    else
      return new EventData.fromMap(value);
  }

  int get pendingWebhooks => _dataMap['pending_webhooks'];

  String get type => _dataMap['type'];

  String get request => _dataMap['request'];

  Event.fromMap(Map dataMap) : super.fromMap(dataMap);

  /// [Retrieve an event](https://stripe.com/docs/api/curl#retrieve_event)
  static Future<Event> retrieve(String eventId) async {
    var dataMap = await StripeService.retrieve([Event._path, eventId]);
    return new Event.fromMap(dataMap);
  }

  /// [List all events](https://stripe.com/docs/api/curl#list_events)
  /// TODO: implement missing argument: `created`
  static Future<EventCollection> list({int limit, String startingAfter, String endingBefore, String type}) async {
    var data = {};
    if (limit != null) data['limit'] = limit;
    if (startingAfter != null) data['starting_after'] = startingAfter;
    if (endingBefore != null) data['ending_before'] = endingBefore;
    if (type != null) data['type'] = type;
    if (data == {}) data = null;
    var dataMap = await StripeService.list([Event._path], data: data);
    return new EventCollection.fromMap(dataMap);
  }
}

class EventCollection extends ResourceCollection {
  Event _getInstanceFromMap(map) => new Event.fromMap(map);

  EventCollection.fromMap(Map map) : super.fromMap(map);
}

class EventData {
  Map _dataMap;

  Map get object => _dataMap['object'];

  Map get previousAttribute => _dataMap['previous_attribute'];

  EventData.fromMap(this._dataMap);
}
