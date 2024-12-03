import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:subcultures/utils/dio/dio_interceptors.dart';

const String APPLICATION_JSON = 'application/json';
const String CONTENT_TYPE = 'content-type';
const String ACCEPT = 'accept';
const String AUTHORIZATION = 'authorization';
const String DEFAULT_LANGUAGE = 'en';
const String TOKEN = 'Bearer token';
const String BASE_URL = 'http://192.168.0.101:8080/api/v1';
// const String BASE_URL = 'https://6731c0cf7aaf2a9aff11df78.mockapi.io/api/v1';
const String ACCESS_TOKEN_URL = '/token';
const String REFRESH_TOKEN_URL = '/refresh_token';

/// Dio工具类
class DioUtil {
  static final DioUtil instance = DioUtil._init();
  factory DioUtil() => instance;

  late Dio _dio;

  /// 私有构造
  DioUtil._init() {
    Map<String, String> headers = {
      CONTENT_TYPE: APPLICATION_JSON,
      ACCEPT: APPLICATION_JSON,
      // AUTHORIZATION: TOKEN,
    };

    // 初始化
    var options = BaseOptions(
      baseUrl: BASE_URL,
      headers: headers,
      connectTimeout: const Duration(seconds: 6),
      receiveTimeout: const Duration(seconds: 6),
      responseType: ResponseType.json,
    );
    _dio = Dio(options);

    // 拦截器 - 日志打印
    _dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
    ));
    // 自定义拦截器
    _dio.interceptors.add(CustomInterceptors());
  }

  /// get 请求
  Future<dynamic> get(
    String url, {
    Map<String, dynamic>? params,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    Options requestOptions = options ?? Options();
    Response response = await _dio.get(
      url,
      queryParameters: params,
      options: requestOptions,
      cancelToken: cancelToken,
    );
    // 提取Data
    return response.data;
  }

  /// post 请求
  Future<dynamic> post(
    String url, {
    dynamic data,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    var requestOptions = options ?? Options();
    Response response = await _dio.post(
      url,
      data: data ?? {},
      options: requestOptions,
      cancelToken: cancelToken,
    );
    return response.data;
  }

  /// put 请求
  Future<dynamic> put(
    String url, {
    dynamic data,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    var requestOptions = options ?? Options();
    Response response = await _dio.put(
      url,
      data: data ?? {},
      options: requestOptions,
      cancelToken: cancelToken,
    );
    return response.data;
  }

  /// delete 请求
  Future<dynamic> delete(
    String url, {
    dynamic data,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    var requestOptions = options ?? Options();
    Response response = await _dio.delete(
      url,
      data: data ?? {},
      options: requestOptions,
      cancelToken: cancelToken,
    );
    return response.data;
  }
}
