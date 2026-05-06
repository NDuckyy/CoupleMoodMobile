import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../models/collection/collection_item.dart';
import '../../providers/collection/collection_provider.dart';
import '../../utils/upload_util.dart';
import 'package:couple_mood_mobile/widgets/snack_bar.dart';

class EditCollectionScreen extends StatefulWidget {
  final CollectionItem collection;
  const EditCollectionScreen({super.key, required this.collection});

  @override
  State<EditCollectionScreen> createState() => _EditCollectionScreenState();
}

class _EditCollectionScreenState extends State<EditCollectionScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descController;
  late String _status;

  File? _selectedImage;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.collection.collectionName,
    );
    _descController = TextEditingController(
      text: widget.collection.description,
    );
    _status = widget.collection.status;
  }

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
      String imageUrl = widget.collection.img ?? "";
      if (_selectedImage != null) {
        imageUrl = await UploadUtil.uploadImage(_selectedImage!);
      }

      await context.read<CollectionProvider>().updateCollection(
        id: widget.collection.id,
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

  Widget _buildImageSection() {
    final hasImage =
        _selectedImage != null ||
        (widget.collection.img != null && widget.collection.img!.isNotEmpty);

    return GestureDetector(
      onTap: _pickImage,
      child: Stack(
        children: [
          Container(
            height: 220,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.grey[200],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: _selectedImage != null
                  ? Image.file(_selectedImage!, fit: BoxFit.cover)
                  : (widget.collection.img != null &&
                        widget.collection.img!.isNotEmpty)
                  ? Image.network(
                      widget.collection.img!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          Container(color: Colors.grey[300]),
                    )
                  : Container(color: Colors.grey[300]),
            ),
          ),
          if (hasImage)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                  ),
                ),
              ),
            ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Row(
              children: [
                const Text(
                  "Nhấn để thay ảnh bìa",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chỉnh sửa bộ sưu tập")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImageSection(),
              const SizedBox(height: 24),

              _buildLabel("Tên bộ sưu tập", isRequired: true),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                validator: (value) => value == null || value.trim().isEmpty
                    ? "Vui lòng nhập tên"
                    : null,
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
              const SizedBox(height: 20),

              _buildLabel("Mô tả"),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descController,
                maxLines: 4,
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
              const SizedBox(height: 24),

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
                height: 52,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(
                      0xFFEE6C9F,
                    ), // Màu hồng Couple Mood
                    foregroundColor: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
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
                          "Lưu thay đổi",
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
