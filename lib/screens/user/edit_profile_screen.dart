import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user/user_provider.dart';
import '../../providers/user/edit_profile_provider.dart';
import '../../models/user/update_profile_request.dart';
import '../../widgets/snack_bar.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController fullNameController;
  late TextEditingController phoneController;
  late TextEditingController bioController;
  late TextEditingController budgetMinController;
  late TextEditingController budgetMaxController;

  String gender = "MALE";
  DateTime? dateOfBirth;

  File? selectedAvatar;

  @override
  void initState() {
    super.initState();

    final user = context.read<UserProvider>().user;
    final profile = user?.memberProfile;

    fullNameController = TextEditingController(text: user?.fullName ?? "");
    phoneController = TextEditingController(text: user?.phoneNumber ?? "");
    bioController = TextEditingController(text: profile?.bio ?? "");

    budgetMinController = TextEditingController(
      text: (profile?.budgetMin ?? 0).toString(),
    );
    budgetMaxController = TextEditingController(
      text: (profile?.budgetMax ?? 0).toString(),
    );

    gender = profile?.gender ?? "MALE";

    if (profile?.dateOfBirth != null) {
      dateOfBirth = DateTime.tryParse(profile!.dateOfBirth!);
    }
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        selectedAvatar = File(picked.path);
      });
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: dateOfBirth ?? DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        dateOfBirth = picked;
      });
    }
  }

  Future<void> _submit() async {
    final user = context.read<UserProvider>().user;
    if (user == null) return;

    final provider = context.read<EditProfileProvider>();

    try {
      final success = await provider.updateProfile(
        user: user,
        fullName: fullNameController.text.trim(),
        phoneNumber: phoneController.text.trim(),
        gender: gender,
        dateOfBirth: dateOfBirth?.toIso8601String().split("T").first ?? "",
        bio: bioController.text.trim(),
        budgetMin: double.tryParse(budgetMinController.text),
        budgetMax: double.tryParse(budgetMaxController.text),
        avatarFile: selectedAvatar,
      );

      if (!mounted) return;

      if (success) {
        await context.read<UserProvider>().fetchMe();

        showMsg(context, "Cập nhật thành công", true);
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (!mounted) return;
      showMsg(context, e.toString(), false);
    }
  }

  @override
  void dispose() {
    fullNameController.dispose();
    phoneController.dispose();
    bioController.dispose();
    budgetMinController.dispose();
    budgetMaxController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    final provider = context.watch<EditProfileProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Chỉnh sửa hồ sơ")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 45,
                backgroundColor: Colors.grey[200],
                backgroundImage: selectedAvatar != null
                    ? FileImage(selectedAvatar!)
                    : (user?.avatarUrl != null
                              ? NetworkImage(user!.avatarUrl!)
                              : null)
                          as ImageProvider?,
                child: selectedAvatar == null && user?.avatarUrl == null
                    ? const Icon(Icons.camera_alt)
                    : null,
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: fullNameController,
              decoration: const InputDecoration(labelText: "Họ và tên"),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: "Số điện thoại"),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: bioController,
              decoration: const InputDecoration(labelText: "Bio"),
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: Text(
                    dateOfBirth != null
                        ? "DOB: ${dateOfBirth!.toString().split(" ")[0]}"
                        : "Chọn ngày sinh",
                  ),
                ),
                TextButton(onPressed: _pickDate, child: const Text("Chọn")),
              ],
            ),

            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              value: gender,
              items: const [
                DropdownMenuItem(value: "MALE", child: Text("Nam")),
                DropdownMenuItem(value: "FEMALE", child: Text("Nữ")),
              ],
              onChanged: (v) {
                if (v != null) {
                  setState(() {
                    gender = v;
                  });
                }
              },
              decoration: const InputDecoration(labelText: "Giới tính"),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: budgetMinController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Budget Min"),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: budgetMaxController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Budget Max"),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: provider.isLoading ? null : _submit,
                child: provider.isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text("Lưu thay đổi"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
