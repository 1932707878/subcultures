// ignore_for_file: public_member_api_docs, sort_constructors_first
class Post {
  String id = '';

  /// 昵称
  String name;

  /// 头像
  String avatar;

  /// 照片集
  List<String> imgs;

  /// 视频集
  List<String> videos;

  /// 发布时间
  String time;

  /// 是否喜欢
  bool isLike;

  Post({
    required this.id,
    required this.name,
    required this.avatar,
    required this.imgs,
    required this.videos,
    required this.time,
    required this.isLike,
  });
}
