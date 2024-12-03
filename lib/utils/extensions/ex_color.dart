import 'package:flutter/material.dart';

/// Color扩展类
extension ColorEx on Color {
  /// 使用16进制颜色
  ///
  /// ```dart
  /// Color.hexColor('#00FFd5') // Color(0xff00FFD5)
  /// Color.hexColor('00Ffd5') // Color(0xff00FFD5)
  /// ```
  static Color hexColor(String hexString) {
    hexString = hexString.toUpperCase().replaceAll('#', '');
    if (hexString.length <= 6) {
      hexString = 'FF$hexString';
    }
    return Color(int.parse('0x$hexString'));
  }

  String bb() {
    return '';
  }
}
