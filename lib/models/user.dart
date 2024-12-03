import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class User {
  String? id;

  /// 名字
  String? name;

  /// 头像地址
  String? avatar;

  /// 简介
  String? introduction;

  /// 邮箱
  String? email;

  /// 手机号
  String? phone;

  /// 创建时间
  DateTime? createTime;

  /// 更新时间
  DateTime? updateTime;
  User({
    this.id,
    this.name,
    this.avatar,
    this.introduction,
    this.email,
    this.phone,
    this.createTime,
    this.updateTime,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'avatar': avatar,
      'introduction': introduction,
      'email': email,
      'phone': phone,
      'createTime': createTime?.toString(),
      'updateTime': updateTime?.toString(),
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] != null ? map['id'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      avatar: map['avatar'] != null ? map['avatar'] as String : null,
      introduction:
          map['introduction'] != null ? map['introduction'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      phone: map['phone'] != null ? map['phone'] as String : null,
      createTime:
          map['createTime'] != null ? DateTime.parse(map['createTime']) : null,
      updateTime:
          map['updateTime'] != null ? DateTime.parse(map['updateTime']) : null,
    );
  }

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);
}
