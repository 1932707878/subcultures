import 'package:flutter/material.dart';
import 'package:subcultures/pages/chat/char_page.dart';
import 'package:subcultures/pages/home/home_page.dart';
import 'package:subcultures/pages/list/list_page.dart';
import 'package:subcultures/pages/profile/profile_page.dart';

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

  /// 导航项列表
  final List<BottomNavigationBarItem> _items = [];

  @override
  void initState() {
    super.initState();
    _pages.addAll([HomePage(), ListPage(), ChatPage(), ProfilePage()]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _pages[_currentIndex],
        bottomNavigationBar: SizedBox(
            height: 80,
            child: BottomAppBar(
              color: Colors.white,
              shape: CircularNotchedRectangle(),
              child: Row(
                children: [],
              ),
            )));
  }
}
