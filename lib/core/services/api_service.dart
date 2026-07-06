import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import '../constants/api_constants.dart';
import '../exceptions/app_exceptions.dart';
import 'storage_service.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  late Dio _dio;

  factory ApiService() {
    return _instance;
  }

  ApiService._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        headers: ApiConstants.headers,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    );

    // Token refresh interceptor — retries once with a new access token on 401
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Inject stored Bearer token if not already set
          final storage = _tryGetStorage();
          if (storage != null) {
            final token = storage.getString(StorageKeys.authToken) ?? '';
            if (token.isNotEmpty &&
                !(options.headers['Authorization'] as String? ?? '').startsWith(
                  'Bearer ',
                )) {
              options.headers['Authorization'] = 'Bearer $token';
            }
          }
          return handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401 &&
              !(error.requestOptions.extra['_retried'] as bool? ?? false)) {
            // Mark so we don't retry again
            error.requestOptions.extra['_retried'] = true;

            try {
              final newToken = await _refreshAccessToken();
              if (newToken == null) {
                _forceLogout();
              } else {
                // Retry original request with new token
                final opts = Options(
                  method: error.requestOptions.method,
                  headers: {
                    ...error.requestOptions.headers,
                    'Authorization': 'Bearer $newToken',
                  },
                  extra: error.requestOptions.extra,
                );
                final response = await _dio.request(
                  error.requestOptions.path,
                  data: error.requestOptions.data,
                  queryParameters: error.requestOptions.queryParameters,
                  options: opts,
                );
                return handler.resolve(response);
              }
            } catch (_) {
              // Refresh failed — clear session and redirect to login
              _forceLogout();
            }
          }

          // Debug logging
          assert(() {
            if (kDebugMode) {
              print(
                'ERROR[${error.response?.statusCode}] => PATH: ${error.requestOptions.path}',
              );
              print('ERROR_BODY => ${error.response?.data}');
              print('ERROR_MESSAGE => ${error.message}');
            }
            return true;
          }());

          return handler.next(error);
        },
      ),
    );

    // Logging interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          assert(() {
            if (kDebugMode) {
              print('REQUEST[${options.method}] => PATH: ${options.path}');
              print('REQUEST_BODY => ${options.data}');
              print('REQUEST_HEADERS => ${options.headers}');
            }
            return true;
          }());
          return handler.next(options);
        },
        onResponse: (response, handler) {
          assert(() {
            if (kDebugMode) {
              print(
                'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
              );
            }
            return true;
          }());
          return handler.next(response);
        },
        onError: (error, handler) {
          return handler.next(error);
        },
      ),
    );
  }

  /// Clears stored auth data and redirects to sign-in when refresh fails.
  void _forceLogout() {
    final storage = _tryGetStorage();
    if (storage != null) {
      storage.remove(StorageKeys.authToken);
      storage.remove(StorageKeys.refreshToken);
      storage.setBool(StorageKeys.isLoggedIn, false);
    }
    // Navigate to sign-in, clearing the entire back stack
    Get.offAllNamed('/sign_in_screen');
  }

  StorageService? _tryGetStorage() {
    try {
      return Get.find<StorageService>();
    } catch (_) {
      return null;
    }
  }

  /// Calls the refresh-token endpoint and stores + returns the new access token.
  /// Returns null if refresh fails.
  Future<String?> _refreshAccessToken() async {
    final storage = _tryGetStorage();
    if (storage == null) return null;

    final refreshToken = storage.getString(StorageKeys.refreshToken) ?? '';
    if (refreshToken.isEmpty) return null;

    try {
      final response = await _dio.post(
        ApiConstants.authRefreshToken,
        data: {'refreshToken': refreshToken},
        options: Options(extra: {'_retried': true}), // prevent retry loop
      );

      final body = response.data as Map<String, dynamic>;
      if (body['success'] == true) {
        final data = body['data'] as Map<String, dynamic>?;
        final accessToken = data?['accessToken'] as String?;
        final newRefresh = data?['refreshToken'] as String?;

        if (accessToken != null) {
          await storage.setString(StorageKeys.authToken, accessToken);
        }
        if (newRefresh != null) {
          await storage.setString(StorageKeys.refreshToken, newRefresh);
        }
        return accessToken;
      }
    } catch (_) {
      // Refresh endpoint itself failed
    }
    return null;
  }

  Dio get dio => _dio;

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

 
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

 
  Future<Response> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  
  Future<Response> uploadFile(
    String path, {
    required MultipartFile file,
    String fieldName = 'file',
    Map<String, dynamic>? data,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final formData = FormData.fromMap({fieldName: file, ...?data});

      return await _dio.post(
        path,
        data: formData,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  
  /// ```
  Future<Response> uploadMultipleFiles(
    String path, {
    required List<MultipartFile> files,
    String fieldName = 'files',
    Map<String, dynamic>? data,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final formData = FormData.fromMap({fieldName: files, ...?data});

      return await _dio.post(
        path,
        data: formData,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  
  Future<Response> uploadFileWithProgress(
    String path, {
    required MultipartFile file,
    String fieldName = 'file',
    Map<String, dynamic>? data,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
  }) async {
    try {
      final formData = FormData.fromMap({fieldName: file, ...?data});

      return await _dio.post(
        path,
        data: formData,
        onSendProgress: onSendProgress,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  
  AppException _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutException(error.message);

      case DioExceptionType.connectionError:
        return NoInternetException(error.message);

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = error.response?.statusMessage ?? 'Server error';
        return ServerException(message, statusCode, error.message);

      case DioExceptionType.cancel:
        return UnknownException('Request cancelled');

      case DioExceptionType.badCertificate:
        return ServerException('Bad certificate', null, error.message);

      case DioExceptionType.unknown:
        if (error.message?.contains('SocketException') ?? false) {
          return NoInternetException(error.message);
        }
        return UnknownException(error.message);
    }
  }

  void dispose() {
    _dio.close();
  }
}
