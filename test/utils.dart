library test_utils;

import 'dart:async';
import 'dart:io';

import '../lib/stripe.dart';


setApiKeyFromArgs(List<String> args) {

  if (args.length < 1) {
    print('Error. Most tests can not execute without a Stripe API key.');
    print('Provide your stripe API key as the first command line argument!');
    exit(2);
  }
  StripeService.apiKey = args.first;

}


Future setUp() {

  print('Setup Start');
  return new Future.sync(() => print('Setup End'));

}


Future tearDown() async {

  print('Teardown Start');
  List<Future> processQueue = [];
  processQueue.add(deleteAllCustomers());
  processQueue.add(deleteAllCoupons());
  processQueue.add(deleteAllInvoiceitems());
  processQueue.add(deleteAllPlans());
  processQueue.add(deleteAllRecipients());
  await Future.wait(processQueue);
  print('Teardown End');

}


Future deleteAllCustomers() async {

  CustomerCollection customers = await Customer.list(limit: 100);
  List<Future> processQueue = [];
  for (Customer customer in customers.data) {
    processQueue.add(Customer.delete(customer.id).then((_) => print('Delete customer: ${customer.id}')));
  }
  return Future.wait(processQueue);

}


Future deleteAllCoupons() async {

  CouponCollection coupons = await Coupon.list(limit: 100);
  List<Future> processQueue = [];
  for (Coupon coupon in coupons.data) {
    processQueue.add(Coupon.delete(coupon.id).then((_) => print('Delete coupon: ${coupon.id}')));
  }
  return Future.wait(processQueue);

}


Future deleteAllInvoiceitems() async {

  InvoiceitemCollection invoiceitems = await Invoiceitem.list(limit: 100);
  List<Future> processQueue = [];
  for (Invoiceitem invoiceitem in invoiceitems.data) {
    processQueue.add(Invoiceitem.delete(invoiceitem.id).then((_) => print('Delete invoiceitem: ${invoiceitem.id}')));
  }
  return Future.wait(processQueue);

}


Future deleteAllRecipients() async {

  RecipientCollection recipients = await Recipient.list(limit: 100);
  List<Future> processQueue = [];
  for (Recipient recipient in recipients.data) {
    processQueue.add(Recipient.delete(recipient.id).then((_) => print('Delete customer: ${recipient.id}')));
  }
  return Future.wait(processQueue);

}


Future deleteAllPlans() async {

  PlanCollection plans = await Plan.list(limit: 100);
  List<Future> processQueue = [];
  for (Plan plan in plans.data) {
    processQueue.add(Plan.delete(plan.id).then((_) => print('Delete plan: ${plan.id}')));
  }
  return Future.wait(processQueue);

}