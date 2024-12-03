import 'package:subcultures/models/login.dart';
import 'package:subcultures/utils/dio/dio_util.dart';

class LoginApi {
  /// 请求对象
  static final request = DioUtil();

  /// 用户登录
  static Future<dynamic> login(LoginUser user) {
    return request.post('/login', data: user);
  }

  /// 退出登录
  static Future<dynamic> logout() {
    return request.get('/login/logout');
  }
}
