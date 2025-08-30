import 'package:dio/dio.dart';
import '../config/app_env.dart';

class DioClient {
  final Dio _dio;
  DioClient._(this._dio);

  static DioClient create() {
    final dio = Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 20),
      sendTimeout: const Duration(seconds: 20),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'X-Shopify-Storefront-Access-Token': AppEnv.storefrontToken,
      },
    ));
    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: false));
    return DioClient._(dio);
  }

  Future<Map<String, dynamic>> postGql(Map<String, dynamic> body) async {
    DioException? last;
    for (final url in AppEnv.graphqlEndpoints) {
      try {
        final r = await _dio.post(url, data: body);
        return r.data as Map<String, dynamic>;
      } on DioException catch (e) { last = e; }
    }
    throw last ?? Exception('No GraphQL endpoints configured or reachable.');
  }
}
