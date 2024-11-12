import 'package:flutter/material.dart';
import 'package:subcultures/models/post.dart';
import 'package:subcultures/pages/home/home_view_model.dart' as service;
import 'package:subcultures/widgets/post_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /// 帖子列表
  List<Post> datas = [];

  /// 加载数据
  void loadData() async {
    datas = await service.getPostList();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      child: ListView.builder(
        itemCount: datas.length,
        itemBuilder: (context, index) {
          return PostCard(data: datas[index]);
        },
      ),
    );
  }
}
