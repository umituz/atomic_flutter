import 'package:atomic_flutter_kit/services/network/atomic_network_client.dart';

class AtomicAuthInterceptor extends AtomicNetworkInterceptor {
  AtomicAuthInterceptor({
    required this.tokenProvider,
    this.headerName = 'Authorization',
    this.tokenPrefix = 'Bearer',
  });

  final Future<String?> Function() tokenProvider;

  final String headerName;

  final String tokenPrefix;

  @override
  Future<AtomicRequest> onRequest(AtomicRequest request) async {
    final token = await tokenProvider();

    if (token != null && token.isNotEmpty) {
      final updatedHeaders = Map<String, String>.from(request.headers);
      updatedHeaders[headerName] = '$tokenPrefix $token';

      return request.copyWith(headers: updatedHeaders);
    }

    return request;
  }

  @override
  Future<AtomicResponse<dynamic>> onResponse(
      AtomicResponse<dynamic> response) async {
    if (response.statusCode == 401) {}

    return response;
  }
}
