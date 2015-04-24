library account_tests;

import 'dart:convert';

import 'package:unittest/unittest.dart';

import '../../lib/stripe.dart';
import '../utils.dart' as utils;

import '../resources/bank_account_tests.dart' as bank_account;
import '../resources/legal_entity_tests.dart' as legal_entity;
import '../resources/tos_acceptance_tests.dart' as tos_acceptance;
import '../resources/transfer_schedule_tests.dart' as transfer_schedule;
import '../resources/verification_tests.dart' as verification;

var example = '''
    {
      "id": "acct_102yoB41dfVNZFcq",
      "object": "account",
      "charges_enabled": true,
      "country": "US",
      "currencies_supported": [
        "usd",
        "cad"
      ],
      "default_currency": "usd",
      "details_submitted": true,
      "transfers_enabled": true,
      "display_name": "display_name",
      "email": "test@test.com",
      "statement_descriptor": "statement_descriptor",
      "timezone": "Etc/UTC",
      "business_name": "business_name",
      "business_url": "business_url",
      "metadata": ${utils.metadataExample},
      "support_phone": "support_phone",
      "managed": true,
      "bank_accounts": ${bank_account.collectionExample},
      "debit_negative_balances": true,
      "legal_entity": ${legal_entity.example},
      "product_description": "product_description",
      "tos_acceptance": ${tos_acceptance.example},
      "transfer_schedule": ${transfer_schedule.example},
      "verification": ${verification.example}
    }''';

main(List<String> args) {
  utils.setApiKeyFromArgs(args);

  group('Account offline', () {
    test('fromMap() properly popullates all values', () {
      var map = JSON.decode(example);
      var account = new Account.fromMap(map);
      expect(account.id, map['id']);
      expect(account.country, map['country']);
      expect(account.currenciesSupported, map['currencies_supported']);
      expect(account.defaultCurrency, map['default_currency']);
      expect(account.detailsSubmitted, map['details_submitted']);
      expect(account.transfersEnabled, map['transfers_enabled']);
      expect(account.displayName, map['display_name']);
      expect(account.email, map['email']);
      expect(account.statementDescriptor, map['statement_descriptor']);
      expect(account.timezone, map['timezone']);
      expect(account.businessName, map['business_name']);
      expect(account.businessUrl, map['business_url']);
      expect(account.metadata, map['metadata']);
      expect(account.supportPhone, map['support_phone']);
      expect(account.managed, map['managed']);
      expect(account.bankAccounts.toMap(), new BankAccount.fromMap(map['bank_accounts']).toMap());
      expect(account.debitNegativeBalances, map['debit_negative_balances']);
      expect(account.legalEntity.toMap(), new LegalEntity.fromMap(map['legal_entity']).toMap());
      expect(account.productDescription, map['product_description']);
      expect(account.tosAcceptance.toMap(), new TosAcceptance.fromMap(map['tos_acceptance']).toMap());
      expect(account.transferSchedule.toMap(), new TransferSchedule.fromMap(map['transfer_schedule']).toMap());
      expect(account.verification.toMap(), new Verification.fromMap(map['verification']).toMap());
    });
  });

  group('Account online', () {
    test('Retrieve Account', () async {
      var account = await Account.retrieve();
      expect(account.id.substring(0, 3), 'acc');
      // other tests will depend on your stripe account

    });
  });
}
