import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class PostLike {
  String? id;
  String? postId;

  /// 评论ID
  String? commentId;
  String? userId;

  ///  点赞类型
  ///
  /// 0=不喜欢，1=喜欢
  int? type;

  /// 点赞时间
  DateTime? createTime;
  PostLike({
    this.id,
    this.postId,
    this.commentId,
    this.userId,
    this.type,
    this.createTime,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'postId': postId,
      'commentId': commentId,
      'userId': userId,
      'type': type,
      'createTime': createTime?.toString(),
    };
  }

  factory PostLike.fromMap(Map<String, dynamic> map) {
    return PostLike(
      id: map['id'] != null ? map['id'] as String : null,
      postId: map['postId'] != null ? map['postId'] as String : null,
      commentId: map['commentId'] != null ? map['commentId'] as String : null,
      userId: map['userId'] != null ? map['userId'] as String : null,
      type: map['type'] != null ? map['type'] as int : null,
      createTime:
          map['createTime'] != null ? DateTime.parse(map['createTime']) : null,
    );
  }

  factory PostLike.fromJson(String source) =>
      PostLike.fromMap(json.decode(source) as Map<String, dynamic>);
}
