// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:subcultures/common/constant.dart';

import 'package:subcultures/models/post.dart';
import 'package:subcultures/widgets/expandable_text.dart';
import 'package:subcultures/widgets/medias_album.dart';
import 'package:subcultures/widgets/medias_widget.dart';

// ignore: must_be_immutable
class PostCard extends StatefulWidget {
  Post data;

  PostCard({
    super.key,
    required this.data,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  /// 帖子数据
  late Post data;

  @override
  void initState() {
    super.initState();
    data = widget.data;
  }

  @override
  Widget build(BuildContext context) {
    return _getPage();
  }

  /// 页面结构
  Center _getPage() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 用户信息
          _topView(),
          // 标题和内容
          _contentView(),
          // 图片和视频
          _mediaView(),
          // 底部功能区
          _bottomFuncView(),
        ],
      ),
    );
  }

  /// 获取时间间隔
  String _getTimeAgo(String timeStr) {
    var now = DateTime.now();
    var time = DateTime.parse(timeStr);
    Duration difference = now.difference(time).abs();
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 2) {
      return 'yesterday';
    } else if (difference.inDays < 3) {
      return '2 days ago';
    } else {
      return DateFormat('MMMM d, yyyy', 'en_US').format(time);
    }
  }

  /// 打开送礼
  void showGift() {}

  /// 打开举报
  void showReport() {}

  /// 打开评论
  void showComment() {}

  /// 点击喜欢
  void like() {}

  /// 展示大图或视频
  void showMedia() {}

  /// 关注用户
  void follow() {}

  /// 跳转帖子详情
  void jumpToPostDetail() {}

  /// 跳转用户信息
  void jumpToUserInfo() {}

  /// ### 底部功能区
  ///
  /// 喜欢、评论、举报、送礼
  SizedBox _bottomFuncView() {
    const paddingValue = 10.0;
    const paddingLeftValue = 16.0;
    return SizedBox(
      height: 50,
      child: Row(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(paddingValue),
                child: Image.asset('assets/icons/home/like.png'),
              ),
              Container(
                margin: const EdgeInsets.only(left: paddingLeftValue),
                padding: const EdgeInsets.all(paddingValue),
                child: Image.asset('assets/icons/home/comment.png'),
              ),
              Container(
                margin: const EdgeInsets.only(left: paddingLeftValue),
                padding: const EdgeInsets.all(paddingValue),
                child: Image.asset('assets/icons/home/report.png'),
              ),
            ],
          ),
          const Expanded(child: SizedBox()),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    top: paddingValue, bottom: paddingValue),
                child: Image.asset('assets/icons/home/gift.png'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// ### 媒体区域
  ///
  /// 图片或视频
  Widget _mediaView() {
    if (data.medias == null || data.medias!.isEmpty) {
      return const SizedBox();
    }
    return SizedBox(
      child: MediasAlbum(mediasJson: data.medias!),
    );
  }

  /// 内容区域
  Container _contentView() {
    return Container(
      padding: const EdgeInsets.only(top: 5, bottom: 5),
      child: SizedBox(
        child: ExpandableText(
          text: data.content ?? '',
          contentStyle: const TextStyle(fontSize: 16),
          expendable: false,
        ),
      ),
    );
  }

  /// ### 顶部信息
  ///
  /// 头像、昵称、发送日期、关注
  SizedBox _topView() {
    return SizedBox(
      height: 44,
      child: Row(
        children: [
          // 头像
          SizedBox(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child:
                  Image.network(data.user?.avatar ?? DEFAULT_USER_AVATAR_URL),
            ),
          ),
          // 昵称、时间
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 5, right: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.user?.name ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    _getTimeAgo(data.createTime?.toString() ?? ''),
                    style: const TextStyle(
                      color: Color(0xffB1B5B5),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // 关注
          Center(
            child: SizedBox(
              width: 70,
              height: 24,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xff00FFD5),
                      Color(0xff0091FF),
                      Color(0xffFF76CC),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      margin: const EdgeInsets.only(right: 2),
                      child: Image.asset('assets/icons/home/add.png'),
                    ),
                    const Text(
                      'follow',
                      style: TextStyle(color: Colors.black),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
