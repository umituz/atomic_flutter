import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

/// A robust and customizable HTTP client for making network requests.
///
/// The [AtomicNetworkClient] provides a simplified and interceptable way to
/// perform HTTP requests (GET, POST, PUT, DELETE, PATCH). It supports base URLs,
/// default headers, timeouts, and automatic JSON encoding/decoding.
/// Interceptors can be added to modify requests or responses globally.
///
/// Features:
/// - Supports common HTTP methods.
/// - Customizable base URL, default headers, and request timeout.
/// - Automatic JSON encoding for request bodies and decoding for responses.
/// - Interceptor pattern for request/response modification, logging, and error handling.
/// - Built-in handling for network errors (timeout, socket, unknown).
/// - Generic response parsing for flexible data handling.
///
/// Example usage:
/// ```dart
/// final client = AtomicNetworkClient(
///   baseUrl: 'https://api.example.com',
///   defaultHeaders: {'Authorization': 'Bearer your_token'},
/// );
///
/// // Add a logging interceptor
/// client.addInterceptor(AtomicLoggingInterceptor());
///
/// // Define a parser for a custom data type
/// User parseUser(dynamic data) {
///   return User.fromJson(data as Map<String, dynamic>);
/// }
///
/// // Perform a GET request
/// try {
///   final response = await client.get<User>(
///     '/users/123',
///     parser: parseUser,
///   );
///   print('User data: ${response.data?.name}');
/// } on AtomicNetworkException catch (e) {
///   print('Network error: ${e.message}');
/// }
///
/// // Perform a POST request
/// try {
///   final response = await client.post(
///     '/posts',
///     body: {'title': 'New Post', 'body': 'Content'},
///   );
///   print('Post created: ${response.statusCode}');
/// } on AtomicNetworkException catch (e) {
///   print('Error creating post: ${e.message}');
/// }
/// ```
class AtomicNetworkClient {
  /// The base URL for all requests made by this client.
  final String baseUrl;

  /// Default headers to be included with every request.
  final Map<String, String> defaultHeaders;

  /// The maximum duration for a request to complete.
  final Duration timeout;

  final http.Client _httpClient;
  final List<AtomicNetworkInterceptor> _interceptors = [];

  /// Creates an [AtomicNetworkClient].
  ///
  /// [baseUrl] is the base URL for all requests.
  /// [defaultHeaders] are headers included with every request.
  /// [timeout] is the maximum duration for a request.
  /// [httpClient] is an optional custom HTTP client.
  AtomicNetworkClient({
    this.baseUrl = '',
    this.defaultHeaders = const {},
    this.timeout = const Duration(seconds: 30),
    http.Client? httpClient,
  }) : _httpClient = httpClient ?? http.Client();

  /// Adds a network interceptor to the client.
  void addInterceptor(AtomicNetworkInterceptor interceptor) {
    _interceptors.add(interceptor);
  }

  /// Removes a network interceptor from the client.
  void removeInterceptor(AtomicNetworkInterceptor interceptor) {
    _interceptors.remove(interceptor);
  }

