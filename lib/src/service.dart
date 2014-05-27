part of stripe;


/**
 * The service to communicate with the REST stripe API.
 */
abstract class StripeService {

  static Logger log = new Logger('StripeService');

  static String host = 'api.stripe.com';

  static int port = 443;

  static String basePath = 'v1';

  /// The Api key used to communicate with Stripe
  static String apiKey;

  /// Useful for testing.
  static HttpClient _getClient() => new HttpClient();

  /**
   * Makes a post request to the Stripe API to given path and parameters.
   */
  static Future<Map> create(final List<String> pathParts, final Map data) => _request('POST', pathParts, data: data);

  /**
   * Makes a delete request to the Stripe API
   */
  static Future<Map> delete(final List<String> pathParts, {final Map data}) => _request('DELETE', pathParts, data: data);

  /**
   * Makes a get request to the Stripe API for a single resource item
   * [data] is used for expanding resources
   */
  static Future<Map> retrieve(final List<String> pathParts, {final Map data}) => _request('GET', pathParts, data: data);

  /**
   * Makes a get request to the Stripe API to update an existing resource
   */
  static Future<Map> update(final List<String> pathParts, final Map data) => _request('POST', pathParts, data: data);

  /**
   * Makes a request to the Stripe API for all items of a resource
   * [data] is used for pagination
   */
  static Future<Map> list(final List<String> pathParts, {final Map data}) => _request('GET', pathParts, data: data);

  /**
   * Makes a request a get request to the Stripe API
   */
  static Future<Map> get(final List<String> pathParts, {final Map data}) {
    return _request('GET', pathParts, data: data);
  }

  /**
   * Makes a request a post request to the Stripe API
   */
  static Future<Map> post(final List<String> pathParts, {final Map data}) {
    return _request('POST', pathParts, data: data);
  }

  static Future<Map> _request(final String method, final List<String> pathParts, { final Map data }) {

    pathParts.insert(0, basePath);
    String path = '/' + pathParts.map(Uri.encodeComponent).join('/');
    var uri;
    if (method == 'GET' && data != null) {
      uri = new Uri(scheme: 'https', host: host, path: path, query:encodeMap(data), userInfo: '${apiKey}:');
    } else {
      uri = new Uri(scheme: 'https', host: host, path: path, userInfo: '${apiKey}:');
    }
    log.info('Making ${method} request to API ${uri}');
    var responseStatusCode;
    return _getClient().openUrl(method, uri)
        .then((HttpClientRequest request) {
          if (method == 'POST' && data != null) {
            // Now convert the params to a list of UTF8 encoded bytes of a uri encoded
            // string and add them to the request
            var encodedData = UTF8.encode(encodeMap(data));
            request.headers.add('Content-Type', 'application/x-www-form-urlencoded');
            request.headers.add('Content-Length', encodedData.length);
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
            throw new InvalidRequestErrorException('The JSON returned was unparsable (${body}).');
          }
          if (responseStatusCode != 200) {
            if (map['error'] == null) {
              throw new InvalidRequestErrorException('The status code returned was ${responseStatusCode} but no error was provided.');
            }
            Map error = map['error'];
            switch(error['type']) {
              case 'invalid_request_error':
                throw new InvalidRequestErrorException(error['message']);
                break;
              case 'api_error':
                throw new ApiErrorException(error['message']);
                break;
              case 'card_error':
                throw new CardErrorException(error['message'], error['code'], error['param']);
                break;
              default:
                throw new InvalidRequestErrorException('The status code returned was ${responseStatusCode} but no error type was provided.');
            }
          }
          return map;
        });
  }

  /**
   * Takes a map, and returns a properly escaped Uri String.
   */
  static String encodeMap(final Map data) {
    List<String> output = [];
    for (String k in data.keys) {
      if (data[k] is Map) {
        var hasProps = false;
        for (String kk in data[k].keys) {
          hasProps = true;
          output.add(Uri.encodeComponent('${k}[${kk}]') + '=' + Uri.encodeComponent(data[k][kk].toString()));
        }
        if (!hasProps) {
          output.add(Uri.encodeComponent(k) + '=');
        }
      } else if (data[k] is List) {
        for (String v in data[k]) {
          output.add(Uri.encodeComponent('${k}[]') + '=' + Uri.encodeComponent(v));
        }
      } else if (data[k] is int) {
        output.add(Uri.encodeComponent(k) + '=' + data[k].toString());
      } else {
        output.add(Uri.encodeComponent(k) + '=' + Uri.encodeComponent(data[k]));
      }
    }
    return output.join('&');
  }

}