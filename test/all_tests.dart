
import 'package:logging/logging.dart';

import "service_tests.dart" as serviceTests;
import "resources/resource_tests.dart" as resourceTests;
import "resources/card_tests.dart" as cardTests;
import "resources/charge_tests.dart" as chargeTests;
import "resources/coupon_tests.dart" as couponTests;
import "resources/customer_tests.dart" as customerTests;


main(List<String> args) {

  Logger.root.level = Level.FINEST;
  Logger.root.onRecord.listen((LogRecord record) => print('${record.loggerName} (${record.level}): ${record.message}'));

  serviceTests.main();
  resourceTests.main();
  cardTests.main(args);
  chargeTests.main(args);
  couponTests.main(args);
  customerTests.main(args);

}