import 'dart:developer' as developer;
import 'package:atomic_flutter_kit/services/network/atomic_network_client.dart';

/// An [AtomicNetworkInterceptor] that logs network requests and responses for debugging purposes.
///
/// The [AtomicLoggingInterceptor] provides detailed logs of HTTP requests and
/// their corresponding responses, including method, URI, headers, and body.
/// It can be configured to log specific parts of the request/response.
///
/// Example usage:
/// ```dart
/// final client = AtomicNetworkClient(baseUrl: 'https://api.example.com');
///
/// // Log all requests and responses, including headers and body
/// client.addInterceptor(AtomicLoggingInterceptor(
///   logRequest: true,
///   logResponse: true,
///   logHeaders: true,
///   logBody: true,
/// ));
///
/// // Only log requests
/// client.addInterceptor(AtomicLoggingInterceptor(logResponse: false));
/// ```
class AtomicLoggingInterceptor extends AtomicNetworkInterceptor {
  /// Creates an [AtomicLoggingInterceptor].
  ///
  /// [logRequest] if true, logs outgoing requests. Defaults to true.
  /// [logResponse] if true, logs incoming responses. Defaults to true.
  /// [logHeaders] if true, logs request and response headers. Defaults to false.
  /// [logBody] if true, logs request and response bodies. Defaults to false.
  AtomicLoggingInterceptor({
    this.logRequest = true,
    this.logResponse = true,
    this.logHeaders = false,
    this.logBody = false,
  });

  /// If true, logs outgoing requests.
  final bool logRequest;

  /// If true, logs incoming responses.
  final bool logResponse;

  /// If true, logs request and response headers.
  final bool logHeaders;

  /// If true, logs request and response bodies.
  final bool logBody;

  @override
  Future<AtomicRequest> onRequest(AtomicRequest request) async {
    if (logRequest) {
      final buffer = StringBuffer();
      buffer.writeln(
          '╔═══════════════════════════════════════════════════════════════════════════');
      buffer.writeln('║ REQUEST: ${request.method} ${request.uri}');
      buffer.writeln(
          '╟───────────────────────────────────────────────────────────────────────────');

      if (logHeaders && request.headers.isNotEmpty) {
        buffer.writeln('║ Headers:');
        request.headers.forEach((key, value) {
          buffer.writeln('║   $key: $value');
        });
        buffer.writeln(
            '╟───────────────────────────────────────────────────────────────────────────');
      }

      if (logBody && request.body != null) {
        buffer.writeln('║ Body:');
        buffer.writeln('║   ${request.body}');
        buffer.writeln(
            '╟───────────────────────────────────────────────────────────────────────────');
      }

      buffer.writeln(
          '╚═══════════════════════════════════════════════════════════════════════════');

      developer.log(buffer.toString(), name: 'AtomicNetwork');
    }

    return request;
  }

  @override
  Future<AtomicResponse<dynamic>> onResponse(
      AtomicResponse<dynamic> response) async {
    if (logResponse) {
      final buffer = StringBuffer();
      buffer.writeln(
          '╔═══════════════════════════════════════════════════════════════════════════');
      buffer.writeln(
          '║ RESPONSE: ${response.statusCode} ${response.isSuccess ? "✓" : "✗"}');
      buffer.writeln(
          '╟───────────────────────────────────────────────────────────────────────────');

      if (logHeaders && response.headers.isNotEmpty) {
        buffer.writeln('║ Headers:');
        response.headers.forEach((key, value) {
          buffer.writeln('║   $key: $value');
        });
        buffer.writeln(
            '╟───────────────────────────────────────────────────────────────────────────');
      }

      if (logBody) {
        if (response.rawData != null) {
          buffer.writeln('║ Data:');
          buffer.writeln('║   ${response.rawData}');
        } else if (response.body.isNotEmpty) {
          buffer.writeln('║ Body:');
          buffer.writeln('║   ${response.body}');
        }
        buffer.writeln(
            '╟───────────────────────────────────────────────────────────────────────────');
      }

      buffer.writeln(
          '╚═══════════════════════════════════════════════════════════════════════════');

      developer.log(buffer.toString(), name: 'AtomicNetwork');
    }

    return response;
  }
}
