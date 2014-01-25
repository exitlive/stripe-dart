library connection_settings_tests;

import 'package:unittest/unittest.dart';

//import 'package:unittest/mock.dart';

import '../lib/stripe.dart';



main() {

  group('StripeService', () {

    group('helper functions', () {
      test("encodeMap()", () {
        var encoded = StripeService.encodeMap({ "test": "val&ue", "test 2": "/" });

        expect(encoded, equals("test=val%26ue&test%202=%2F"));
      });

    });

  });

}