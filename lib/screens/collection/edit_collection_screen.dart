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

      if (mounted) {
        context.pop(true);
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() => _isSubmitting = false);
    }
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
              /// IMAGE
              GestureDetector(
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
                      : (widget.collection.img != null &&
                            widget.collection.img!.isNotEmpty)
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            widget.collection.img!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Center(
                              child: Icon(Icons.broken_image, size: 40),
                            ),
                          ),
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
              ),

              const SizedBox(height: 20),

              /// NAME
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

              /// DESCRIPTION
              const Text("Mô tả"),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descController,
                maxLines: 3,
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),

              const SizedBox(height: 16),

              /// STATUS
              const Text("Trạng thái"),
              Row(
                children: [
                  Radio(
                    value: "PRIVATE",
                    groupValue: _status,
                    onChanged: (value) {
                      setState(() => _status = value!);
                    },
                  ),
                  const Text("Riêng tư"),
                  Radio(
                    value: "PUBLIC",
                    groupValue: _status,
                    onChanged: (value) {
                      setState(() => _status = value!);
                    },
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
                      ? const CircularProgressIndicator()
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
