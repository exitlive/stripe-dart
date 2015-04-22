library verification_tests;

import 'dart:convert';

import 'package:unittest/unittest.dart';

import '../../lib/stripe.dart';
import '../utils.dart' as utils;
import '../api_resources/file_upload_tests.dart' as file_upload;

var example = '''
    {
      "status": "pending",
      "details": "Identity document is too unclear to read.",
      "document": ${file_upload.example}
    }''';

main(List<String> args) {
  utils.setApiKeyFromArgs(args);

  group('Verification offline', () {
    test('fromMap() properly popullates all values', () {
      var map = JSON.decode(example);
      var verification = new Verification.fromMap(map);
      expect(verification.status, map['status']);
      expect(verification.details, map['details']);
      expect(verification.documentExpand.toMap(), new FileUpload.fromMap(map['document']).toMap());
    });
  });
}
