import 'package:flutter/material.dart';
import 'package:subcultures/pages/tab_page.dart';

// 路由管理类
class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      // 首页
      case RoutePath.tab:
        return pageRoute(TabPage(), settings: settings);
    }

    // 404
    return MaterialPageRoute(
        builder: (context) => Scaffold(
            body:
                Center(child: Text('No route defined for ${settings.name}'))));
  }

  static MaterialPageRoute pageRoute(
    Widget page, {
    RouteSettings? settings,
    bool? fullscreenDialog,
    bool? maintainState,
    bool? allowSnapshotting,
  }) {
    return MaterialPageRoute(
        builder: (context) => page,
        settings: settings,
        fullscreenDialog: fullscreenDialog ?? false,
        maintainState: maintainState ?? true,
        allowSnapshotting: allowSnapshotting ?? true);
  }
}

/// 路由路径
class RoutePath {
  /// 首页
  static const String tab = '/';
}
