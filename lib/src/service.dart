part of stripe;

/**
 * The service to communicate with the REST stripe API.
 */
abstract class StripeService {

  static String host = 'api.stripe.com';

  static int port = 443;

  static String basePath = '/v1/';

  /// The Api key used to communicate with Stripe
  static String apiKey;


  static HttpClient _getClient() => new HttpClient();

  static Future<Map> post(String path, Map params) {

    var uri = new Uri(scheme: "https", host: host, path: "${basePath}${path}", userInfo: "${apiKey}:");
    print(uri);

    return _getClient().postUrl(uri)
      .then((HttpClientRequest request) {
        // Now convert the params to a list of UTF8 encoded bytes and add them to the request
        request.headers.add("Content-Type", "application/json");
        request.add(UTF8.encode(JSON.encode(params)));
        return request.close();
      })
      .then((HttpClientResponse response) {
        return response.transform(UTF8.decoder).toList().then((data) {
          return data.join('');
        });
      })
      .then((String body) {
        print(body);
        return JSON.decode(body);
      });
  }


  /**
   * Takes a map, and returns a properly escaped Uri String.
   */
  static String encodeMap(Map data) => data.keys.map((key) => "${Uri.encodeComponent(key)}=${Uri.encodeComponent(data[key])}").join("&");


}