// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:subcultures/routes/page_controller.dart';
import 'package:subcultures/utils/log/logController.dart';
import 'package:video_player/video_player.dart';

class OneHandVideoPlayer extends StatefulWidget {
  /// 视频地址
  final String url;

  /// 是否为预览视频
  final bool isPreview;

  /// 封面图
  final String? coverUrl;

  const OneHandVideoPlayer({
    super.key,
    required this.url,
    this.isPreview = false,
    this.coverUrl,
  });

  @override
  _OneHandVideoPlayerState createState() => _OneHandVideoPlayerState();
}

class _OneHandVideoPlayerState extends State<OneHandVideoPlayer> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  Future<void> _initializeController() async {
    _controller = widget.isPreview
        ? VideoPlayerController.file(File(widget.url))
        : VideoPlayerController.networkUrl(Uri.parse(widget.url));

    try {
      await _controller.initialize();
      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      Log.error('视频初始化失败', e);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// 播放视频
  void _playVideo() {
    PPC.toFullScreenVideo(widget.url, widget.isPreview);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 封面图
          if (widget.coverUrl != null)
            Image.network(
              widget.coverUrl!,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              errorBuilder: (context, error, stackTrace) {
                Log.error('加载视频封面失败', error, stackTrace);
                return Container(color: Colors.black);
              },
            )
          else if (_isInitialized)
            VideoPlayer(_controller)
          else
            Container(color: Colors.black),

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
  final bool isPreview;

  const FullScreenVideoPlayer({
    super.key,
    required this.url,
    this.isPreview = false,
  });

  @override
  _FullScreenVideoPlayerState createState() => _FullScreenVideoPlayerState();
}

class _FullScreenVideoPlayerState extends State<FullScreenVideoPlayer> {
  /// 播放器实例
  late VideoPlayerController controller;

  /// 初始屏幕状态
  late final Orientation _orientation;

  /// 当前屏幕状态
  late Orientation _currentOrientation;

  /// 初始屏幕状态辅助变量
  var hasOrientation = false;

  /// 初始化完成
  late Future<void> _initializeVideoPlayerFuture;

  /// 是否在加载
  bool isLoading = true;

  /// 视频倍速
  List<double> speeds = [3.0, 2.0, 1.0, 0.75, 0.5];

  /// 界面设置控制器
  MenuController settingController = MenuController();

  /// 显隐功能区定时器
  Timer? showFuncViewTimer;

  /// 显隐功能区状态
  bool isShowFuncView = true;

  /// 播放进度(0.0 ~ 1.0)
  double _progress = 0.0;

  /// 是否正在滑动进度
  bool _isDragging = false;

  /// 滑动前的播放状态
  bool _wasPlayingBeforeDrag = false;

  @override
  void initState() {
    super.initState();

    Log.info('video_player - 视频地址：${widget.url.toString()}');
    // 初始化视频播放器控制器，使用网络视频或手机预览视频
    controller = widget.isPreview
        ? VideoPlayerController.file(File(widget.url))
        : VideoPlayerController.networkUrl(Uri.parse(widget.url));
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
    });

    // 自动播放
    if (controller.value.position == Duration.zero) {
      controller.play();
      // 初始化定时器
      updateFuncViewTimer();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 记录屏幕状态
    if (!hasOrientation) {
      _orientation = MediaQuery.of(context).orientation;
      hasOrientation = true;
    }
    _currentOrientation = MediaQuery.of(context).orientation;
  }

  @override
  void dispose() {
    // 取消定时器
    showFuncViewTimer?.cancel();
    // 释放控制器
    controller.dispose();
    super.dispose();
  }

  /// 开始暂停播放
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
  SizedBox _funcView(BuildContext context) {
    return SizedBox(
      child: Stack(
        children: [
          // 手势区
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: GestureDetector(
              onTap: () => showHideFuncView(),
              onDoubleTap: () => pause(),
              onHorizontalDragUpdate: slideProgress,
              onHorizontalDragEnd: onDragEnd,
            ),
          ),
          // 内容区
          if (isShowFuncView)
            Stack(
              children: [
                if (!isLoading && !controller.value.isPlaying)
                  // 居中暂停
                  const Center(
                    child: Icon(
                      Icons.play_arrow_rounded,
                      size: 60,
                      color: Color.fromARGB(100, 255, 255, 255),
                    ),
                  ),
                // 返回
                Positioned(
                  top: 5,
                  left: 5,
                  child: GestureDetector(
                    onTap: () => back(),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),
                ),
                // 底部功能区
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Row(
                    children: [
                      // 左下暂停
                      _bottomLeftBtn(),
                      // 进度条
                      _progressBar(context),
                      // 设置
                      _settings(),
                      // 切换横竖屏
                      _changeOritation()
                    ],
                  ),
                )
              ],
            ),
        ],
      ),
    );
  }

  /// 全屏滑动进度
  void slideProgress(DragUpdateDetails details) {
    if (!mounted) return; // 添加检查
    if (!_isDragging) {
      _isDragging = true;
      _wasPlayingBeforeDrag = controller.value.isPlaying;
      controller.pause();
    }

    setState(() {
      _progress += details.delta.dx / 400;
      _progress = _progress.clamp(0.0, 1.0);
      controller.seekTo(Duration(
        milliseconds:
            (_progress * controller.value.duration.inMilliseconds).toInt(),
      ));
    });
  }

  /// 滑动结束
  void onDragEnd(DragEndDetails details) {
    if (!mounted) return; // 添加检查
    if (_wasPlayingBeforeDrag) {
      controller.play();
    }
    _isDragging = false;
  }

  /// 显隐功能区
  void showHideFuncView() {
    if (!mounted) return; // 添加检查
    setState(() {
      isShowFuncView = !isShowFuncView;
    });
    if (isShowFuncView) {
      updateFuncViewTimer();
    }
  }

  /// 更新定时器
  void updateFuncViewTimer() {
    showFuncViewTimer?.cancel();
    showFuncViewTimer = Timer(const Duration(seconds: 4), () {
      if (!mounted) return; // 添加检查
      setState(() {
        isShowFuncView = false;
      });
    });
  }

  /// 底部设置
  Container _settings() {
    return Container(
      width: 40,
      height: 40,
      margin: const EdgeInsets.only(left: 5, right: 5),
      child: MenuAnchor(
        menuChildren: speeds.map((item) {
          return Center(
            child: GestureDetector(
              onTap: () {
                controller.setPlaybackSpeed(item);
                settingController.close();
              },
              child: Text(
                '${item}X',
                style: const TextStyle(color: Colors.black),
              ),
            ),
          );
        }).toList(),
        builder: (context, controller, child) {
          return IconButton(
            onPressed: () {
              settingController = controller;
              if (controller.isOpen) {
                controller.close();
              } else {
                controller.open();
              }
            },
            icon: const Icon(
              Icons.settings,
              color: Colors.white,
            ),
          );
        },
      ),
    );
  }

  /// 横竖屏按钮
  SizedBox _changeOritation() {
    return SizedBox(
      child: GestureDetector(
        onTap: () => changeScreenDirection(),
        child: _currentOrientation == Orientation.portrait
            ? const Icon(
                Icons.aspect_ratio,
                color: Colors.white,
              )
            : const Icon(
                Icons.fullscreen_exit,
                color: Colors.white,
              ),
      ),
    );
  }

  /// 左下暂停按钮
  SizedBox _bottomLeftBtn() {
    return SizedBox(
      child: GestureDetector(
        onTap: () => pause(),
        child: Container(
          margin: const EdgeInsets.only(right: 5),
          child: controller.value.isPlaying
              ? const Icon(
                  CupertinoIcons.pause_fill,
                  color: Colors.white,
                  size: 30,
                )
              : const Icon(
                  CupertinoIcons.play_fill,
                  color: Colors.white,
                  size: 30,
                ),
        ),
      ),
    );
  }

  /// 返回上一页
  void back() {
    // 恢复屏幕状态
    if (_orientation == Orientation.portrait) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    }
    PPC.back();
  }

  /// 切换横竖屏
  void changeScreenDirection() {
    if (_currentOrientation == Orientation.portrait) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }
    setState(() {});
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
          onChangeStart: (positoin) {
            if (!controller.value.isPlaying) controller.pause();
          },
          onChanged: (position) {
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

/// 自定义轨道
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
      ..color = Colors.white
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
