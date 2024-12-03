import 'package:get/get.dart';
import 'package:subcultures/pages/launch.dart';
import 'package:subcultures/pages/login/login.dart';
import 'package:subcultures/pages/tab_page.dart';
import 'package:subcultures/widgets/video_player.dart';

// 路由管理类
class Routes {
  static final List<GetPage> pages = [
    GetPage(
      name: RoutePath.launch,
      page: () => const LaunchPage(),
    ),
    GetPage(
      name: RoutePath.tab,
      page: () => const TabPage(),
    ),
    GetPage(
      name: RoutePath.login,
      page: () => const LoginPage(),
    ),
    GetPage(
      name: RoutePath.fullScreenVideo,
      page: () {
        final args = Get.arguments as Map<String, dynamic>;
        return FullScreenVideoPlayer(
          url: args['url'] as String,
          isPreview: args['isPreview'] as bool? ?? false,
        );
      },
    ),
  ];
}

/// 路由路径
class RoutePath {
  /// 启动页
  static const String launch = '/';

  /// 首页
  static const String tab = '/tab';

  /// 登录
  static const String login = '/login';

  /// 全屏播放视频
  static const String fullScreenVideo = '/fullScreenVideo';
}
