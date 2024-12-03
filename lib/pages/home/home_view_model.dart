import 'package:get/get.dart';
import 'package:subcultures/api/post_api.dart';
import 'package:subcultures/utils/getx_controller/post_controller.dart';
import 'package:subcultures/models/post.dart';

class HomeViewModel {
  static final PostController postController = Get.find<PostController>();

  /// 页码
  static int pageNo = 1;

  /// 每页条数
  static int pageSize = 10;

  /// 加载帖子列表
  static void loadData({bool loadMore = false}) async {
    pageNo++;
    if (!loadMore) {
      // 重置页码
      pageNo = 1;
    }
    var datas = await PostApi.getPostList(pageNo: pageNo, pageSize: pageSize);

    /// 清空列表
    if (!loadMore) {
      postController.clearPosts();
    }
    convertData(datas);
  }

  /// 转化数据
  static void convertData(List<dynamic> datas) {
    postController.addAllPosts(datas.map((e) => Post.fromMap(e)).toList());
  }
}
