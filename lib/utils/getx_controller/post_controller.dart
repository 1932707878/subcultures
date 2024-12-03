import 'package:get/get.dart';
import 'package:subcultures/models/post.dart';

/// 帖子全局控制器
class PostController extends GetxController {
  final RxList<Post> posts = <Post>[].obs;

  /// 添加帖子列表
  void addAllPosts(List<Post> posts) {
    this.posts.addAll(posts);
    update();
  }

  /// 清空帖子列表
  void clearPosts() {
    posts.clear();
    update();
  }
}
