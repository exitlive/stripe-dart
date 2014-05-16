part of stripe;

/**
 * This is an object representing your Stripe account. You can retrieve it to
 * see properties on the account like its current e-mail address or if the
 * account is enabled yet to make live charges.
 */
class Account extends Resource {

  /// A unique identifier for the account
  String get id => _dataMap["id"];

  String objectName = "account";

  static String _path = "account";


  Account.fromMap(Map dataMap) : super.fromMap(dataMap);


  /// Whether or not the account can create live charges
  bool get chargeEnabled => _dataMap["charge_enabled"];

  /// The country of the account
  String get country => _dataMap["country"];

  /// The currencies this account can submit when creating charges
  List<String> get currenciesSupported => _dataMap["currencies_supported"];

  /// The currency this account has chosen to use as the default
  String get defaultCurrency => _dataMap["default_currency"];

  /// Whether or not account details have been submitted yet
  bool get detailsSubmitted => _dataMap["details_submitted"];

  /// Whether or not Stripe will send automatic transfers for this account.
  /// This is only false when Stripe is waiting for additional information from
  /// the account holder.
  bool get transferEnabled => _dataMap["transfer_enabled"];

  /// The display name for this account. This is used on the Stripe dashboard to
  /// help you differentiate between accounts.
  String get displayName => _dataMap["display_name"];

  /// The primary user’s email address
  String get email => _dataMap["email"];

  /// The text that will appear on credit card statements
  String get statementDescriptor => _dataMap["statement_descriptor"];

  /// The timezone used in the Stripe dashboard for this account. A list of
  /// possible timezone values is maintained at the
  /// [IANA Timezone Database](http://www.iana.org/time-zones).
  String get timezone => _dataMap["timezone"];


  /**
   * Retrieves the details of the account, based on the API key that was used
   * to make the request.
   */
  static Future<Account> retrieve() {
    return StripeService.retrieve([Account._path])
        .then((Map json) => new Account.fromMap(json));
  }


}