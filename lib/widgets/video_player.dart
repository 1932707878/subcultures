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
  /// 播放视频
  void _playVideo() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenVideoPlayer(url: widget.url),
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
            icon: const Icon(
              Icons.play_circle_fill,
              size: 36,
              color: Colors.white,
            ),
            onPressed: _playVideo,
          ),
        ],
      ),
    );
  }
}

/// 全屏播放视频组件
class FullScreenVideoPlayer extends StatefulWidget {
  final String url;

  const FullScreenVideoPlayer({
    super.key,
    required this.url,
  });

  @override
  _FullScreenVideoPlayerState createState() => _FullScreenVideoPlayerState();
}

class _FullScreenVideoPlayerState extends State<FullScreenVideoPlayer> {
  late VideoPlayerController controller;

  /// 是否在加载
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // 初始化视频播放器控制器，使用网络视频或本地视频
    controller = VideoPlayerController.networkUrl(Uri.parse(widget.url));

    // 本地视频
    // _controller = VideoPlayerController.asset('assets/video.mp4');

    controller.addListener(() {
      if (controller.value.isInitialized) {
        /// 初始化完成
        setState(() {
          isLoading = false;
        });
      }
      if (controller.value.isBuffering) {
        /// 正在缓冲
        setState(() {
          isLoading = true;
        });
      } else {
        /// 缓冲完成
        setState(() {
          isLoading = false;
        });

        // 自动播放
        // controller.play();
      }
    });

    /// 视频初始化
    controller.initialize().then((_) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  /// 暂停播放
  void pause() {
    if (controller.value.isPlaying) {
      controller.pause();
    } else {
      controller.play();
    }
    setState(() {});
  }

  // Navigator.pop(context);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            const SizedBox(
              width: double.infinity,
              height: double.infinity,
            ),
            Center(
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : controller.value.isInitialized
                      ? AspectRatio(
                          aspectRatio: controller.value.aspectRatio,
                          child: VideoPlayer(controller),
                        )
                      : const Text(
                          'Video not initialized!',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
            ),
            Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: GestureDetector(
                    onDoubleTap: () => pause(),
                  ),
                ),
                if (!controller.value.isPlaying)
                  const Center(
                    child: Icon(
                      Icons.play_arrow,
                      size: 60,
                      color: Color.fromARGB(100, 255, 255, 255),
                    ),
                  ),
                Positioned(
                  top: 5,
                  left: 5,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 40,
                  left: 0,
                  right: 0,
                  child: Slider(
                    value: controller.value.position.inSeconds.toDouble(),
                    min: 0.0,
                    max: controller.value.duration.inSeconds.toDouble(),
                    onChanged: (double position) {
                      setState(() {
                        controller.seekTo(Duration(seconds: position.toInt()));
                      });
                    },
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
