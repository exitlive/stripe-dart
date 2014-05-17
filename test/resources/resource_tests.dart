library resource_tests;

import 'package:unittest/unittest.dart';

import '../../lib/stripe.dart';


class TestResource extends Resource {
  final String objectName = 'test';
  TestResource.fromMap(map) : super.fromMap(map);
}

class TestResource2 extends Resource {
  TestResource2.fromMap(map) : super.fromMap(map);
}


main() {

  group('Resource', () {


    test('should fail if the `object` key isn not correct or null', () {
      var map = { 'object': 'incorrect' };
      expect(() => new TestResource.fromMap(map), throwsException);
      expect(() => new TestResource2.fromMap(map), throwsA(new isInstanceOf<AssertionError>()));
    });


  });

}