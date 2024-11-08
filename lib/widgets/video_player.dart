// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

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
  /// 播放器实例
  late VideoPlayerController controller;

  /// 初始化完成
  late Future<void> _initializeVideoPlayerFuture;

  /// 是否在加载
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // 初始化视频播放器控制器，使用网络视频或本地视频
    // controller = VideoPlayerController.networkUrl(Uri.parse(widget.url));
    log('video_player - 视频地址：${widget.url.toString()}');

    // 本地视频
    controller = VideoPlayerController.asset('assets/videos/video_1.mp4');
    // 初始化状态
    _initializeVideoPlayerFuture = controller.initialize();
    // 循环播放
    controller.setLooping(true);

    controller.addListener(() {
      if (controller.value.isInitialized) {
        /// 初始化完成
        setState(() {
          isLoading = false;
        });
      }
      if (controller.value.isBuffering) {
        log('video_player 视频缓冲中···');

        /// 正在缓冲
        setState(() {
          isLoading = true;
        });
      } else {
        /// 缓冲完成
        setState(() {
          isLoading = false;
        });
      }

      // 自动播放
      if (controller.value.position == Duration.zero) {
        controller.play();
      }
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
              child: FutureBuilder(
                future: _initializeVideoPlayerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return AspectRatio(
                      aspectRatio: controller.value.aspectRatio,
                      child: VideoPlayer(controller),
                    );
                  } else {
                    return const CircularProgressIndicator(color: Colors.white);
                  }
                },
              ),
            ),
            // 缓冲交互
            if (isLoading) const CircularProgressIndicator(color: Colors.white),
            _funcView(context),
          ],
        ),
      ),
    );
  }

  /// 功能区
  Stack _funcView(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: GestureDetector(
            onDoubleTap: () => pause(),
          ),
        ),
        if (!isLoading && !controller.value.isPlaying)
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
          child: Row(
            children: [
              const SizedBox(
                child: Icon(
                  Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: 40,
                ),
              ),
              _progressBar(context),
            ],
          ),
        )
      ],
    );
  }

  /// 进度条
  Expanded _progressBar(BuildContext context) {
    return Expanded(
      child: SliderTheme(
        data: SliderThemeData(
          // 轨道
          inactiveTrackColor: Colors.red,
          activeTrackColor: Colors.white,
          disabledActiveTrackColor: Colors.grey,
          // 滑块形状
          thumbShape: RectangularSliderThumbShape(),
          trackShape: CustomSliderTrackShape(),
        ),
        child: Slider(
          activeColor: const Color.fromARGB(255, 248, 248, 249),
          inactiveColor: Colors.grey,
          thumbColor: const Color.fromARGB(255, 222, 232, 240),
          value: controller.value.position.inSeconds.toDouble(),
          min: 0.0,
          max: controller.value.duration.inSeconds.toDouble(),
          onChanged: (double position) {
            setState(() {
              controller.seekTo(Duration(seconds: position.toInt()));
            });
          },
        ),
      ),
    );
  }
}

// 自定义长方形滑块
class RectangularSliderThumbShape extends SliderComponentShape {
  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return const Size(12, 8); // 设置长方形滑块的大小
  }

  @override
  void paint(PaintingContext context, Offset center,
      {required Animation<double> activationAnimation,
      required Animation<double> enableAnimation,
      required bool isDiscrete,
      required TextPainter labelPainter,
      required RenderBox parentBox,
      required SliderThemeData sliderTheme,
      required TextDirection textDirection,
      required double value,
      required double textScaleFactor,
      required Size sizeWithOverflow}) {
    final Paint paint = Paint()..color = sliderTheme.thumbColor!;
    final Rect rect = Rect.fromCenter(center: center, width: 12, height: 8);
    final RRect roundedRect =
        RRect.fromRectAndRadius(rect, const Radius.circular(3));
    context.canvas.drawRRect(roundedRect, paint);
  }
}

/// 自定义长方形轨道
class CustomSliderTrackShape extends SliderTrackShape {
  final trackHeight = 2.0;

  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackLeft = offset.dx;
    final double trackTop = offset.dy +
        (parentBox.size.height - (sliderTheme.trackHeight ?? trackHeight)) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth,
        (sliderTheme.trackHeight ?? trackHeight));
  }

  @override
  void paint(PaintingContext context, Offset offset,
      {required RenderBox parentBox,
      required SliderThemeData sliderTheme,
      required Animation<double> enableAnimation,
      required Offset thumbCenter,
      Offset? secondaryOffset,
      bool isEnabled = false,
      bool isDiscrete = false,
      required TextDirection textDirection}) {
    final canvas = context.canvas;
    final trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );

    // 绘制播放进度条
    final progressRect = Rect.fromLTWH(
      trackRect.left,
      trackRect.top,
      thumbCenter.dx - trackRect.left,
      trackRect.height,
    );
    final progressPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;
    canvas.drawRect(progressRect, progressPaint);

    // 绘制剩余进度条
    final remainingRect = Rect.fromLTWH(
      thumbCenter.dx,
      trackRect.top,
      trackRect.right - thumbCenter.dx,
      trackRect.height,
    );
    final remainingPaint = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.fill;
    canvas.drawRect(remainingRect, remainingPaint);
  }
}