  /// Performs an HTTP GET request.
  ///
  /// [path] is the endpoint path relative to [baseUrl].
  /// [headers] are additional headers for this specific request.
  /// [queryParameters] are URL query parameters.
  /// [parser] is an optional function to parse the response body into type [T].
  Future<AtomicResponse<T>> get<T>(
    String path, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    AtomicResponseParser<T>? parser,
  }) async {
    return _performRequest(
      method: 'GET',
      path: path,
      headers: headers,
      queryParameters: queryParameters,
      parser: parser,
    );
  }

  /// Performs an HTTP POST request.
  ///
  /// [path] is the endpoint path relative to [baseUrl].
  /// [headers] are additional headers for this specific request.
  /// [queryParameters] are URL query parameters.
  /// [body] is the request body. If not a String, it will be JSON encoded.
  /// [parser] is an optional function to parse the response body into type [T].
  Future<AtomicResponse<T>> post<T>(
    String path, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    dynamic body,
    AtomicResponseParser<T>? parser,
  }) async {
    return _performRequest(
      method: 'POST',
      path: path,
      headers: headers,
      queryParameters: queryParameters,
      body: body,
      parser: parser,
    );
  }

  /// Performs an HTTP PUT request.
  ///
  /// [path] is the endpoint path relative to [baseUrl].
  /// [headers] are additional headers for this specific request.
  /// [queryParameters] are URL query parameters.
  /// [body] is the request body. If not a String, it will be JSON encoded.
  /// [parser] is an optional function to parse the response body into type [T].
  Future<AtomicResponse<T>> put<T>(
    String path, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    dynamic body,
    AtomicResponseParser<T>? parser,
  }) async {
    return _performRequest(
      method: 'PUT',
      path: path,
      headers: headers,
      queryParameters: queryParameters,
      body: body,
      parser: parser,
    );
  }

  /// Performs an HTTP DELETE request.
  ///
  /// [path] is the endpoint path relative to [baseUrl].
  /// [headers] are additional headers for this specific request.
  /// [queryParameters] are URL query parameters.
  /// [body] is the request body. If not a String, it will be JSON encoded.
  /// [parser] is an optional function to parse the response body into type [T].
  Future<AtomicResponse<T>> delete<T>(
    String path, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    dynamic body,
    AtomicResponseParser<T>? parser,
  }) async {
    return _performRequest(
      method: 'DELETE',
      path: path,
      headers: headers,
      queryParameters: queryParameters,
      body: body,
      parser: parser,
    );
  }

  /// Performs an HTTP PATCH request.
  ///
  /// [path] is the endpoint path relative to [baseUrl].
  /// [headers] are additional headers for this specific request.
  /// [queryParameters] are URL query parameters.
  /// [body] is the request body. If not a String, it will be JSON encoded.
  /// [parser] is an optional function to parse the response body into type [T].
  Future<AtomicResponse<T>> patch<T>(
    String path, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    dynamic body,
    AtomicResponseParser<T>? parser,
  }) async {
    return _performRequest(
      method: 'PATCH',
      path: path,
      headers: headers,
      queryParameters: queryParameters,
      body: body,
      parser: parser,
    );
  }

  Future<AtomicResponse<T>> _performRequest<T>({
    required String method,
    required String path,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    dynamic body,
    AtomicResponseParser<T>? parser,
  }) async {
    try {
      final uri = _buildUri(path, queryParameters);

      final requestHeaders = {
        ...defaultHeaders,
        if (headers != null) ...headers,
        if (body != null && body is! String) 'Content-Type': 'application/json',
      };

      var interceptedRequest = AtomicRequest(
        method: method,
        uri: uri,
        headers: requestHeaders,
        body: body,
      );

      for (final interceptor in _interceptors) {
        interceptedRequest = await interceptor.onRequest(interceptedRequest);
      }

      final request =
          http.Request(interceptedRequest.method, interceptedRequest.uri)
            ..headers.addAll(interceptedRequest.headers);

      if (interceptedRequest.body != null) {
        if (interceptedRequest.body is String) {
          request.body = interceptedRequest.body;
        } else {
          request.body = jsonEncode(interceptedRequest.body);
        }
      }

      final streamedResponse = await _httpClient.send(request).timeout(timeout);
      final response = await http.Response.fromStream(streamedResponse);

      var atomicResponse = AtomicResponse<T>(
        statusCode: response.statusCode,
        headers: response.headers,
        body: response.body,
        isSuccess: response.statusCode >= 200 && response.statusCode < 300,
      );

      if (response.body.isNotEmpty) {
        try {
          final decodedBody = jsonDecode(response.body);
          if (parser != null) {
            atomicResponse = atomicResponse.copyWith(
              data: parser(decodedBody),
              rawData: decodedBody,
            );
          } else {
            atomicResponse = atomicResponse.copyWith(
              rawData: decodedBody,
              data: decodedBody is T ? decodedBody : null,
            );
          }
        } catch (e) {
          atomicResponse = atomicResponse.copyWith(
            rawData: response.body,
          );
        }
      }

      for (final interceptor in _interceptors) {
        atomicResponse =
            await interceptor.onResponse(atomicResponse) as AtomicResponse<T>;
      }

      if (!atomicResponse.isSuccess) {
        throw AtomicNetworkException(
          message: 'Request failed with status ${atomicResponse.statusCode}',
          statusCode: atomicResponse.statusCode,
          response: atomicResponse,
        );
      }

      return atomicResponse;
    } on TimeoutException {
      throw AtomicNetworkException(
        message: 'Request timeout',
        type: AtomicNetworkExceptionType.timeout,
      );
    } on SocketException catch (e) {
      throw AtomicNetworkException(
        message: 'Network error: ${e.message}',
        type: AtomicNetworkExceptionType.network,
      );
    } on AtomicNetworkException {
      rethrow;
    } catch (e) {
      throw AtomicNetworkException(
        message: 'Unknown error: $e',
        type: AtomicNetworkExceptionType.unknown,
      );
    }
  }

  Uri _buildUri(String path, Map<String, dynamic>? queryParameters) {
    final fullPath = baseUrl.isEmpty ? path : '$baseUrl$path';
    final uri = Uri.parse(fullPath);

    if (queryParameters != null && queryParameters.isNotEmpty) {
      return uri.replace(
        queryParameters: queryParameters.map(
          (key, value) => MapEntry(key, value.toString()),
        ),
      );
    }

    return uri;
  }

  /// Closes the underlying HTTP client.
  ///
  /// This should be called when the client is no longer needed to free up resources.
  void dispose() {
    _httpClient.close();
  }
}

