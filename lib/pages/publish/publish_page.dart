import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart' as dio;
import 'package:subcultures/api/minio_api.dart';
import 'package:subcultures/api/post_api.dart';
import 'package:subcultures/models/media.dart';
import 'package:subcultures/models/post.dart';
import 'package:subcultures/models/upload_file.dart';
import 'package:subcultures/utils/log/log_service.dart';
import 'package:subcultures/widgets/video_player.dart';

class PublishPage extends StatefulWidget {
  const PublishPage({super.key});

  @override
  State<PublishPage> createState() => _PublishPageState();
}

class _PublishPageState extends State<PublishPage> {
  /// 内容输入框
  final TextEditingController _contentController = TextEditingController();

  /// 选择的媒体
  final List<Media> _selectedMedias = [];

  /// 图片选择器
  final ImagePicker _picker = ImagePicker();

  /// 临时文件
  final List<UploadFile> _tempFiles = [];

  /// 是否正在发布
  bool _isPublishing = false;

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  // 构建媒体预览项
  Widget _buildMediaPreview(Media media) {
    return Container(
      width: 100,
      height: 100,
      margin: const EdgeInsets.only(right: 8),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: media.type == MediaType.image
                ? Image.file(
                    File(media.url!),
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      Log.error('加载预览图片失败', error, stackTrace);
                      return Container(
                        color: Colors.grey[800],
                        child: const Icon(Icons.error_outline,
                            color: Colors.white),
                      );
                    },
                  )
                : OneHandVideoPlayer(url: media.url!),
          ),
          Positioned(
            right: 4,
            top: 4,
            child: GestureDetector(
              onTap: () => _removeMedia(media),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 选择媒体
  void _pickMedia(ImageSource source, {bool isVideo = false}) async {
    try {
      if (isVideo) {
        final XFile? video = await _picker.pickVideo(source: source);
        if (video != null) {
          // 检查文件大小
          final fileSize = await File(video.path).length();
          final sizeInMB = fileSize / (1024 * 1024); // 转换为 MB

          if (sizeInMB > 50) {
            Get.snackbar(
              'File Too Large',
              'Video size cannot exceed 50MB',
              backgroundColor: Colors.red,
              colorText: Colors.white,
              snackPosition: SnackPosition.TOP,
            );
            return;
          }

          // 创建 MultipartFile
          final file = await dio.MultipartFile.fromFile(
            video.path,
            filename: video.name,
          );

          setState(() {
            _selectedMedias.add(Media(
              url: video.path,
              type: MediaType.video,
            ));
          });

          // 触发上传
          uploadFile(file, isVideo: true);
        }
      } else {
        final List<XFile> images = await _picker.pickMultiImage();
        if (images.isNotEmpty) {
          // 过滤大文件
          final validImages = <XFile>[];

          for (var image in images) {
            final fileSize = await File(image.path).length();
            final sizeInMB = fileSize / (1024 * 1024);

            if (sizeInMB <= 50) {
              validImages.add(image);
            } else {
              Get.snackbar(
                'File Too Large',
                'Image "${image.name}" exceeds 50MB limit and will be skipped',
                backgroundColor: Colors.red,
                colorText: Colors.white,
                snackPosition: SnackPosition.TOP,
              );
            }
          }

          if (validImages.isEmpty) return;

          setState(() {
            _selectedMedias.addAll(
              validImages.map((e) => Media(
                    url: e.path,
                    type: MediaType.image,
                  )),
            );
          });

          // 触发上传
          for (var image in validImages) {
            final file = await dio.MultipartFile.fromFile(
              image.path,
              filename: image.name,
            );
            uploadFile(file);
          }
        }
      }
    } catch (e) {
      Log.error('选择媒体失败', e);
    }
  }

  /// 上传文件
  void uploadFile(dio.MultipartFile file, {bool isVideo = false}) async {
    try {
      // 上传文件
      final data = await MinioApi.uploadTempFile(file);
      Log.debug('PublishPage --> 上传${isVideo ? "视频" : "图片"}结果: $data');

      // 添加到临时文件列表
      _tempFiles.add(UploadFile.fromMap(data));
    } catch (e) {
      Log.error('上传文件失败', e);

      // 从预览中移除对应的媒体
      setState(() {
        // 根据文件名查找并移除对应的媒体
        _selectedMedias.removeWhere(
            (media) => media.url?.contains(file.filename ?? '') ?? false);
      });

      Get.snackbar(
        'Upload Failed',
        'Failed to upload ${isVideo ? "video" : "image"}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  void _removeMedia(Media media) {
    setState(() {
      _selectedMedias.remove(media);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff171C28),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () => Get.back(),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: TextButton(
              onPressed: !_isPublishing ? _publish : null,
              style: TextButton.styleFrom(
                backgroundColor: !_isPublishing
                    ? const Color(0xFF7610AB)
                    : const Color(0xFF7610AB).withOpacity(0.5),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: _isPublishing
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      'Publish',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 内容输入框
              TextField(
                controller: _contentController,
                maxLines: null,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'What\'s on your mind?',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),
              const SizedBox(height: 16),

              /// 媒体预览
              if (_selectedMedias.isNotEmpty)
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _selectedMedias.length,
                    itemBuilder: (context, index) {
                      return _buildMediaPreview(_selectedMedias[index]);
                    },
                  ),
                ),
              const SizedBox(height: 16),

              /// 上传按钮
              Row(
                children: [
                  _mediaButton(
                    icon: Icons.image,
                    label: 'Photo',
                    onTap: () => _pickMedia(ImageSource.gallery),
                  ),
                  const SizedBox(width: 16),
                  _mediaButton(
                    icon: Icons.videocam,
                    label: 'Video',
                    onTap: () => _pickMedia(ImageSource.gallery, isVideo: true),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _mediaButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.blue, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(color: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }

  /// 发布帖子
  Future<void> _publish() async {
    // 检查是否有内容或媒体
    if (_contentController.text.trim().isEmpty && _tempFiles.isEmpty) {
      Get.snackbar(
        'Content Required',
        'Please write something or select media before publishing',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    // 检查文件是否全部上传完成
    if (_selectedMedias.length != _tempFiles.length) {
      Get.snackbar(
        'Please Wait',
        'Files are still uploading',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    setState(() {
      _isPublishing = true;
    });

    try {
      String? medias;
      if (_tempFiles.isNotEmpty) {
        // 1. 保存文件
        final savedFiles = await MinioApi.saveFileList(_tempFiles);
        // 2. 转为json字符串
        medias = jsonEncode(savedFiles);
      }

      // 3. 构建帖子对象并发布
      final post = Post(
        content: _contentController.text.trim(),
        medias: medias,
      );
      await PostApi.publishPost(post);

      // 4. 返回上一页
      Get.back();
    } catch (e) {
      Log.error('发布帖子失败', e);
      Get.snackbar(
        'Publish Failed',
        'Failed to publish post',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      setState(() {
        _isPublishing = false;
      });
    }
  }
}
