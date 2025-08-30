import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class AtomicNetworkClient {
  AtomicNetworkClient({
    this.baseUrl = '',
    this.defaultHeaders = const {},
    this.timeout = const Duration(seconds: 30),
    http.Client? httpClient,
  }) : _httpClient = httpClient ?? http.Client();

  final String baseUrl;
  final Map<String, String> defaultHeaders;
  final Duration timeout;
  final http.Client _httpClient;

  final List<AtomicNetworkInterceptor> _interceptors = [];

  void addInterceptor(AtomicNetworkInterceptor interceptor) {
    _interceptors.add(interceptor);
  }

  void removeInterceptor(AtomicNetworkInterceptor interceptor) {
    _interceptors.remove(interceptor);
  }

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

  void dispose() {
    _httpClient.close();
  }
}

typedef AtomicResponseParser<T> = T Function(dynamic data);

class AtomicRequest {
  const AtomicRequest({
    required this.method,
    required this.uri,
    required this.headers,
    this.body,
  });

  final String method;
  final Uri uri;
  final Map<String, String> headers;
  final dynamic body;

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

class AtomicResponse<T> {
  const AtomicResponse({
    required this.statusCode,
    required this.headers,
    required this.body,
    required this.isSuccess,
    this.data,
    this.rawData,
  });

  final int statusCode;
  final Map<String, String> headers;
  final String body;
  final bool isSuccess;
  final T? data;
  final dynamic rawData;

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

abstract class AtomicNetworkInterceptor {
  Future<AtomicRequest> onRequest(AtomicRequest request);

  Future<AtomicResponse<dynamic>> onResponse(AtomicResponse<dynamic> response);
}

enum AtomicNetworkExceptionType {
  network,

  timeout,

  response,

  unknown,
}

class AtomicNetworkException implements Exception {
  const AtomicNetworkException({
    required this.message,
    this.statusCode,
    this.type = AtomicNetworkExceptionType.unknown,
    this.response,
  });

  final String message;
  final int? statusCode;
  final AtomicNetworkExceptionType type;
  final AtomicResponse? response;

  @override
  String toString() => 'AtomicNetworkException: $message';
}