/// A typedef for a function that parses raw response data into a specific type [T].
typedef AtomicResponseParser<T> = T Function(dynamic data);

/// A model representing an HTTP request.
class AtomicRequest {
  /// The HTTP method of the request (e.g., 'GET', 'POST').
  final String method;

  /// The URI of the request.
  final Uri uri;

  /// The headers of the request.
  final Map<String, String> headers;

  /// The body of the request.
  final dynamic body;

  /// Creates an [AtomicRequest].
  ///
  /// [method] is the HTTP method.
  /// [uri] is the request URI.
  /// [headers] are the request headers.
  /// [body] is the request body.
  const AtomicRequest({
    required this.method,
    required this.uri,
    required this.headers,
    this.body,
  });

  /// Creates a copy of this [AtomicRequest] with the given fields replaced with new values.
  AtomicRequest copyWith({
    String? method,
    Uri? uri,
    Map<String, String>? headers,
    dynamic body,
  }) {
    return AtomicRequest(
      method: method ?? this.method,
      uri: uri ?? this.uri,
      headers: headers ?? this.headers,
      body: body ?? this.body,
    );
  }
}

/// A model representing an HTTP response.
class AtomicResponse<T> {
  /// The HTTP status code of the response.
  final int statusCode;

  /// The headers of the response.
  final Map<String, String> headers;

  /// The raw body of the response as a string.
  final String body;

  /// True if the status code indicates success (2xx), false otherwise.
  final bool isSuccess;

  /// The parsed data of the response, if a parser was provided.
  final T? data;

  /// The raw decoded data of the response (e.g., a Map for JSON).
  final dynamic rawData;

  /// Creates an [AtomicResponse].
  ///
  /// [statusCode] is the HTTP status code.
  /// [headers] are the response headers.
  /// [body] is the raw response body.
  /// [isSuccess] indicates if the request was successful.
  /// [data] is the parsed response data.
  /// [rawData] is the raw decoded response data.
  const AtomicResponse({
    required this.statusCode,
    required this.headers,
    required this.body,
    required this.isSuccess,
    this.data,
    this.rawData,
  });

  /// Creates a copy of this [AtomicResponse] with the given fields replaced with new values.
  AtomicResponse<T> copyWith({
    int? statusCode,
    Map<String, String>? headers,
    String? body,
    bool? isSuccess,
    T? data,
    dynamic rawData,
  }) {
    return AtomicResponse<T>(
      statusCode: statusCode ?? this.statusCode,
      headers: headers ?? this.headers,
      body: body ?? this.body,
      isSuccess: isSuccess ?? this.isSuccess,
      data: data ?? this.data,
      rawData: rawData ?? this.rawData,
    );
  }
}

/// An abstract class for intercepting and modifying network requests and responses.
///
/// Implementations of this class can be added to [AtomicNetworkClient] to
/// perform tasks such as adding authentication headers, logging requests,
/// or handling specific error codes.
abstract class AtomicNetworkInterceptor {
  /// Called before a request is sent.
  ///
  /// Returns the modified [AtomicRequest].
  Future<AtomicRequest> onRequest(AtomicRequest request);

  /// Called after a response is received.
  ///
  /// Returns the modified [AtomicResponse].
  Future<AtomicResponse<dynamic>> onResponse(AtomicResponse<dynamic> response);
}

/// Defines types of network exceptions that can occur.
enum AtomicNetworkExceptionType {
  /// An error related to network connectivity (e.g., no internet).
  network,

  /// A request timed out.
  timeout,

  /// An error indicated by the HTTP response (e.g., 4xx, 5xx status codes).
  response,

  /// An unknown or unhandled error.
  unknown,
}

/// An exception class for network-related errors.
class AtomicNetworkException implements Exception {
  /// The error message.
  final String message;

  /// The HTTP status code of the response, if available.
  final int? statusCode;

  /// The type of network exception.
  final AtomicNetworkExceptionType type;

  /// The [AtomicResponse] that caused the exception, if available.
  final AtomicResponse? response;

  /// Creates an [AtomicNetworkException].
  ///
  /// [message] is a descriptive error message.
  /// [statusCode] is the HTTP status code (optional).
  /// [type] is the type of network exception. Defaults to [AtomicNetworkExceptionType.unknown].
  /// [response] is the [AtomicResponse] that caused the exception (optional).
  const AtomicNetworkException({
    required this.message,
    this.statusCode,
    this.type = AtomicNetworkExceptionType.unknown,
    this.response,
  });

  @override
  String toString() => 'AtomicNetworkException: $message';
}
