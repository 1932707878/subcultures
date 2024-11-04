import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:subcultures/models/post.dart';
import 'package:subcultures/widgets/expandable_text.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /// 帖子数据
  Post data = Post(
    id: '1',
    name: 'Dopamine',
    avatar:
        'https://one-hand.oss-cn-hangzhou.aliyuncs.com/suncaltures/default/1.png',
    imgs: [
      'https://one-hand.oss-cn-hangzhou.aliyuncs.com/suncaltures/default/photo_1.jpg'
    ],
    videos: [
      'https://one-hand.oss-cn-hangzhou.aliyuncs.com/suncaltures/default/video_1.mp4'
    ],
    time: '2024-11-03 15:24:00',
    isLike: false,
  );

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

  @override
  Widget build(BuildContext context) {
    return _getPage();
  }

  /// 页面结构
  Center _getPage() {
    return Center(
      child: SizedBox(
        height: 380,
        child: Column(
          children: [
            // 用户信息
            _topView(),
            // 标题和内容
            Container(
              padding: EdgeInsets.only(top: 5, bottom: 5),
              child: SizedBox(
                child: ExpandableText(
                  text: 'data ' * 50,
                  contentStyle: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            // 图片和视频
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: NetworkImage(data.imgs[0]),
                  fit: BoxFit.cover,
                ),
              ),
              height: 200,
              width: double.infinity,
            ),
            // 底部功能区
            SizedBox(
              height: 22,
            )
          ],
        ),
      ),
    );
  }

  /// 顶部信息-用户信息
  SizedBox _topView() {
    return SizedBox(
      height: 44,
      child: Row(
        children: [
          // 头像
          SizedBox(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: Image.network(data.avatar),
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
                    data.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    _getTimeAgo(data.time),
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
