// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:subcultures/utils/log/log_service.dart';

import 'package:subcultures/models/media.dart';
import 'package:subcultures/widgets/video_player.dart';

class MediasWidget extends StatefulWidget {
  /// 媒体链接
  final String? medias;

  const MediasWidget({
    super.key,
    this.medias,
  });

  @override
  State<StatefulWidget> createState() {
    return _MediasWidgetState();
  }
}

class _MediasWidgetState extends State<MediasWidget> {
  /// 媒体列表
  RxList<Media> medias = <Media>[].obs;

  @override
  void initState() {
    super.initState();
    medias.value = Media.convertToMediaList(widget.medias ?? '').obs;
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(color: Colors.white.withOpacity(0.2)),
    );
  }

  /// 构建媒体内容
  // Widget _buildMediaContent() {
  //   switch (type) {
  //     case MediaType.image:
  //       return Image.network(
  //         url,
  //         fit: BoxFit.cover,
  //         width: double.infinity,
  //         height: double.infinity,
  //       );
  //     case MediaType.video:
  //       return OneHandVideoPlayer(url: url);
  //   }
  // }
}
