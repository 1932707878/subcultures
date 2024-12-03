import 'package:get/get.dart';
import 'package:subcultures/routes/routes.dart';

/// 页面控制器
///
/// PPC=Project Page Controller
class PPC {
  /// 首页
  static void toHome() {
    Get.toNamed(RoutePath.tab);
  }

  /// 启动页面
  static void toLaunch() {
    Get.offAllNamed(RoutePath.launch);
  }

  /// 登录页面
  static void toLogin() {
    Get.toNamed(RoutePath.login);
  }

  /// 全屏播放视频
  static void toFullScreenVideo(String url, bool isPreview) {
    Get.toNamed(RoutePath.fullScreenVideo, arguments: {
      'url': url,
      'isPreview': isPreview,
    });
  }

  /// 返回上一页
  static void back() {
    Get.back();
  }
}
