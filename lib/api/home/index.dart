import 'package:subcultures/models/post.dart';
import 'package:subcultures/utils/dio/dio_util.dart';

/// 请求对象
var request = DioUtil();

/// 获取帖子列表
Future<List<Post>> getPostList() async {
  var data = await request.get('/home');

  return [];
}
