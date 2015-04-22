import 'package:logging/logging.dart';
import 'package:unittest/unittest.dart';
import 'package:stack_trace/stack_trace.dart';

// general tests
import 'resource_tests.dart' as resourceTests;
import 'api_resource_tests.dart' as apiResourceTests;
import 'service_tests.dart' as serviceTests;

// api resource tests
import 'api_resources/account_tests.dart' as accountTests;
import 'api_resources/application_fee_tests.dart' as applicationFeeTests;
import 'api_resources/balance_tests.dart' as balanceTests;
import 'api_resources/balance_transaction_tests.dart' as balanceTransactionTests;
import 'api_resources/card_tests.dart' as cardTests;
import 'api_resources/charge_tests.dart' as chargeTests;
import 'api_resources/coupon_tests.dart' as couponTests;
import 'api_resources/customer_tests.dart' as customerTests;
import 'api_resources/discount_tests.dart' as discountTests;
import 'api_resources/dispute_tests.dart' as disputeTests;
import 'api_resources/event_tests.dart' as eventTests;
import 'api_resources/invoice_item_tests.dart' as invoiceItemTests;
import 'api_resources/invoice_tests.dart' as invoiceTests;
import 'api_resources/plan_tests.dart' as planTests;
import 'api_resources/refund_tests.dart' as refundTests;
import 'api_resources/subscription_tests.dart' as subscriptionTests;
import 'api_resources/token_tests.dart' as tokenTests;
import 'api_resources/transfer_tests.dart' as transferTests;
import 'api_resources/transfer_reversal_tests.dart' as transferReversalTests;

// resource tests
import 'resources/address_tests.dart' as addressTests;
import 'resources/bank_account_tests.dart' as bankAccountTests;
import 'resources/date_tests.dart' as dateTests;
import 'resources/shipping_tests.dart' as shippingTests;

/// Unittest configuration
class TestConfiguration extends SimpleConfiguration {

  // change color to green
  final String cg = '\u001b[33;32m';
  // change color to red
  final String cr = '\u001b[33;31m';
  // change color to white
  final String cw = '\u001B[37m';

  var log = new Logger('Test');

  // Provides instant feedback on the result of a test case printed to log
  @override
  void onTestResult(TestCase testCase) {
    super.onTestResult(testCase);
    var result = '';
    switch (testCase.result) {
      case FAIL:
        result = '$cr${testCase.result.toUpperCase()}$cw';
        break;
      case ERROR:
        result = '$cr${testCase.result.toUpperCase()}$cw';
        break;
      case PASS:
        result = '$cg${testCase.result.toUpperCase()}$cw';
        break;
      default:
        result = '${testCase.result.toUpperCase()}';
    }

    log.info('$result: ${testCase.description}');
    if (!testCase.passed) {
      log.info('$cr${testCase.message}$cw');
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

  // general tests
  resourceTests.main();
  apiResourceTests.main();
  serviceTests.main();

  // api resource tests
  accountTests.main(args);
  applicationFeeTests.main(args);
  balanceTests.main(args);
  balanceTransactionTests.main(args);
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
  refundTests.main(args);
  subscriptionTests.main(args);
  tokenTests.main(args);
  transferTests.main(args);
  transferReversalTests.main(args);

  // resource tests
  addressTests.main(args);
  bankAccountTests.main(args);
  dateTests.main(args);
  shippingTests.main(args);
}
