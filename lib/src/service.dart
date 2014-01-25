part of stripe;

/**
 * The service to communicate with the REST stripe API.
 */
abstract class StripeService {

  static Logger log = new Logger("StripeService");

  static String host = 'api.stripe.com';

  static int port = 443;

  static String basePath = '/v1/';

  /// The Api key used to communicate with Stripe
  static String apiKey;


  /// Useful for testing.
  static HttpClient _getClient() => new HttpClient();


  /**
   * Makes a post request to the Stripe API to given path and parameters.
   */
  static Future<Map> post(final String path, final Map params) {

    var uri = new Uri(scheme: "https", host: host, path: "${basePath}${path}", userInfo: "${apiKey}:");

    log.info("Posting to API ${uri}");

    return _getClient().postUrl(uri)
      .then((HttpClientRequest request) {
        // Now convert the params to a list of UTF8 encoded bytes of a uri encoded
        // string and add them to the request
        request.headers.add("Content-Type", "application/x-www-form-urlencoded");
        request.add(UTF8.encode(encodeMap(params)));
        return request.close();
      })
      .then((HttpClientResponse response) {
        // TODO: Proper error handling
        // https://stripe.com/docs/api/curl#errors

        return response.transform(UTF8.decoder).toList().then((data) {
          return data.join('');
        });
      })
      .then((String body) {
        return JSON.decode(body);
      });
  }


  /**
   * Takes a map, and returns a properly escaped Uri String.
   */
  static String encodeMap(final Map data) => data.keys.map((key) => "${Uri.encodeComponent(key)}=${Uri.encodeComponent(data[key])}").join("&");


}