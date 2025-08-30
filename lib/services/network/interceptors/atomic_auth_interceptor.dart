import 'package:atomic_flutter_kit/services/network/atomic_network_client.dart';

/// An interceptor for adding authentication tokens to outgoing requests.
///
/// The [AtomicAuthInterceptor] automatically adds an authorization header
/// to every outgoing [AtomicRequest] using a token provided by a `tokenProvider`
/// function. It also includes a basic handler for 401 Unauthorized responses.
///
/// Example usage:
/// ```dart
/// Future<String?> _getToken() async {
///   // Logic to retrieve your authentication token (e.g., from secure storage)
///   return 'my_auth_token_123';
/// }
///
/// final authInterceptor = AtomicAuthInterceptor(
///   tokenProvider: _getToken,
///   headerName: 'X-Auth-Token', // Custom header name
///   tokenPrefix: 'Custom',      // Custom token prefix
/// );
///
/// final client = AtomicNetworkClient();
/// client.addInterceptor(authInterceptor);
/// ```
class AtomicAuthInterceptor extends AtomicNetworkInterceptor {
  /// Creates an [AtomicAuthInterceptor].
  ///
  /// [tokenProvider] is an asynchronous function that returns the authentication token.
  /// [headerName] is the name of the HTTP header to use for the token. Defaults to 'Authorization'.
  /// [tokenPrefix] is the prefix for the token value (e.g., 'Bearer'). Defaults to 'Bearer'.
  AtomicAuthInterceptor({
    required this.tokenProvider,
    this.headerName = 'Authorization',
    this.tokenPrefix = 'Bearer',
  });

  /// An asynchronous function that returns the authentication token.
  final Future<String?> Function() tokenProvider;

  /// The name of the HTTP header to use for the token. Defaults to 'Authorization'.
  final String headerName;

  /// The prefix for the token value (e.g., 'Bearer'). Defaults to 'Bearer'.
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
    // Basic handling for 401 Unauthorized responses
    if (response.statusCode == 401) {
      // TODO: Implement token refresh logic or logout user
      // For example:
      // await AuthService.refreshToken();
      // Or:
      // AuthService.logout();
    }

    return response;
  }
}
