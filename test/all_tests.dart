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


main(List<String> args) {

  Logger.root.level = Level.FINEST;
  Logger.root.onRecord.listen((LogRecord record) => print('${record.loggerName} (${record.level}): ${record.message}'));

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