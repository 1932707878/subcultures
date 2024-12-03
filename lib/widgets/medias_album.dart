// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

import 'package:subcultures/utils/log/logController.dart';
import 'package:subcultures/models/media.dart';
import 'package:subcultures/widgets/video_player.dart';

class MediasAlbum extends StatefulWidget {
  /// 媒体列表
  ///
  /// [{}, {}]
  final String mediasJson;

  const MediasAlbum({
    super.key,
    required this.mediasJson,
  });

  @override
  State<MediasAlbum> createState() => _MediasAlbumState();
}

class _MediasAlbumState extends State<MediasAlbum> {
  late RxList<Media> medias = <Media>[].obs;
  final Map<String, ImageProvider> _cachedImages = {};
  final Map<String, OneHandVideoPlayer> _cachedVideos = {};

  @override
  void initState() {
    super.initState();
    medias.value = Media.convertToMediaList(widget.mediasJson).obs;
    _preloadMedias();
  }

  void _preloadMedias() {
    for (var media in medias) {
      if (media.url == null) continue;

      switch (media.type) {
        case MediaType.image:
          _cachedImages[media.url!] = NetworkImage(media.url!)
            ..resolve(const ImageConfiguration())
                .addListener(ImageStreamListener((info, _) {
              Log.debug('MediasAlbum --> 图片预加载成功: ${media.url}');
            }, onError: (error, stackTrace) {
              Log.error('MediasAlbum --> 图片预加载失败', error, stackTrace);
            }));
          break;
        case MediaType.video:
          _cachedVideos[media.url!] = OneHandVideoPlayer(url: media.url!);
          break;
        default:
          break;
      }
    }
  }

  @override
  void dispose() {
    _cachedImages.clear();
    _cachedVideos.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (medias.isEmpty) return const SizedBox();

    // 根据媒体数量决定容器高度和布局方式
    final double itemHeight = medias.length == 1 ? 280.0 : 140.0;
    final double itemWidth = medias.length == 1
        ? MediaQuery.of(context).size.width - 40 // 减去左右边距
        : itemHeight;

    return SizedBox(
      height: itemHeight,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics:
            medias.length == 1 ? const NeverScrollableScrollPhysics() : null,
        padding: EdgeInsets.zero, // 移除 ListView 的默认内边距
        itemCount: medias.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(
              right: index != medias.length - 1 ? 8.0 : 0,
            ),
            width: itemWidth,
            height: itemHeight,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: _buildMediaItem(medias[index]),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMediaItem(Media media) {
    if (media.url == null) return const SizedBox();

    switch (media.type) {
      case MediaType.image:
        return GestureDetector(
          onTap: () => _showFullScreenImage(media.url!),
          child: _cachedImages.containsKey(media.url!)
              ? Image(
                  image: _cachedImages[media.url!]!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  errorBuilder: (context, error, stackTrace) {
                    Log.error('MediasAlbum --> 图片加载失败', error, stackTrace);
                    return const Center(
                      child: Icon(Icons.error_outline,
                          color: Colors.white, size: 40),
                    );
                  },
                )
              : const Center(child: CircularProgressIndicator()),
        );
      case MediaType.video:
        return _cachedVideos[media.url!] ?? const SizedBox();
      default:
        return const SizedBox();
    }
  }

  void _showFullScreenImage(String imageUrl) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => _FullScreenGallery(
          medias: medias,
          initialIndex: medias.indexWhere((m) => m.url == imageUrl),
        ),
      ),
    );
  }
}

/// 全屏媒体画廊
class _FullScreenGallery extends StatefulWidget {
  final List<Media> medias;
  final int initialIndex;

  const _FullScreenGallery({
    required this.medias,
    required this.initialIndex,
  });

  @override
  State<_FullScreenGallery> createState() => _FullScreenGalleryState();
}

class _FullScreenGalleryState extends State<_FullScreenGallery> {
  /// 页面控制器
  late PageController _pageController;

  /// 当前媒体索引
  late int _currentIndex;

  /// 变换控制器
  final TransformationController _transformationController =
      TransformationController();

  /// 双击次数
  int _tapCount = 0;

  /// 最大缩放倍数
  static const double _maxScale = 4.0;

  /// 双击位置
  Offset? _doubleTapPosition;

  /// 是否正在缩放
  bool _isZoomed = false;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);

    _transformationController.addListener(() {
      final scale = _transformationController.value.getMaxScaleOnAxis();
      final newIsZoomed = scale > 1.0;
      if (_isZoomed != newIsZoomed) {
        setState(() {
          _isZoomed = newIsZoomed;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _transformationController.dispose();
    super.dispose();
  }

  void _handleDoubleTapDown(TapDownDetails details) {
    _doubleTapPosition = details.localPosition;
  }

  void _handleDoubleTap() {
    if (_doubleTapPosition == null) return;

    setState(() {
      if (_tapCount < 2) {
        final Matrix4 matrix = Matrix4.identity();
        final scale = _tapCount == 0 ? 2.0 : _maxScale;
        final Offset position = _doubleTapPosition!;

        final x = -position.dx * (scale - 1);
        final y = -position.dy * (scale - 1);

        matrix.translate(x, y);
        matrix.scale(scale);

        _transformationController.value = matrix;
        _tapCount++;
      } else {
        _transformationController.value = Matrix4.identity();
        _tapCount = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        onDoubleTapDown: _handleDoubleTapDown,
        onDoubleTap: _handleDoubleTap,
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              physics: _isZoomed
                  ? const NeverScrollableScrollPhysics()
                  : const AlwaysScrollableScrollPhysics(),
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                  // 重置缩放状态
                  _transformationController.value = Matrix4.identity();
                  _tapCount = 0;
                  _isZoomed = false;
                });
              },
              itemCount: widget.medias.length,
              itemBuilder: (context, index) {
                final media = widget.medias[index];
                if (media.type == MediaType.image) {
                  return InteractiveViewer(
                    transformationController: _transformationController,
                    minScale: 1.0,
                    maxScale: _maxScale,
                    child: Center(
                      child: Image.network(
                        media.url!,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          Log.error(
                              'MediasAlbum --> 全屏图片加载失败', error, stackTrace);
                          return const Center(
                            child: Icon(Icons.error_outline,
                                color: Colors.white, size: 40),
                          );
                        },
                      ),
                    ),
                  );
                } else if (media.type == MediaType.video) {
                  return OneHandVideoPlayer(url: media.url!);
                }
                return const SizedBox();
              },
            ),
            // 页面指示器
            if (widget.medias.length > 1 && !_isZoomed)
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    widget.medias.length,
                    (index) => Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentIndex == index
                            ? Colors.white
                            : Colors.white.withOpacity(0.5),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
