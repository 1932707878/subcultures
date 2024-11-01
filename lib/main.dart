import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:subcultures/app.dart';

void main() {
  // 状态栏和底部导航栏颜色
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Color(0xff171C28),
      systemNavigationBarColor: Color(0xff1C1C1E),
    ),
  );
  runApp(const Subcultures());
}
