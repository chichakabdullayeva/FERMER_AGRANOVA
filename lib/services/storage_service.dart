import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();

  factory StorageService() {
    return _instance;
  }

  StorageService._internal();

  final _storage = FirebaseStorage.instance;
  const _uuid = Uuid();

  // Upload post media (image or video)
  Future<String> uploadPostMedia({
    required File file,
    required String uid,
    required String mediaType, // 'image' or 'video'
  }) async {
    try {
      final fileName = _uuid.v4();
      final fileExtension = _getFileExtension(file.path);
      final path = 'posts/$uid/$mediaType/${DateTime.now().year}/${DateTime.now().month}/$fileName.$fileExtension';

      final ref = _storage.ref(path);
      
      final metadata = SettableMetadata(
        contentType: _getContentType(mediaType, fileExtension),
        cacheControl: 'max-age=3600',
      );

      await ref.putFile(file, metadata);
      final downloadUrl = await ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw StorageException('Failed to upload media: $e');
    }
  }

  // Upload profile photo
  Future<String> uploadProfilePhoto({
    required File file,
    required String uid,
  }) async {
    try {
      final path = 'profiles/$uid/profile_photo';
      final ref = _storage.ref(path);

      await ref.putFile(file);
      final downloadUrl = await ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw StorageException('Failed to upload profile photo: $e');
    }
  }

  // Delete file from storage
  Future<void> deleteFile(String downloadUrl) async {
    try {
      final ref = _storage.refFromURL(downloadUrl);
      await ref.delete();
    } catch (e) {
      throw StorageException('Failed to delete file: $e');
    }
  }

  // Delete multiple files
  Future<void> deleteFiles(List<String> downloadUrls) async {
    try {
      for (final url in downloadUrls) {
        await deleteFile(url);
      }
    } catch (e) {
      throw StorageException('Failed to delete files: $e');
    }
  }

  // Get file size
  Future<int> getFileSize(String filePath) async {
    try {
      final ref = _storage.ref(filePath);
      final metadata = await ref.getMetadata();
      return metadata.size ?? 0;
    } catch (e) {
      throw StorageException('Failed to get file size: $e');
    }
  }

  // Check if file exists
  Future<bool> fileExists(String filePath) async {
    try {
      final ref = _storage.ref(filePath);
      await ref.getMetadata();
      return true;
    } catch (e) {
      return false;
    }
  }

  // Get file extension from path
  String _getFileExtension(String filePath) {
    return filePath.split('.').last.toLowerCase();
  }

  // Get content type based on media type and extension
  String _getContentType(String mediaType, String extension) {
    if (mediaType == 'video') {
      switch (extension) {
        case 'mp4':
          return 'video/mp4';
        case 'mov':
          return 'video/quicktime';
        case 'avi':
          return 'video/x-msvideo';
        default:
          return 'video/mp4';
      }
    } else {
      switch (extension) {
        case 'jpg':
        case 'jpeg':
          return 'image/jpeg';
        case 'png':
          return 'image/png';
        case 'gif':
          return 'image/gif';
        case 'webp':
          return 'image/webp';
        default:
          return 'image/jpeg';
      }
    }
  }

  // Upload multiple media files
  Future<List<String>> uploadMultipleMedia({
    required List<File> files,
    required String uid,
    required String mediaType,
  }) async {
    try {
      final List<String> urls = [];
      for (final file in files) {
        final url = await uploadPostMedia(
          file: file,
          uid: uid,
          mediaType: mediaType,
        );
        urls.add(url);
      }
      return urls;
    } catch (e) {
      throw StorageException('Failed to upload multiple files: $e');
    }
  }

  // Get storage quota info (admin only)
  Future<Map<String, dynamic>> getStorageInfo() async {
    try {
      // This would require admin SDK in production
      return {
        'status': 'Storage service running',
      };
    } catch (e) {
      throw StorageException('Failed to get storage info: $e');
    }
  }
}

class StorageException implements Exception {
  final String message;
  StorageException(this.message);

  @override
  String toString() => message;
}
