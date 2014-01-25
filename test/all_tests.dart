
import 'package:logging/logging.dart';

import "service_tests.dart" as serviceTests;
import "resources/resource_tests.dart" as resourceTests;
import "resources/customer_tests.dart" as customerTests;


main() {

  Logger.root.level = Level.FINEST;
  Logger.root.onRecord.listen((LogRecord record) => print('${record.loggerName} (${record.level}): ${record.message}'));

  serviceTests.main();
  resourceTests.main();
  customerTests.main();

}