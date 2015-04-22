library test_utils;

import 'dart:async';
import 'dart:io';

import '../lib/stripe.dart';
import 'package:logging/logging.dart';

var log = new Logger('Test Utils');

var metadataExample = '''
    {
      "string": "string",
      "int": 10,
      "bool": true,
      "list": ["string", 10, true],
      "map": {"foo": "bar"}
    }''';

setApiKeyFromArgs(List<String> args) {
  if (args.length < 1) {
    log.severe('Error. Most tests can not execute without a Stripe API key.');
    log.severe('Provide your stripe API key as the first command line argument!');
    exit(1);
  }
  StripeService.apiKey = args.first;
}

Future tearDown() async {
  log.finest('Teardown Start');
  await deleteAllCustomers();
  await deleteAllCoupons();
  await deleteAllInvoiceItems();
  await deleteAllPlans();
  log.finest('Teardown End');
}

Future deleteAllCustomers() async {
  var customers = await Customer.list(limit: 100);
  for (Customer customer in customers.data) {
    log.finest('Delete customer: ${customer.id}');
    await Customer.delete(customer.id);
  }
}

Future deleteAllCoupons() async {
  var coupons = await Coupon.list(limit: 100);
  for (Coupon coupon in coupons.data) {
    log.finest('Delete coupon: ${coupon.id}');
    await Coupon.delete(coupon.id);
  }
}

Future deleteAllInvoiceItems() async {
  var invoiceItems = await InvoiceItem.list(limit: 100);
  for (InvoiceItem invoiceItem in invoiceItems.data) {
    await InvoiceItem.delete(invoiceItem.id);
    log.finest('Delete invoice item: ${invoiceItem.id}');
  }
}

Future deleteAllPlans() async {
  var plans = await Plan.list(limit: 100);
  for (Plan plan in plans.data) {
    await Plan.delete(plan.id);
    log.finest('Delete plan: ${plan.id}');
  }
}
