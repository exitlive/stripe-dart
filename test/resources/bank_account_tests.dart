library bank_account_tests;

import 'dart:convert';

import 'package:unittest/unittest.dart';

import '../../lib/stripe.dart';
import '../utils.dart' as utils;

var example = '''
    {
      "id": "id",
      "object": "bank_account",
      "country": "US",
      "currency": "usd",
      "default_for_currency": false,
      "last4": "1234",
      "status": "new",
      "bank_name": "bank name",
      "fingerprint": "fingerprint",
      "routing_number": "routing_number"
    }''';

var collectionExample = '''
    {
      "object": "list",
      "total_count": 1,
      "has_more": false,
      "url": "/v1/accounts/acct_103yoB41dfVNZFcq/bank_accounts",
      "data": [${example}]
    }''';

main(List<String> args) {
  utils.setApiKeyFromArgs(args);

  group('BankAccount offline', () {
    test('fromMap() properly popullates all values', () {
      var map = JSON.decode(example);
      var bankAccount = new BankAccount.fromMap(map);
      expect(bankAccount.id, map['id']);
      expect(bankAccount.object, map['object']);
      expect(bankAccount.country, map['country']);
      expect(bankAccount.currency, map['currency']);
      expect(bankAccount.defaultForCurrency, map['default_for_currency']);
      expect(bankAccount.last4, map['last4']);
      expect(bankAccount.status, map['status']);
      expect(bankAccount.bankName, map['bank_name']);
      expect(bankAccount.fingerprint, map['fingerprint']);
      expect(bankAccount.routingNumber, map['routing_number']);
    });
  });
}
