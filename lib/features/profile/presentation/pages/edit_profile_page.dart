import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/services/image_picker/image_service.dart';
import '../../../../core/services/text-service/text-service.dart';
import '../providers/profile_provider.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  final _nameController = TextEditingController();
  File? _selectedImage;
  bool _isSaving = false;
  bool _didFillForm = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final imageService = ref.read(imageServiceProvider);
    final result = await imageService.pickImage(source: source);

    if (!mounted) return;

    result.fold(
      (failure) => _showMessage(failure.message),
      (file) => setState(() => _selectedImage = file),
    );
  }

  Future<void> _save() async {
    final fullName = _nameController.text.trim();
    if (fullName.isEmpty) {
      _showMessage('Full name is required');
      return;
    }

    setState(() => _isSaving = true);
    final useCase = ref.read(updateProfileUseCaseProvider);
    final result = await useCase(fullName: fullName, image: _selectedImage);
    setState(() => _isSaving = false);

    if (!mounted) return;

    result.fold(
      (failure) => _showMessage(failure.message),
      (_) {
        ref.invalidate(profileProvider);
        _showMessage('Profile updated successfully');
        context.pop();
      },
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _showImagePickerOptions() {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _pickImage(ImageSource.camera);
                    },
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Camera'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _pickImage(ImageSource.gallery);
                    },
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Gallery'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(profileProvider);

    return Scaffold(
      appBar: AppBar(title: headingText(text: 'Edit Profile')),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: normalText(
              text: error.toString(),
              textAlign: TextAlign.center,
              maxLines: 4,
            ),
          ),
        ),
        data: (profile) {
          if (!_didFillForm) {
            _nameController.text = profile.fullName ?? '';
            _didFillForm = true;
          }

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              GestureDetector(
                onTap: _showImagePickerOptions,
                child: Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 54,
                        backgroundImage: _selectedImage != null
                            ? FileImage(_selectedImage!)
                            : profile.image == null || profile.image!.isEmpty
                                ? null
                                : NetworkImage(profile.image!)
                                    as ImageProvider<Object>,
                        child: _selectedImage == null &&
                                (profile.image == null ||
                                    profile.image!.isEmpty)
                            ? const Icon(Icons.person, size: 48)
                            : null,
                      ),
                      const Positioned(
                        right: 0,
                        bottom: 0,
                        child: CircleAvatar(
                          radius: 17,
                          child: Icon(Icons.edit, size: 18),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              normalText(text: 'Full name'),
              const SizedBox(height: 8),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _isSaving ? null : _save,
                icon: _isSaving
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.save),
                label: Text(_isSaving ? 'Saving...' : 'Save'),
              ),
            ],
          );
        },
      ),
    );
  }
}
