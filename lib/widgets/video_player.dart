// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class OneHandVideoPlayer extends StatefulWidget {
  final String url;

  const OneHandVideoPlayer({
    super.key,
    required this.url,
  });

  @override
  _OneHandVideoPlayerState createState() => _OneHandVideoPlayerState();
}

class _OneHandVideoPlayerState extends State<OneHandVideoPlayer> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    // 初始化视频播放器控制器，使用网络视频或本地视频
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(widget.url),
    );
    // 本地视频
    // _controller = VideoPlayerController.asset('assets/video.mp4');

    // 初始化
    // _controller.initialize().then((_) {
    //   setState(() {});
    // });
  }

  @override
  void dispose() {
    super.dispose();
    // 释放资源
    _controller.dispose();
  }

  /// 播放视频
  void _playVideo() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenVideoPlayer(controller: _controller),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 封面图
          Image.network(
            'https://one-hand.oss-cn-hangzhou.aliyuncs.com/suncaltures/default/photo_1.jpg', // 替换为你的封面图链接
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          // 播放按钮
          IconButton(
            icon: Icon(Icons.play_circle_fill, size: 100, color: Colors.white),
            onPressed: _playVideo,
          ),
        ],
      ),
    );
  }
}

class FullScreenVideoPlayer extends StatefulWidget {
  final VideoPlayerController controller;

  const FullScreenVideoPlayer({
    super.key,
    required this.controller,
  });

  @override
  _FullScreenVideoPlayerState createState() => _FullScreenVideoPlayerState();
}

class _FullScreenVideoPlayerState extends State<FullScreenVideoPlayer> {
  @override
  void initState() {
    super.initState();
    widget.controller.initialize().then((_) {
      setState(() {});
      widget.controller.play(); // 自动播放视频
    });
  }

  /// 播放资源跟随组件销毁，不需要手动销毁
  @override
  void dispose() {
    super.dispose();
    pause();
  }

  /// 暂停播放
  void pause() {
    if (widget.controller.value.isPlaying) {
      widget.controller.pause();
    } else {
      widget.controller.play();
    }
    setState(() {});
  }

  // Navigator.pop(context);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: widget.controller.value.isInitialized
              ? AspectRatio(
                  aspectRatio: widget.controller.value.aspectRatio,
                  child: VideoPlayer(widget.controller),
                )
              : const CircularProgressIndicator(),
        ),
        Center(
          child: IconButton(
              onPressed: pause,
              icon: Icon(
                widget.controller.value.isPlaying
                    ? Icons.pause_circle
                    : Icons.play_circle,
                color: Colors.white,
              )),
        ),
      ],
    );
  }
}
