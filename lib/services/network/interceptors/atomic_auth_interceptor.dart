import '../atomic_network_client.dart';

/// Atomic Auth Interceptor
/// Adds authentication headers to requests
class AtomicAuthInterceptor extends AtomicNetworkInterceptor {
  AtomicAuthInterceptor({
    required this.tokenProvider,
    this.headerName = 'Authorization',
    this.tokenPrefix = 'Bearer',
  });

  /// Function to get the current auth token
  final Future<String?> Function() tokenProvider;
  
  /// Header name for the auth token (default: Authorization)
  final String headerName;
  
  /// Token prefix (default: Bearer)
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
  Future<AtomicResponse<dynamic>> onResponse(AtomicResponse<dynamic> response) async {
    // Check for 401 Unauthorized response
    if (response.statusCode == 401) {
      // You could trigger token refresh here
      // or emit an event for the app to handle
    }
    
    return response;
  }
}

/// Example usage:
/// ```dart
/// final client = AtomicNetworkClient(
///   baseUrl: 'https://api.example.com',
/// );
/// 
/// client.addInterceptor(
///   AtomicAuthInterceptor(
///     tokenProvider: () async {
///       // Get token from secure storage
///       return await secureStorage.read('auth_token');
///     },
///   ),
/// );
/// ``` 