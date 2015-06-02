library api_resource_tests;

import 'package:unittest/unittest.dart';

import '../lib/stripe.dart';

class TestResource extends ApiResource {
  final String object = 'test';
  TestResource.fromMap(map) : super.fromMap(map);
}

class TestResource2 extends ApiResource {
  TestResource2.fromMap(map) : super.fromMap(map);
}

main() {
  group('Resource', () {
    test('should fail if the `object` key is not correct or null', () {
      var map = {'object': 'test'};
      expect(new TestResource.fromMap(map).object, 'test');
      map = {'object': 'incorrect'};
      expect(() => new TestResource.fromMap(map), throwsException);
      expect(() => new TestResource2.fromMap(map), throwsA(new isInstanceOf<AssertionError>()));
    });

    test('should fail the dataMap is null', () {
      var map = null;
      expect(() => new TestResource.fromMap(map), throwsException);
    });
  });
}
