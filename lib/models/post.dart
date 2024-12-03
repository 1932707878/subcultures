import 'dart:convert';

import 'package:subcultures/models/post_like.dart';
import 'package:subcultures/models/user.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Post {
  String? id;

  /// 用户ID
  String? uid;

  /// 标题
  String? title;

  /// 内容
  String? content;

  /// 媒体json，包括视频、图片
  String? medias;

  /// 发布用户信息
  User? user;

  /// 当前用户-点赞信息
  PostLike? cuLike;

  /// 点赞数
  int? likeCount;

  /// 评论数
  int? commentCount;

  /// 创建时间
  DateTime? createTime;

  /// 更新时间
  DateTime? updateTime;
  Post({
    this.id,
    this.uid,
    this.title,
    this.content,
    this.medias,
    this.user,
    this.likeCount,
    this.commentCount,
    this.createTime,
    this.updateTime,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'uid': uid,
      'title': title,
      'content': content,
      'medias': medias,
      'user': user?.toJson(),
      'likeCount': likeCount,
      'commentCount': commentCount,
      'createTime': createTime?.toString(),
      'updateTime': updateTime?.toString(),
    };
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id'] != null ? map['id'] as String : null,
      uid: map['uid'] != null ? map['uid'] as String : null,
      title: map['title'] != null ? map['title'] as String : null,
      content: map['content'] != null ? map['content'] as String : null,
      medias: map['medias'] != null ? map['medias'] as String : null,
      user: map['user'] != null
          ? User.fromMap(map['user'] as Map<String, dynamic>)
          : null,
      likeCount: map['likeCount'] != null ? map['likeCount'] as int : null,
      commentCount:
          map['commentCount'] != null ? map['commentCount'] as int : null,
      createTime: DateTime.parse(map['createTime']),
      updateTime: DateTime.parse(map['updateTime']),
    );
  }

  factory Post.fromJson(String source) =>
      Post.fromMap(json.decode(source) as Map<String, dynamic>);
}
