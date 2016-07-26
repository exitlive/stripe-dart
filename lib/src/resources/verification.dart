part of stripe;

class Verification extends Resource {
  String get id => _dataMap['id'];

  final String object = 'verification';

  String get status => _dataMap['status'];

  String get details => _dataMap['details'];

  String get document {
    return this._getIdForExpandable('document');
  }

  FileUpload get documentExpand {
    var value = _dataMap['document'];
    if (value == null)
      return null;
    else
      return new FileUpload.fromMap(value);
  }

  Verification.fromMap(Map dataMap) : super.fromMap(dataMap);
}
