import 'package:logging/logging.dart';

import 'resources/resource_tests.dart' as resourceTests;
import 'service_tests.dart' as serviceTests;

import 'resources/account_tests.dart' as accountTests;
import 'resources/application_fee_tests.dart' as applicationFeeTests;
import 'resources/balance_tests.dart' as balanceTests;
import 'resources/card_tests.dart' as cardTests;
import 'resources/charge_tests.dart' as chargeTests;
import 'resources/coupon_tests.dart' as couponTests;
import 'resources/customer_tests.dart' as customerTests;
import 'resources/discount_tests.dart' as discountTests;
import 'resources/dispute_tests.dart' as disputeTests;
import 'resources/event_tests.dart' as eventTests;
import 'resources/invoice_item_tests.dart' as invoiceItemTests;
import 'resources/invoice_tests.dart' as invoiceTests;
import 'resources/plan_tests.dart' as planTests;
import 'resources/recipient_tests.dart' as recipientTests;
import 'resources/subscription_tests.dart' as subscriptionTests;
import 'resources/token_tests.dart' as tokenTests;
import 'resources/transfer_tests.dart' as transferTests;
import 'package:unittest/unittest.dart';
import 'package:stack_trace/stack_trace.dart';

/// Unittest configuration
class TestConfiguration extends SimpleConfiguration {

  final String greenColor = '\u001b[33;32m';
  final String redColor = '\u001b[33;31m';
  final String resetColor = '\u001b[33;0m';

  var log = new Logger('Test');

  // Provides instant feedback on the result of a test case printed to log
  @override
  void onTestResult(TestCase testCase) {
    super.onTestResult(testCase);
    var result = '';
    switch (testCase.result) {
      case FAIL:
        result = '[$redColor${testCase.result.toUpperCase()}$resetColor]';
        break;
      case ERROR:
        result = '[$redColor${testCase.result.toUpperCase()}$resetColor]';
        break;
      case PASS:
        result = '[$greenColor${testCase.result.toUpperCase()}$resetColor]';
        break;
      default:
        result = '[${testCase.result.toUpperCase()}]';
    }

    log.info('$result: ${testCase.description}');
    if (!testCase.passed) {
      log.info('$redColor${testCase.message}$resetColor');
      log.severe(new Trace.from(testCase.stackTrace).terse);
    }
  }

  // Uses log instead to present a small summary of the test run
  @override
  void onSummary(int passed, int failed, int errors, List<TestCase> results, String uncaughtError) {
    if (passed == 0 && failed == 0 && errors == 0 && uncaughtError == null) {
      log.info('No tests found.');
      // This is considered a failure too.
    } else if (failed == 0 && errors == 0 && uncaughtError == null) {
      log.info('All $passed tests passed.');
    } else {
      if (uncaughtError != null) {
        log.info('Top-level uncaught error: $uncaughtError');
      }
      log.info('$passed PASSED, $failed FAILED, $errors ERRORS');
    }
  }
}

main(List<String> args) {

  Logger.root.level = Level.INFO;
  Logger.root.onRecord.listen((LogRecord record) => print('${record.message}'));


  unittestConfiguration = new TestConfiguration();
  resourceTests.main();
  serviceTests.main();

  accountTests.main(args);
  applicationFeeTests.main(args);
  balanceTests.main(args);
  cardTests.main(args);
  chargeTests.main(args);
  couponTests.main(args);
  customerTests.main(args);
  discountTests.main(args);
  disputeTests.main(args);
  eventTests.main(args);
  invoiceItemTests.main(args);
  invoiceTests.main(args);
  planTests.main(args);
  recipientTests.main(args);
  subscriptionTests.main(args);
  tokenTests.main(args);
  transferTests.main(args);

}