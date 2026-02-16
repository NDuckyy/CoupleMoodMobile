import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../models/collection/collection_item.dart';
import '../../providers/collection/collection_provider.dart';
import '../../utils/upload_util.dart';

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
      setState(() {
        _selectedImage = File(picked.path);
      });
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  Widget _buildImageSection() {
    return GestureDetector(
      onTap: _pickImage,
      child: Stack(
        children: [
          Container(
            height: 200,
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
                  ? Image.network(widget.collection.img!, fit: BoxFit.cover)
                  : Container(color: Colors.grey[300]),
            ),
          ),

          /// Gradient overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black.withOpacity(0.5), Colors.transparent],
                ),
              ),
            ),
          ),

          /// Text
          const Positioned(
            bottom: 16,
            left: 16,
            child: Text(
              "Nhấn để thay ảnh",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          /// Camera icon
          Positioned(
            bottom: 12,
            right: 12,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.camera_alt,
                color: Colors.white,
                size: 20,
              ),
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
              const SizedBox(height: 20),

              const Text("Tên bộ sưu tập *"),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                validator: (value) => value == null || value.trim().isEmpty
                    ? "Vui lòng nhập tên"
                    : null,
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
                      : const Text("Lưu thay đổi"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
