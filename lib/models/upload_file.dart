import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class UploadFile {
  String? type;
  String? url;

  /// 桶名
  String? bucketName;

  /// 对象名(包含路径)
  String? objectName;
  UploadFile({
    this.type,
    this.url,
    this.bucketName,
    this.objectName,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'type': type,
      'url': url,
      'bucketName': bucketName,
      'objectName': objectName,
    };
  }

  factory UploadFile.fromMap(Map<String, dynamic> map) {
    return UploadFile(
      type: map['type'] != null ? map['type'] as String : null,
      url: map['url'] != null ? map['url'] as String : null,
      bucketName:
          map['bucketName'] != null ? map['bucketName'] as String : null,
      objectName:
          map['objectName'] != null ? map['objectName'] as String : null,
    );
  }

  factory UploadFile.fromJson(String source) =>
      UploadFile.fromMap(json.decode(source) as Map<String, dynamic>);
}
