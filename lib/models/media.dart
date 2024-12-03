import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class Media {
  final String? url;
  final MediaType? type;
  Media({
    this.url,
    this.type,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'url': url,
      'type': type?.name,
    };
  }

  factory Media.fromMap(Map<String, dynamic> map) {
    return Media(
      url: map['url'] != null ? map['url'] as String : null,
      type: map['type'] != null
          ? convertToMediaType(map['type'] as String)
          : null,
    );
  }

  /// 将字符串转换为媒体类型
  static MediaType convertToMediaType(String type) {
    switch (type) {
      case 'MP4' || 'AVI':
        return MediaType.video;
      case 'JPG' || 'JPEG' || 'GIF' || 'PNG' || 'HEIC':
        return MediaType.image;
      default:
        throw FormatException('不支持的媒体类型字符串: $type');
    }
  }

  /// 转为媒体列表
  static List<Media> convertToMediaList(String medias) {
    if (medias.isEmpty) {
      return [];
    }
    List<dynamic> list = jsonDecode(medias) as List<dynamic>;
    return list.map((e) => Media.fromMap(e)).toList();
  }
}

enum MediaType {
  image,
  video,
}
