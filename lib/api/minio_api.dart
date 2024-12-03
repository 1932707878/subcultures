import 'package:dio/dio.dart';
import 'package:subcultures/models/upload_file.dart';
import 'package:subcultures/utils/dio/dio_util.dart';

class MinioApi {
  /// 请求对象
  static final request = DioUtil();

  /// 上传临时文件
  static Future<dynamic> uploadTempFile(MultipartFile file) async {
    // 创建 FormData 对象
    FormData formData = FormData.fromMap({
      'file': file, // 文件字段名为 'file'
    });

    Options options = Options(
      headers: {'Content-Type': 'multipart/form-data'},
    );

    return request.post(
      '/minio/upload',
      data: formData, // 使用 FormData
      options: options,
    );
  }

  /// 保存为永久文件
  static Future<dynamic> saveFile(UploadFile data) {
    return request.post('/minio/save', data: data);
  }

  /// 保存文件列表
  static Future<dynamic> saveFileList(List<UploadFile> data) {
    return request.post('/minio/save_list', data: data);
  }
}
