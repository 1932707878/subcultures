import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:subcultures/api/home/index.dart';
import 'package:subcultures/models/post.dart';
import 'package:subcultures/widgets/expandable_text.dart' as service;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /// 帖子列表
  List<Post> posts = [];

  // TODO: 接口
  /// 接口服务
  var service = service.getPostList();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      child: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {},
      ),
    );
  }
}
