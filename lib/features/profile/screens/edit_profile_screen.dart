import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../../../core/dummy_data.dart';
import '../../../core/helper/theme.dart';
import '../../../core/widgets/primary_button.dart';
import '../view_model/profile_cubit.dart';
import '../widgets/profile_avatar.dart';

class EditProfileScreen extends StatefulWidget {
  final UserProfile user;

  const EditProfileScreen({super.key, required this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _imagePicker = ImagePicker();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  XFile? _selectedImage;
  bool _isSaving = false;
  bool _isPickingImage = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _emailController = TextEditingController(text: widget.user.email);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final avatarPath = _selectedImage?.path ?? widget.user.profilePictureUrl;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: const Text('Edit profile'), centerTitle: true),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
            children: [
              Center(
                child: Column(
                  children: [
                    ProfileAvatar(
                      name: _nameController.text,
                      imageUrl: avatarPath,
                      radius: 64,
                    ),
                    const SizedBox(height: 12),
                    TextButton.icon(
                      onPressed: _isPickingImage || _isSaving
                          ? null
                          : _pickProfileImage,
                      icon: _isPickingImage
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.photo_library_outlined),
                      label: const Text('Choose profile photo'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              TextFormField(
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Full name',
                  prefixIcon: Icon(Icons.person_outline),
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Please enter your name'
                    : null,
              ),
              const SizedBox(height: 18),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                autofillHints: const [AutofillHints.email],
                decoration: const InputDecoration(
                  labelText: 'Email address',
                  prefixIcon: Icon(Icons.email_outlined),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  final email = value?.trim() ?? '';
                  if (email.isEmpty) return 'Please enter your email';
                  if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
                onFieldSubmitted: (_) => _saveProfile(),
              ),
              const SizedBox(height: 28),
              PrimaryButton(
                text: 'Save changes',
                isLoading: _isSaving,
                onPressed: () {
                  if (!_isPickingImage && !_isSaving) _saveProfile();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickProfileImage() async {
    setState(() => _isPickingImage = true);
    try {
      final image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1200,
      );
      if (image != null && mounted) {
        setState(() => _selectedImage = image);
      }
    } on PlatformException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not select image: ${error.message}')),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not select image: $error')),
        );
      }
    } finally {
      if (mounted) setState(() => _isPickingImage = false);
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    final profileCubit = context.read<ProfileCubit>();
    setState(() => _isSaving = true);

    try {
      String? savedImagePath;
      if (_selectedImage != null) {
        final appDirectory = await getApplicationSupportDirectory();
        final extension = _safeImageExtension(_selectedImage!.name);
        final destination = File(
          '${appDirectory.path}${Platform.pathSeparator}'
          'profile_avatar_${DateTime.now().millisecondsSinceEpoch}.$extension',
        );
        await File(_selectedImage!.path).copy(destination.path);
        savedImagePath = destination.path;
      }

      await profileCubit.updateProfile(
        name: _nameController.text,
        email: _emailController.text,
        avatar: savedImagePath,
      );
      if (mounted) Navigator.of(context).pop(true);
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not save profile: $error')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  String _safeImageExtension(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    const supportedExtensions = {'jpg', 'jpeg', 'png', 'webp', 'heic'};
    return supportedExtensions.contains(extension) ? extension : 'jpg';
  }
}
