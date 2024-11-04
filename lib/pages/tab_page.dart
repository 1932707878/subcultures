import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:subcultures/pages/chat/char_page.dart';
import 'package:subcultures/pages/home/home_page.dart';
import 'package:subcultures/pages/list/list_page.dart';
import 'package:subcultures/pages/profile/profile_page.dart';

/// 导航图标大小
const navIconSize = 36.0;

class TabPage extends StatefulWidget {
  const TabPage({super.key});

  @override
  _TabPageState createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> {
  /// 当前页面下标
  var _currentIndex = 0;

  /// 页面列表
  final List<Widget> _pages = [];

  /// 图标集
  final List<BottomNavigationBarItem> _items = [
    BottomNavigationBarItem(
      label: '',
      icon: Image.asset('assets/icons/tab/home.png',
          width: navIconSize, height: navIconSize),
      activeIcon: Image.asset('assets/icons/tab/home_select.png',
          width: navIconSize, height: navIconSize),
    ),
    BottomNavigationBarItem(
      label: '',
      icon: Image.asset('assets/icons/tab/list.png',
          width: navIconSize, height: navIconSize),
      activeIcon: Image.asset('assets/icons/tab/list_select.png',
          width: navIconSize, height: navIconSize),
    ),
    BottomNavigationBarItem(
      label: '',
      icon: Image.asset('assets/icons/tab/publish.png',
          width: navIconSize, height: navIconSize),
      activeIcon: Image.asset('assets/icons/tab/publish.png',
          width: navIconSize, height: navIconSize),
    ),
    BottomNavigationBarItem(
      label: '',
      icon: Image.asset('assets/icons/tab/chat.png',
          width: navIconSize, height: navIconSize),
      activeIcon: Image.asset('assets/icons/tab/chat_select.png',
          width: navIconSize, height: navIconSize),
    ),
    BottomNavigationBarItem(
      label: '',
      icon: Image.asset('assets/icons/tab/profile.png',
          width: navIconSize, height: navIconSize),
      activeIcon: Image.asset('assets/icons/tab/profile_select.png',
          width: navIconSize, height: navIconSize),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pages.addAll([
      const HomePage(),
      const ListPage(),
      Container(),
      const ChatPage(),
      const ProfilePage()
    ]);
  }

  /// 点击发布
  void _showPublish() {
    log('点击发布');
  }

  /// 页面改变
  void _changePage(int index) {
    if (index == 2) {
      return;
    }
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xff1C1C1E),
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedFontSize: 0,
        unselectedFontSize: 0,
        currentIndex: _currentIndex,
        items: _items,
        onTap: (int index) => _changePage(index),
      ),
    );
  }
}
