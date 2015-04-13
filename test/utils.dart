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


Future setUp() async {

  print('Setup Start');
  print('Setup End');

}


Future tearDown() async {

  print('Teardown Start');
  await deleteAllCustomers();
  await deleteAllCoupons();
  await deleteAllInvoiceitems();
  await deleteAllPlans();
  await deleteAllRecipients();
  print('Teardown End');

}


Future deleteAllCustomers() async {

  CustomerCollection customers = await Customer.list(limit: 100);
  for (Customer customer in customers.data) {
    print('Delete customer: ${customer.id}');
    await Customer.delete(customer.id);
  }

}


Future deleteAllCoupons() async {

  CouponCollection coupons = await Coupon.list(limit: 100);
  for (Coupon coupon in coupons.data) {
    print('Delete coupon: ${coupon.id}');
    await Coupon.delete(coupon.id);
  }

}


Future deleteAllInvoiceitems() async {

  InvoiceitemCollection invoiceitems = await Invoiceitem.list(limit: 100);
  for (Invoiceitem invoiceitem in invoiceitems.data) {
    await Invoiceitem.delete(invoiceitem.id);
    print('Delete invoiceitem: ${invoiceitem.id}');
  }

}


Future deleteAllRecipients() async {

  RecipientCollection recipients = await Recipient.list(limit: 100);
  for (Recipient recipient in recipients.data) {
    await Recipient.delete(recipient.id);
    print('Delete customer: ${recipient.id}');
  }

}


Future deleteAllPlans() async {

  PlanCollection plans = await Plan.list(limit: 100);
  for (Plan plan in plans.data) {
    await Plan.delete(plan.id);
    print('Delete plan: ${plan.id}');
  }

}