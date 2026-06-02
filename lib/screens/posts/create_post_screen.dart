import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../config/theme.dart';
import '../../services/auth_service.dart';
import '../../services/post_service.dart';
import '../../services/storage_service.dart';
import '../../services/user_service.dart';
import '../../models/user_model.dart';
import '../../models/app_localizations_stub.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({Key? key}) : super(key: key);

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _imagePicker = ImagePicker();
  final _postService = PostService();
  final _storageService = StorageService();
  final _authService = AuthService();
  final _userService = UserService();

  AppLocalizations _localizations(BuildContext context) {
    return AppLocalizations.of(context) ?? AppLocalizationsEn();
  }

  List<XFile> _selectedImages = [];
  List<String> _mediaTypes = [];
  bool _isUploading = false;
  String? _errorMessage;
  int _characterCount = 0;
  const int _maxCharacters = 500;

  @override
  void dispose() {
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    try {
      final images = await _imagePicker.pickMultiImage(
        maxWidth: 1280,
        maxHeight: 720,
        imageQuality: 85,
      );

      if (images.isNotEmpty) {
        setState(() {
          _selectedImages.addAll(images);
          _mediaTypes.addAll(List.filled(images.length, 'image'));
        });
      }
    } catch (e) {
      setState(() => _errorMessage = 'خطا در انتخاب تصویر');
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
      _mediaTypes.removeAt(index);
    });
  }

  Future<void> _createPost(UserModel userProfile) async {
    final loc = _localizations(context);
    
    if (_descriptionController.text.trim().isEmpty) {
      setState(() => _errorMessage = 'لطفا متن پست را وارد کنید');
      return;
    }

    setState(() {
      _isUploading = true;
      _errorMessage = null;
    });

    try {
      final currentUser = _authService.getCurrentUser();
      if (currentUser == null) {
        throw Exception('User not logged in');
      }

      // Upload media files
      List<String> mediaUrls = [];
      if (_selectedImages.isNotEmpty) {
        mediaUrls = await _storageService.uploadMultipleMedia(
          files: _selectedImages.map((xfile) => File(xfile.path)).toList(),
          uid: currentUser.uid,
          mediaType: 'image',
        );
      }

      // Create post in Firestore
      await _postService.createPost(
        uid: currentUser.uid,
        authorName: userProfile.fullName,
        profilePhotoUrl: userProfile.profilePhotoUrl,
        location: _locationController.text.trim().isEmpty
            ? userProfile.location
            : _locationController.text.trim(),
        description: _descriptionController.text.trim(),
        mediaUrls: mediaUrls,
        mediaTypes: List.filled(mediaUrls.length, 'image'),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(loc.successPostCreated)),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      setState(() {
        _isUploading = false;
        _errorMessage = 'خطا در ایجاد پست: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = _localizations(context);
    final currentUser = _authService.getCurrentUser();

    return Scaffold(
      appBar: AppBar(
        title: const Text('پست جدید'),
        centerTitle: true,
        elevation: 2,
      ),
      body: StreamBuilder<UserModel?>(
        stream: currentUser != null
            ? _userService.getUserProfileStream(currentUser.uid)
            : null,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(AppColors.darkGreen),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return Center(
              child: Text(loc.errorProfileUpdateFailed),
            );
          }

          final userProfile = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              children: [
                // User Info
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.forestGreen,
                        ),
                        child: userProfile.profilePhotoUrl.isNotEmpty
                            ? ClipOval(
                          child: Image.network(
                            userProfile.profilePhotoUrl,
                            fit: BoxFit.cover,
                          ),
                        )
                            : const Center(
                          child: Icon(Icons.person, color: AppColors.white),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userProfile.fullName,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            userProfile.farmName,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.mediumGray,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Divider(height: 1),

                // Description Input
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: _descriptionController,
                        maxLines: 5,
                        maxLength: _maxCharacters,
                        onChanged: (value) {
                          setState(() => _characterCount = value.length);
                        },
                        decoration: InputDecoration(
                          hintText: 'پست خود را بنویسید...',
                          hintStyle: TextStyle(color: AppColors.mediumGray),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: AppColors.darkGreen),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: AppColors.darkGreen, width: 2),
                          ),
                          filled: true,
                          fillColor: AppColors.lightGray,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '$_characterCount / $_maxCharacters',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: _characterCount > _maxCharacters * 0.9
                              ? AppColors.warning
                              : AppColors.mediumGray,
                        ),
                      ),
                    ],
                  ),
                ),

                // Location Input
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: TextField(
                    controller: _locationController,
                    decoration: InputDecoration(
                      labelText: loc.labelLocation,
                      hintText: 'موقعیت را وارد کنید',
                      prefixIcon: const Icon(Icons.location_on, color: AppColors.darkGreen),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: AppColors.darkGreen, width: 2),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Selected Images Preview
                if (_selectedImages.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'تصاویر انتخاب شده (${_selectedImages.length})',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 100,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _selectedImages.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: Stack(
                                  children: [
                                    Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: AppColors.darkGreen),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.file(
                                          File(_selectedImages[index].path),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: -8,
                                      right: -8,
                                      child: GestureDetector(
                                        onTap: () => _removeImage(index),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: AppColors.error,
                                          ),
                                          padding: const EdgeInsets.all(4),
                                          child: const Icon(
                                            Icons.close,
                                            color: AppColors.white,
                                            size: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),

                // Add Media Buttons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _isUploading ? null : _pickImages,
                          icon: const Icon(Icons.image),
                          label: const Text('افزودن تصویر'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.darkGreen,
                            side: const BorderSide(color: AppColors.darkGreen),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: null,
                          icon: const Icon(Icons.videocam),
                          label: const Text('ویدیو'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.mediumGray,
                            side: const BorderSide(color: AppColors.mediumGray),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Error Message
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.error.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.error),
                      ),
                      child: Text(
                        _errorMessage!,
                        style: TextStyle(color: AppColors.error),
                      ),
                    ),
                  ),

                if (_errorMessage != null) const SizedBox(height: 16),

                // Submit Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isUploading ? null : () => _createPost(userProfile),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.darkGreen,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: _isUploading
                          ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(AppColors.white),
                          strokeWidth: 2,
                        ),
                      )
                          : Text(
                        'انتشار پست',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }
}
