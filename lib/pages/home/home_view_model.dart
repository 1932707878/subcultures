import 'package:subcultures/api/home/index.dart' as service;
import 'package:subcultures/models/post.dart';

/// 获取帖子列表
Future<List<Post>> getPostList() async {
  List<Post> posts = [];
  List<dynamic> data = await service.getPostList();
  // item => Map<String, dynamic>
  for (var item in data) {
    item['images'] = <String>[item['image']];
    item['videos'] = <String>[];
    posts.add(Post.fromMap(item));
  }
  return posts;
}
