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


Future tearDown() {

  print('Teardown Start');
  List<Future> processQueue = [];
  processQueue.add(deleteAllCustomers());
  processQueue.add(deleteAllCoupons());
  processQueue.add(deleteAllInvoiceitems());
  processQueue.add(deleteAllPlans());
  processQueue.add(deleteAllRecipients());
  return Future.wait(processQueue).then((_) {
    print('Teardown End');
    return new Future.value();
  });

}


Future deleteAllCustomers() {

  return Customer.list(limit: 100)
      .then((CustomerCollection customers) {
        List<Future> processQueue = [];
        for (Customer customer in customers.data) {
          processQueue.add(Customer.delete(customer.id).then((_) => print('Delete customer: ${customer.id}')));
        }
        return Future.wait(processQueue);
      });

}


Future deleteAllCoupons() {

  return Coupon.list(limit: 100)
      .then((CouponCollection coupons) {
        List<Future> processQueue = [];
        for (Coupon coupon in coupons.data) {
          processQueue.add(Coupon.delete(coupon.id).then((_) => print('Delete coupon: ${coupon.id}')));
        }
        return Future.wait(processQueue);
      });

}


Future deleteAllInvoiceitems() {

  return Invoiceitem.list(limit: 100)
      .then((InvoiceitemCollection invoiceitems) {
        List<Future> processQueue = [];
        for (Invoiceitem invoiceitem in invoiceitems.data) {
          processQueue.add(Invoiceitem.delete(invoiceitem.id).then((_) => print('Delete invoiceitem: ${invoiceitem.id}')));
        }
        return Future.wait(processQueue);
      });

}


Future deleteAllRecipients() {

  return Recipient.list(limit: 100)
      .then((RecipientCollection recipients) {
        List<Future> processQueue = [];
        for (Recipient recipient in recipients.data) {
          processQueue.add(Recipient.delete(recipient.id).then((_) => print('Delete customer: ${recipient.id}')));
        }
        return Future.wait(processQueue);
      });

}


Future deleteAllPlans() {

  return Plan.list(limit: 100)
      .then((PlanCollection plans) {
        List<Future> processQueue = [];
        for (Plan plan in plans.data) {
          processQueue.add(Plan.delete(plan.id).then((_) => print('Delete plan: ${plan.id}')));
        }
        return Future.wait(processQueue);
      });

}