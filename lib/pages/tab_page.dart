import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:subcultures/pages/chat/char_page.dart';
import 'package:subcultures/pages/home/home_page.dart';
import 'package:subcultures/pages/list/list_page.dart';
import 'package:subcultures/pages/profile/profile_page.dart';

const bottomAppBarHeight = 60.0;

class TabPage extends StatefulWidget {
  const TabPage({super.key});

  @override
  _TabPageState createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> {
  /// 当前页面下标
  int _currentIndex = 0;

  /// 页面列表
  final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _pages.addAll([HomePage(), ListPage(), ChatPage(), ProfilePage()]);
  }

  /// 点击发布
  void _showPublish() {
    log('点击发布');
  }

  // 页面切换
  void _changePage(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _pages[_currentIndex],
      ),
      bottomNavigationBar: SizedBox(
        height: bottomAppBarHeight,
        child: Stack(
          children: [
            BottomAppBar(
              color: const Color(0xff1C1C1E),
              // shape: CircularNotchedRectangle(),
              shape: CustomNotchedShape(context),
              child: Row(
                //均分底部导航栏横向空间
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.max,
                children: [
                  IconButton(
                    icon: Image.asset('assets/icons/tab/home.png'),
                    onPressed: () => _changePage(0),
                    selectedIcon:
                        Image.asset('assets/icons/tab/home_select.png'),
                    isSelected: _currentIndex == 0 ? true : false,
                  ),
                  IconButton(
                    icon: Image.asset('assets/icons/tab/list.png'),
                    onPressed: () => _changePage(1),
                    selectedIcon:
                        Image.asset('assets/icons/tab/list_select.png'),
                    isSelected: _currentIndex == 1 ? true : false,
                  ),
                  Image.asset(
                    'assets/icons/tab/publish_circular.png',
                    width: 45,
                  ), //中间位置空出
                  IconButton(
                    icon: Image.asset('assets/icons/tab/chat.png'),
                    onPressed: () => _changePage(2),
                    selectedIcon:
                        Image.asset('assets/icons/tab/chat_select.png'),
                    isSelected: _currentIndex == 2 ? true : false,
                  ),
                  IconButton(
                    icon: Image.asset('assets/icons/tab/profile.png'),
                    onPressed: () => _changePage(3),
                    selectedIcon:
                        Image.asset('assets/icons/tab/profile_select.png'),
                    isSelected: _currentIndex == 3 ? true : false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      //悬浮按钮
      //悬浮按钮位置
      // floatingActionButtonLocation: CustomFABLocation(),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class CustomNotchedShape extends NotchedShape {
  final BuildContext context;
  const CustomNotchedShape(this.context);

  @override
  Path getOuterPath(Rect host, Rect? guest) {
    const radius = 40.0;
    const lx = 20.0;
    const ly = 8;
    const bx = 10.0;
    const by = 20.0;
    var x = (MediaQuery.of(context).size.width - radius) / 2 - lx;
    return Path()
      ..moveTo(host.left, host.top)
      ..lineTo(x, host.top)
      ..quadraticBezierTo(x + bx, host.top, x += lx, host.top - ly)
      ..quadraticBezierTo(
          x + radius / 2, host.top - by, x += radius, host.top - ly)
      ..quadraticBezierTo((x += lx) - bx, host.top, x, host.top)
      ..lineTo(host.right, host.top)
      ..lineTo(host.right, host.bottom)
      ..lineTo(host.left, host.bottom);
  }
}

class CustomFABLocation extends FloatingActionButtonLocation {
  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    // (视窗宽度-按钮宽度)/2
    double fabX = scaffoldGeometry.scaffoldSize.width / 2 -
        scaffoldGeometry.floatingActionButtonSize.width / 2;
    // (视窗高度-按钮高度)/2 - 10
    double fabY = scaffoldGeometry.scaffoldSize.height -
        (scaffoldGeometry.floatingActionButtonSize.height +
                bottomAppBarHeight) /
            2 -
        10;
    return Offset(fabX, fabY);
  }
}
