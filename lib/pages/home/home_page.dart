import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:subcultures/utils/getx_controller/post_controller.dart';
import 'package:subcultures/pages/home/home_view_model.dart';
import 'package:subcultures/widgets/post_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /// 帖子控制器
  final PostController postController = Get.find<PostController>();

  /// 滚动控制器
  final ScrollController _scrollController = ScrollController();

  /// 是否正在加载更多
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    log('HomePage --> initState');

    // 初始化数据
    HomeViewModel.loadData();

    // 监听滚动
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 50) {
        _loadMore();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      child: RefreshIndicator(
        onRefresh: _onRefresh,
        child: Obx(
          () => ListView.separated(
            controller: _scrollController,
            itemCount: postController.posts.length + 1, // +1 为了显示加载更多
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              if (index == postController.posts.length) {
                // 最后一项显示加载更多
                return _buildLoadMoreIndicator();
              }
              return PostCard(data: postController.posts[index]);
            },
          ),
        ),
      ),
    );
  }

  /// 下拉刷新
  Future<void> _onRefresh() async {
    HomeViewModel.loadData();
  }

  /// 加载更多
  Future<void> _loadMore() async {
    if (_isLoadingMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    try {
      HomeViewModel.loadData(loadMore: true);
    } finally {
      setState(() {
        _isLoadingMore = false;
      });
    }
  }

  /// 构建加载更多指示器
  Widget _buildLoadMoreIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_isLoadingMore)
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            ),
          if (_isLoadingMore)
            Container(
              margin: const EdgeInsets.only(left: 8),
              child: const Text(
                'Loading more...',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
