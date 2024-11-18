import 'package:flutter/material.dart';
import 'package:subcultures/common/constant.dart';
import 'package:subcultures/widgets/video_player.dart';

enum MediaType {
  image,
  video,
}

class Media extends StatelessWidget {
  /// 媒体类型
  final MediaType type;

  /// 媒体链接
  final String url;

  const Media({
    super.key,
    this.type = MediaType.image,
    this.url = DEFAULT_IMAGE_URL,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: _buildMediaContent(),
    );
  }

  /// 构建媒体内容
  Widget _buildMediaContent() {
    switch (type) {
      case MediaType.image:
        return Image.network(
          url,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        );
      case MediaType.video:
        return OneHandVideoPlayer(url: url);
    }
  }
}
