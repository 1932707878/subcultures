import 'package:flutter/material.dart';

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
  final List<BottomNavigationBarItem> _items = [
    BottomNavigationBarItem(
      label: '',
      icon: Image.asset(
        'assets/icons/tab/tab_home.png',
        width: 24,
        height: 24,
      ),
      // activeIcon: Image.asset('assets/icons/tab/tab_home_select.png'),
      activeIcon: Column(
        children: [
          Image.asset(
            'assets/icons/tab/tab_home_select.png',
            width: 24,
            height: 24,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: Container(
              height: 2,
              width: 10,
              color: Color(0xffC0A368),
              margin: EdgeInsets.only(top: 6),
            ),
          )
        ],
      ),
    ),
    BottomNavigationBarItem(
      label: '',
      icon: Image.asset(
        'assets/icons/tab/tab_recipe.png',
        width: 24,
        height: 24,
      ),
      activeIcon: Column(
        children: [
          Image.asset(
            'assets/icons/tab/tab_recipe_select.png',
            width: 24,
            height: 24,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: Container(
              height: 2,
              width: 10,
              color: Color(0xffC0A368),
              margin: EdgeInsets.only(top: 6),
              // decoration: BoxDecoration(color: Color(0xffC0A368)),
            ),
          )
        ],
      ),
    ),
    BottomNavigationBarItem(
      label: '',
      icon: Image.asset(
        'assets/icons/tab/tab_restaurant.png',
        width: 24,
        height: 24,
      ),
      activeIcon: Column(
        children: [
          Image.asset(
            'assets/icons/tab/tab_restaurant_select.png',
            width: 24,
            height: 24,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: Container(
              height: 2,
              width: 10,
              color: Color(0xffC0A368),
              margin: EdgeInsets.only(top: 6),
              // decoration: BoxDecoration(color: Color(0xffC0A368)),
            ),
          )
        ],
      ),
    ),
    BottomNavigationBarItem(
      label: '',
      icon: Image.asset(
        'assets/icons/tab/tab_profile.png',
        width: 24,
        height: 24,
      ),
      activeIcon: Column(
        children: [
          Image.asset(
            'assets/icons/tab/tab_profile_select.png',
            width: 24,
            height: 24,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: Container(
              height: 2,
              width: 10,
              color: Color(0xffC0A368),
              margin: EdgeInsets.only(top: 6),
              // decoration: BoxDecoration(color: Color(0xffC0A368)),
            ),
          )
        ],
      ),
    )
  ];

  @override
  void initState() {
    super.initState();
    _pages.addAll([HomePage(), RecipePage(), RestaurantPage(), ProfilePage()]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _pages[_currentIndex],
        bottomNavigationBar: SizedBox(
          height: 80,
          child: BottomNavigationBar(
            backgroundColor: const Color(0xff4E4A55),
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            selectedFontSize: 0,
            unselectedFontSize: 0,
            currentIndex: _currentIndex,
            onTap: (int index) {
              setState(() {
                _currentIndex = index;
              });
            },
            items: _items,
          ),
        ));
  }
}
