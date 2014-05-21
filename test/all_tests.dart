
import 'package:logging/logging.dart';

import 'service_tests.dart' as serviceTests;
import 'resources/resource_tests.dart' as resourceTests;


import 'resources/account_tests.dart' as accountTests;
import 'resources/balance_tests.dart' as balanceTests;
import 'resources/charge_tests.dart' as chargeTests;
import 'resources/coupon_tests.dart' as couponTests;
import 'resources/customer_tests.dart' as customerTests;
import 'resources/card_tests.dart' as cardTests;
import 'resources/discount_tests.dart' as discountTests;
import 'resources/dispute_tests.dart' as disputeTests;
import 'resources/subscription_tests.dart' as subscriptionTests;
import 'resources/plan_tests.dart' as planTests;


main(List<String> args) {

  Logger.root.level = Level.FINEST;
  Logger.root.onRecord.listen((LogRecord record) => print('${record.loggerName} (${record.level}): ${record.message}'));

  serviceTests.main();
  resourceTests.main();

  accountTests.main(args);
  balanceTests.main(args);
  cardTests.main(args);
  chargeTests.main(args);
  couponTests.main(args);
  customerTests.main(args);
  discountTests.main(args);
  disputeTests.main(args);
  subscriptionTests.main(args);
  planTests.main(args);

}