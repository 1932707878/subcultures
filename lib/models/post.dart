import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Post {
  String id;

  /// 昵称
  String name;

  /// 头像
  String avatar;

  /// 照片集
  List<String> images;

  /// 视频集
  List<String> videos;

  /// 发布时间
  String time;

  /// 介绍
  String introduction;

  Post({
    required this.id,
    required this.name,
    required this.avatar,
    required this.images,
    required this.videos,
    required this.time,
    required this.introduction,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'avatar': avatar,
      'images': images,
      'videos': videos,
      'time': time,
      'introduction': introduction,
    };
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id'] as String,
      name: map['name'] as String,
      avatar: map['avatar'] as String,
      images: List<String>.from((map['images'] as List<String>)),
      videos: List<String>.from((map['videos'] as List<String>)),
      time: map['time'] as String,
      introduction: map['introduction'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Post.fromJson(String source) =>
      Post.fromMap(json.decode(source) as Map<String, dynamic>);
}
