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
      setState(() => _selectedImage = File(picked.path));
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
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.grey[200],
          border: Border.all(color: Colors.grey.shade300),
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
                    Icon(Icons.add_a_photo, size: 48, color: Colors.grey),
                    SizedBox(height: 12),
                    Text(
                      "Thêm ảnh bìa",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    Text(
                      "Nhấn để chọn từ thư viện",
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                    ),
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
              const SizedBox(height: 24),

              // Tên bộ sưu tập
              _buildLabel("Tên bộ sưu tập", isRequired: true),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                validator: (value) => value == null || value.trim().isEmpty
                    ? "Vui lòng nhập tên"
                    : null,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Ví dụ: Chuyến đi chơi của chúng ta",
                ),
              ),
              const SizedBox(height: 20),

              // Mô tả
              _buildLabel("Mô tả"),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descController,
                maxLines: 4,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Mô tả ngắn về bộ sưu tập...",
                ),
              ),
              const SizedBox(height: 24),

              // Trạng thái
              _buildLabel("Trạng thái"),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: _buildRadioOption("Riêng tư", "PRIVATE")),
                  Expanded(child: _buildRadioOption("Công khai", "PUBLIC")),
                ],
              ),

              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 52, // tăng nhẹ chiều cao cho sang hơn
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(
                      0xFFEE6C9F,
                    ), // ← Màu chính Couple Mood
                    foregroundColor: Colors.white,
                    elevation: 2, // bóng nhẹ
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // bo góc mềm mại
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          "Tạo bộ sưu tập",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text, {bool isRequired = false}) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
        children: [
          TextSpan(text: text),
          if (isRequired)
            const TextSpan(
              text: " *",
              style: TextStyle(color: Colors.red),
            ),
        ],
      ),
    );
  }

  Widget _buildRadioOption(String title, String value) {
    return Row(
      children: [
        Radio<String>(
          value: value,
          groupValue: _status,
          onChanged: (newValue) => setState(() => _status = newValue!),
        ),
        Text(title),
      ],
    );
  }
}
