part of stripe;

/// [File uploads](https://stripe.com/docs/api/curl#file_uploads)
class FileUpload extends ApiResource {
  String get id => _dataMap['id'];

  final String object = 'file_upload';

  static var _path = 'files';

  DateTime get created => _getDateTimeFromMap('created');

  String get purpose => _dataMap['purpose'];

  int get size => _dataMap['size'];

  String get type => _dataMap['type'];

  String get url => _dataMap['url'];

  FileUpload.fromMap(Map dataMap) : super.fromMap(dataMap);

  /// [Retrieve a file upload](https://stripe.com/docs/api/curl#retrieve_file_upload)
  static Future<FileUpload> retrieve(String fileUploadId) async {
    var dataMap = await StripeService.retrieve([FileUpload._path, fileUploadId]);
    return new FileUpload.fromMap(dataMap);
  }

  /// [List all file uploads](https://stripe.com/docs/api/curl#list_file_uploads)
  static Future<FileUploadCollection> list(
      {var created, String purpose, int limit, String startingAfter, String endingBefore}) async {
    var data = {};
    if (created != null) data['created'] = created;
    if (endingBefore != null) data['ending_before'] = endingBefore;
    if (limit != null) data['limit'] = limit;
    if (purpose != null) data['purpose'] = purpose;
    if (startingAfter != null) data['starting_after'] = startingAfter;
    if (data == {}) data = null;
    var dataMap = await StripeService.list([FileUpload._path], data: data);
    return new FileUploadCollection.fromMap(dataMap);
  }
}

/// [Create a file upload](https://stripe.com/docs/api/curl#create_file_upload)
class UploadFileCreation extends ResourceRequest {
  // TODO: implement
}

class FileUploadCollection extends ResourceCollection {
  FileUpload _getInstanceFromMap(map) => new FileUpload.fromMap(map);

  FileUploadCollection.fromMap(Map map) : super.fromMap(map);
}
