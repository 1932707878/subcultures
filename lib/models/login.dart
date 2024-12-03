import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
/// 登录用户类
class LoginUser {
  String? id;

  /// 用户名
  String? username;

  /// 邮箱
  String? email;

  /// 手机号
  String? phone;

  /// 密码
  String? password;

  LoginUser({
    this.id,
    this.username,
    this.email,
    this.phone,
    this.password,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'username': username,
      'email': email,
      'phone': phone,
      'password': password,
    };
  }

  factory LoginUser.fromMap(Map<String, dynamic> map) {
    return LoginUser(
      id: map['id'] != null ? map['id'] as String : null,
      username: map['username'] != null ? map['username'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      phone: map['phone'] != null ? map['phone'] as String : null,
      password: map['password'] != null ? map['password'] as String : null,
    );
  }

  factory LoginUser.fromJson(String source) =>
      LoginUser.fromMap(json.decode(source) as Map<String, dynamic>);
}
