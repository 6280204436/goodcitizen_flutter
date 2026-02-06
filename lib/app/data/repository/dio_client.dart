import 'package:dio/io.dart';

import '../../export.dart';

const _defaultConnectTimeout =
Duration(milliseconds: Duration.millisecondsPerMinute);
const _defaultReceiveTimeout =
Duration(milliseconds: Duration.millisecondsPerMinute);

setContentType() {
  return "application/json";
}

class DioClient {
  String baseUrl;

  static late Dio _dio;

  final List<Interceptor>? interceptors;

  DioClient(
      this.baseUrl,
      Dio dio, {
        this.interceptors,
      }) {
    _dio = dio;
    _dio
      ..options.baseUrl = baseUrl
      ..options.connectTimeout = _defaultConnectTimeout
      ..options.receiveTimeout = _defaultReceiveTimeout
      ..httpClientAdapter
      ..options.contentType = setContentType()
      ..options.headers = {
        'Content-Type': setContentType(),
      };

    if (interceptors?.isNotEmpty ?? false) {
      _dio.interceptors.addAll(interceptors!);
    }

    (_dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      HttpClient dioClient = HttpClient();
      dioClient.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return dioClient;
    };

    if (kDebugMode) {
      _dio.interceptors.add(LogInterceptor(
          responseBody: true,
          error: true,
          requestHeader: true,
          responseHeader: false,
          request: false,
          requestBody: true));
    }
  }

  Future<dynamic> get(String uri,
      {Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onReceiveProgress,
        bool? skipAuth}) async {
    try {
      if (skipAuth == false) {
        var token = preferenceManager.getAuthToken();
        debugPrint("token $token");
        if (token != null) {
          options = Options(headers: {
            "Authorization": "Bearer $token",
            "language": getLanguageCode
          });
        } else {
          options = Options(headers: {"language": getLanguageCode});
        }
      }

      var response = await _dio.get(
        uri,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response.data;
    } on SocketException catch (e) {
      throw SocketException(e.toString());
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> post(String uri,
      {data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onSendProgress,
        ProgressCallback? onReceiveProgress,
        Duration? timeOut,
        bool? isLoading = true,
        bool? skipAuth}) async {
    FocusManager.instance.primaryFocus?.unfocus();
    try {
      var token = preferenceManager.getAuthToken();
      debugPrint("token $token");
      if (token != null) {
        options = options ??
            Options(sendTimeout: timeOut, receiveTimeout: timeOut, headers: {
              "Authorization": "Bearer $token",
              "language": getLanguageCode
            });
      } else {
        options = Options(headers: {"language": getLanguageCode});
      }
      if (skipAuth == false && token == null) {
        Get.toNamed(AppRoutes.signUpLoginRoute);
        return;
      } else {
        if (isLoading == true) {
          customLoader.show(Get.context);
        }
        var response = await _dio.post(
          uri,
          data: data,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress,
        );
        if (isLoading == true) {
          customLoader.hide();
        }
        return response.data;
      }
    } on FormatException catch (_) {
      if (isLoading == true) {
        customLoader.hide();
      }
      throw const FormatException("Unable to process the data");
    } catch (e) {
      if (isLoading == true) {
        customLoader.hide();
      }
      rethrow;
    }
  }

  Future<dynamic> put(String uri,
      {data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onSendProgress,
        ProgressCallback? onReceiveProgress,
        bool? isLoading = true,
        bool? skipAuth}) async {
    try {
      FocusManager.instance.primaryFocus?.unfocus();
      var token = preferenceManager.getAuthToken();
      debugPrint("token $token");
      if (token != null) {
        options = Options(headers: {
          "Authorization": "Bearer $token",
          "language": getLanguageCode
        });
      } else {
        options = Options(headers: {"language": getLanguageCode});
      }
      if (skipAuth == false && token == null) {
        Get.toNamed(AppRoutes.signUpLoginRoute);
        return;
      }

      if (isLoading == true) {
        customLoader.show(Get.context);
      }
      var response = await _dio.put(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      if (isLoading == true) {
        customLoader.hide();
      }
      return response.data;
    } on FormatException catch (_) {
      if (isLoading == true) {
        customLoader.hide();
      }
      throw const FormatException("Unable to process the data");
    } catch (e) {
      if (isLoading == true) {
        customLoader.hide();
      }
      rethrow;
    }
  }

  Future<dynamic> patch(String uri,
      {data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onSendProgress,
        ProgressCallback? onReceiveProgress,
        bool? isLoading = true,
        bool? skipAuth}) async {
    try {
      FocusManager.instance.primaryFocus?.unfocus();
      var token = preferenceManager.getAuthToken();
      debugPrint("token $token");
      if (token != null) {
        options = Options(headers: {
          "Authorization": "Bearer $token",
          "language": getLanguageCode
        });
      } else {
        options = Options(headers: {"language": getLanguageCode});
      }
      if (skipAuth == false && token == null) {
        Get.toNamed(AppRoutes.signUpLoginRoute);
        return;
      }

      if (isLoading == true) {
        customLoader.show(Get.context);
      }
      var response = await _dio.patch(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      if (isLoading == true) {
        customLoader.hide();
      }
      return response.data;
    } on FormatException catch (_) {
      if (isLoading == true) {
        customLoader.hide();
      }
      throw const FormatException("Unable to process the data");
    } catch (e) {
      if (isLoading == true) {
        customLoader.hide();
      }
      rethrow;
    }
  }

  Future<dynamic> delete(String uri,
      {data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onSendProgress,
        ProgressCallback? onReceiveProgress,
        bool? isLoading = true,
        bool? skipAuth}) async {
    try {
      FocusManager.instance.primaryFocus?.unfocus();
      var token = preferenceManager.getAuthToken();
      debugPrint("token $token");
      if (token != null) {
        options = Options(headers: {
          "Authorization": "Bearer $token",
          "language": getLanguageCode
        });
      } else {
        options = Options(headers: {"language": getLanguageCode});
      }
      if (skipAuth == false && token == null) {
        Get.toNamed(AppRoutes.signUpLoginRoute);
        return;
      }

      if (isLoading == true) {
        customLoader.show(Get.context);
      }
      var response = await _dio.delete(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      if (isLoading == true) {
        customLoader.hide();
      }
      return response.data;
    } on FormatException catch (_) {
      if (isLoading == true) {
        customLoader.hide();
      }
      throw const FormatException("Unable to process the data");
    } catch (e) {
      if (isLoading == true) {
        customLoader.hide();
      }
      rethrow;
    }
  }
}


String? get getLanguageCode {
  final locale = selectedLanguage.value.title??"";
  return locale;
}
