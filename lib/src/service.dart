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
  static Future<Map> create(final String path, final Map params) => _request("POST", "${basePath}${path}", postData: params);

  /**
   * Makes a delete request to the Stripe API
   */
  static Future<Map> delete(final String path, final String id) => _request("DELETE", "${basePath}${path}/${id}");

  /**
   * Makes a get request to the Stripe API for a single resource item
   */
  static Future<Map> retrieve(final String path, final String id) => _request("GET", "${basePath}${path}/${id}");

  /**
   * Makes a request to the Stripe API for all items of a resource
   */
  static Future<Map> all(final String path, final Map params) => _request("GET", "${basePath}${path}", postData: params);

  static Future<Map> _request(final String method, final String path, { final Map postData }) {
    var uri = new Uri(scheme: "https", host: host, path: path, userInfo: "${apiKey}:");

    log.info("Making ${method} request to API ${uri}");


    var responseStatusCode;

    return _getClient().openUrl(method, uri)
      .then((HttpClientRequest request) {

        if (postData != null) {
          // Now convert the params to a list of UTF8 encoded bytes of a uri encoded
          // string and add them to the request
          var encodedData = UTF8.encode(encodeMap(postData));
          request.headers.add("Content-Type", "application/x-www-form-urlencoded");
          request.headers.add("Content-Length", encodedData.length);
          request.add(encodedData);
        }
        return request.close();
      })
      .then((HttpClientResponse response) {
        responseStatusCode = response.statusCode;

        return response.transform(UTF8.decoder).toList().then((data) => data.join(''));
      })
      .then((String body) {
        var map;

        try {
          map = JSON.decode(body);
        } on Error {
          throw new InvalidRequestErrorException("The JSON returned was unparsable (${body}).");
        }



        if (responseStatusCode != 200) {
          if (map["error"] == null) {
            throw new InvalidRequestErrorException("The status code returned was ${responseStatusCode} but no error was provided.");
          }
          Map error = map["error"];
          switch(error["type"]) {
            case "invalid_request_error":
              throw new InvalidRequestErrorException(error["message"]);
              break;
            case "api_error":
              throw new ApiErrorException(error["message"]);
              break;
            case "card_error":
              throw new CardErrorException(error["message"], error["code"], error["param"]);
              break;
            default:
              throw new InvalidRequestErrorException("The status code returned was ${responseStatusCode} but no error type was provided.");
          }
        }
        return map;
      });
  }


  /**
   * Takes a map, and returns a properly escaped Uri String.
   *
   * TODO: needs improvement
   */
  static String encodeMap(final Map data) {
    return data.keys.map(
        (key) {
          if (data[key] is String) {
            return "${Uri.encodeComponent(key)}=${Uri.encodeComponent(data[key])}";
          } else {
            return "${Uri.encodeComponent(key)}=${data[key]}";
          }
        }
      ).join("&");
  }



}