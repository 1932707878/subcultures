import 'package:subcultures/utils/dio/dio_util.dart';

/// 请求对象
var request = DioUtil();

/// 获取帖子列表
Future<dynamic> getPostList() {
  return request.get('/home');
}
