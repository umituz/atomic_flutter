import 'dart:developer' as developer;
import 'package:atomic_flutter_kit/services/network/atomic_network_client.dart';

/// Atomic Logging Interceptor
/// Logs all network requests and responses for debugging
class AtomicLoggingInterceptor extends AtomicNetworkInterceptor {
  AtomicLoggingInterceptor({
    this.logRequest = true,
    this.logResponse = true,
    this.logHeaders = false,
    this.logBody = false,
  });

  final bool logRequest;
  final bool logResponse;
  final bool logHeaders;
  final bool logBody;

  @override
  Future<AtomicRequest> onRequest(AtomicRequest request) async {
    if (logRequest) {
      final buffer = StringBuffer();
      buffer.writeln('╔═══════════════════════════════════════════════════════════════════════════');
      buffer.writeln('║ REQUEST: ${request.method} ${request.uri}');
      buffer.writeln('╟───────────────────────────────────────────────────────────────────────────');
      
      if (logHeaders && request.headers.isNotEmpty) {
        buffer.writeln('║ Headers:');
        request.headers.forEach((key, value) {
          buffer.writeln('║   $key: $value');
        });
        buffer.writeln('╟───────────────────────────────────────────────────────────────────────────');
      }
      
      if (logBody && request.body != null) {
        buffer.writeln('║ Body:');
        buffer.writeln('║   ${request.body}');
        buffer.writeln('╟───────────────────────────────────────────────────────────────────────────');
      }
      
      buffer.writeln('╚═══════════════════════════════════════════════════════════════════════════');
      
      developer.log(buffer.toString(), name: 'AtomicNetwork');
    }
    
    return request;
  }

  @override
  Future<AtomicResponse<dynamic>> onResponse(AtomicResponse<dynamic> response) async {
    if (logResponse) {
      final buffer = StringBuffer();
      buffer.writeln('╔═══════════════════════════════════════════════════════════════════════════');
      buffer.writeln('║ RESPONSE: ${response.statusCode} ${response.isSuccess ? "✓" : "✗"}');
      buffer.writeln('╟───────────────────────────────────────────────────────────────────────────');
      
      if (logHeaders && response.headers.isNotEmpty) {
        buffer.writeln('║ Headers:');
        response.headers.forEach((key, value) {
          buffer.writeln('║   $key: $value');
        });
        buffer.writeln('╟───────────────────────────────────────────────────────────────────────────');
      }
      
      if (logBody) {
        if (response.rawData != null) {
          buffer.writeln('║ Data:');
          buffer.writeln('║   ${response.rawData}');
        } else if (response.body.isNotEmpty) {
          buffer.writeln('║ Body:');
          buffer.writeln('║   ${response.body}');
        }
        buffer.writeln('╟───────────────────────────────────────────────────────────────────────────');
      }
      
      buffer.writeln('╚═══════════════════════════════════════════════════════════════════════════');
      
      developer.log(buffer.toString(), name: 'AtomicNetwork');
    }
    
    return response;
  }
} 