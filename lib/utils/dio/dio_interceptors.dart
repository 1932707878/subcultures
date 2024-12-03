import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:get/get.dart' as Get;
import 'package:subcultures/utils/log/log_service.dart';
import 'package:subcultures/routes/page_controller.dart';
import 'package:subcultures/utils/dio/dio_error_msg_model.dart';
import 'package:subcultures/utils/dio/dio_util.dart';
import 'package:subcultures/utils/storage/token_storage.dart';

/// 自定义拦截器
class CustomInterceptors extends Interceptor {
  /// 请求拦截
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    // http header 头加入 Authorization
    final token = await TokenStorage.instance.getAccessToken();
    options.headers['Authorization'] = token;

    handler.next(options);
  }

  /// 响应拦截
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // 200 请求成功
    if (response.statusCode != 200 || response.data['code'] != 200) {
      handler.reject(
        DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        ),
        true,
      );
    } else {
      // 截取response.data
      response.data = response.data['data'];
      handler.next(response);
    }
  }

  // // 退出并重新登录
  // Future<void> _errorNoAuthLogout() async {
  //   await UserService.to.logout();
  //   IMService.to.logout();
  //   Get.toNamed(RouteNames.systemLogin);
  // }

  /// 错误拦截
  @override
  Future<void> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    switch (err.type) {
      // 网络连接错误
      case DioExceptionType.connectionError:
        Log.error('dio_interceptors --> 网络连接错误');
        Get.Get.snackbar(
          'Connection Error',
          'Disconnect from the server',
          backgroundColor: const Color(0xFFFF3B30),
          colorText: const Color(0xFFFFFFFF),
          snackPosition: Get.SnackPosition.TOP,
          duration: const Duration(seconds: 3),
        );
        break;
      // 自定义错误体处理
      case DioExceptionType.badResponse:
        {
          final response = err.response;
          final errorMessage = ErrorMessageModel.fromJson(response?.data);
          final code = response!.data['code'];
          switch (code) {
            case 401:
              Log.error(errorMessage.message ?? '401 未登录');
              TokenStorage.instance.clearToken();
              PPC.toLaunch();
              break;
            case 404:
              break;
            case 500:
              break;
            case 502:
              break;
            default:
              break;
          }
        }
        break;
      case DioExceptionType.unknown:
        Log.error('未知错误');
        break;
      case DioExceptionType.cancel:
        Log.error('取消请求');
        break;
      case DioExceptionType.connectionTimeout:
        Log.error('连接超时');
        break;
      default:
        break;
    }
  }

  void _refreshToken(DioException err, ErrorInterceptorHandler handler) async {
    // 创建新Dio实例，避免循环引用
    final dio = Dio();
    // 刷新令牌地址
    const path = BASE_URL + REFRESH_TOKEN_URL;
    try {
      String refreshToken = await TokenStorage.instance.getRefreshToken();
      final resp = await dio.post(
        path,
        data: {'refreshToken': refreshToken},
      );
      Log.info('刷新令牌');
      // 更新访问令牌和刷新令牌
      final accessToken = resp.data['accessToken'] as String;
      TokenStorage.instance
          .setToken(resp.data['accessToken'], resp.data['refreshToken']);
      // 重试原请求
      final opts = err.requestOptions;
      opts.headers['Authorization'] = 'Bearer $accessToken';
      final cloneReq = await dio.fetch(opts);
      return handler.resolve(cloneReq);
    } catch (e) {
      Log.error('刷新令牌出错！');
      Log.error(e.toString());
    }
  }
}
