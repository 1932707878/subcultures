import 'package:subcultures/models/post.dart';
import 'package:subcultures/utils/dio/dio_util.dart';

class PostApi {
  /// 请求对象
  static final request = DioUtil();

  /// 获取帖子列表
  static Future<dynamic> getPostList({int pageNo = 1, int pageSize = 10}) {
    return request.get('/post/post_vo/page/login_uid/$pageNo/$pageSize');
  }

  /// 发布帖子
  static Future<dynamic> publishPost(Post post) {
    return request.post('/post/publish', data: post);
  }
}
