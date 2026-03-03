import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../providers/collection/collection_provider.dart';
import '../../utils/upload_util.dart';

import 'package:couple_mood_mobile/widgets/snack_bar.dart';

class CreateCollectionScreen extends StatefulWidget {
  const CreateCollectionScreen({super.key});

  @override
  State<CreateCollectionScreen> createState() => _CreateCollectionScreenState();
}

class _CreateCollectionScreenState extends State<CreateCollectionScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _descController = TextEditingController();

  String _status = "PRIVATE";
  File? _selectedImage;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      String imageUrl = "";

      if (_selectedImage != null) {
        imageUrl = await UploadUtil.uploadImage(_selectedImage!);
      }

      await context.read<CollectionProvider>().createCollection(
        name: _nameController.text.trim(),
        description: _descController.text.trim(),
        imgUrl: imageUrl,
        status: _status,
      );

      if (mounted) context.pop(true);
    } catch (e) {
      showMsg(context, e.toString(), false);
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 180,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.grey[200],
        ),
        child: _selectedImage != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.file(_selectedImage!, fit: BoxFit.cover),
              )
            : const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_a_photo, size: 40),
                    SizedBox(height: 8),
                    Text("Thêm ảnh bìa"),
                  ],
                ),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tạo bộ sưu tập")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImagePicker(),
              const SizedBox(height: 20),

              const Text("Tên bộ sưu tập *"),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Vui lòng nhập tên";
                  }
                  return null;
                },
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),

              const SizedBox(height: 16),

              const Text("Mô tả"),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descController,
                maxLines: 3,
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),

              const SizedBox(height: 16),

              const Text("Trạng thái"),
              Row(
                children: [
                  Radio<String>(
                    value: "PRIVATE",
                    groupValue: _status,
                    onChanged: (value) => setState(() => _status = value!),
                  ),
                  const Text("Riêng tư"),
                  Radio<String>(
                    value: "PUBLIC",
                    groupValue: _status,
                    onChanged: (value) => setState(() => _status = value!),
                  ),
                  const Text("Công khai"),
                ],
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submit,
                  child: _isSubmitting
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text("Tạo bộ sưu tập"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
