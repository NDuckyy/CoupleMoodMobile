import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import '../../providers/user/user_provider.dart';
import '../../providers/user/edit_profile_provider.dart';
import '../../widgets/snack_bar.dart';

import 'widget/profile_input.dart';
import 'widget/profile_section.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController fullNameController;
  late TextEditingController phoneController;
  late TextEditingController bioController;
  late TextEditingController jobController;
  late TextEditingController heightController;
  late TextEditingController weightController;
  late TextEditingController cityController;
  late TextEditingController districtController;
  late TextEditingController budgetMinController;
  late TextEditingController budgetMaxController;

  String gender = "MALE";
  DateTime? dateOfBirth;

  /// 🔥 education dropdown
  String? selectedEducation;

  final List<String> educationOptions = [
    "Cấp 1",
    "Cấp 2",
    "Cấp 3",
    "Trung cấp",
    "Cao đẳng",
    "Đại học",
    "Sau đại học",
  ];

  /// pets
  List<String> favoritePets = [];
  bool hasPet = false;
  bool smoking = false;

  File? selectedAvatar;

  @override
  void initState() {
    super.initState();

    final user = context.read<UserProvider>().user;
    final profile = user?.memberProfile;

    fullNameController = TextEditingController(text: user?.fullName ?? "");
    phoneController = TextEditingController(text: user?.phoneNumber ?? "");
    bioController = TextEditingController(text: profile?.bio ?? "");
    jobController = TextEditingController(text: profile?.jobTitle ?? "");

    heightController = TextEditingController(
      text: profile?.height?.toString() ?? "",
    );
    weightController = TextEditingController(
      text: profile?.weight?.toString() ?? "",
    );

    cityController = TextEditingController(text: profile?.city ?? "");
    districtController = TextEditingController(text: profile?.district ?? "");

    budgetMinController = TextEditingController(
      text: profile?.budgetMin?.toString() ?? "",
    );
    budgetMaxController = TextEditingController(
      text: profile?.budgetMax?.toString() ?? "",
    );

    selectedEducation = profile?.educationLevel;

    gender = profile?.gender ?? "MALE";
    favoritePets = profile?.favoritePets ?? [];
    hasPet = profile?.hasPet ?? false;
    smoking = profile?.smoking ?? false;

    if (profile?.dateOfBirth != null) {
      dateOfBirth = DateTime.tryParse(profile!.dateOfBirth!);
    }
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => selectedAvatar = File(picked.path));
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: dateOfBirth ?? DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => dateOfBirth = picked);
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

        /// NEW
        jobTitle: jobController.text,
        educationLevel: selectedEducation,
        height: int.tryParse(heightController.text),
        weight: int.tryParse(weightController.text),
        city: cityController.text,
        district: districtController.text,
        favoritePets: favoritePets,
        hasPet: hasPet,
        smoking: smoking,
      );

      if (!mounted) return;

      if (success) {
        await context.read<UserProvider>().fetchMe();
        showMsg(context, "Cập nhật thành công", true);
        Navigator.pop(context, true);
      }
    } catch (e) {
      showMsg(context, e.toString(), false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<EditProfileProvider>();
    final user = context.watch<UserProvider>().user;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Chỉnh sửa hồ sơ"),
        backgroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          /// AVATAR
          Center(
            child: GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: selectedAvatar != null
                    ? FileImage(selectedAvatar!)
                    : (user?.avatarUrl != null
                              ? NetworkImage(user!.avatarUrl!)
                              : null)
                          as ImageProvider?,
              ),
            ),
          ),

          const SizedBox(height: 20),

          /// BASIC
          ProfileSection(
            "Thông tin cơ bản",
            children: [
              ProfileInput(controller: fullNameController, hint: "Họ và tên"),
              ProfileInput(controller: phoneController, hint: "SĐT"),

              /// DOB
              GestureDetector(
                onTap: _pickDate,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.black12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        dateOfBirth != null
                            ? dateOfBirth!.toString().split(" ")[0]
                            : "Chọn ngày sinh",
                      ),
                      const Icon(Icons.calendar_today, size: 18),
                    ],
                  ),
                ),
              ),

              ProfileInput(controller: bioController, hint: "Bio"),
            ],
          ),

          /// JOB
          ProfileSection(
            "Công việc",
            children: [
              ProfileInput(controller: jobController, hint: "Nghề nghiệp"),

              /// EDUCATION DROPDOWN
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.black12),
                ),
                child: DropdownButtonFormField<String>(
                  value: selectedEducation,
                  hint: const Text("Chọn học vấn"),
                  items: educationOptions.map((e) {
                    return DropdownMenuItem(value: e, child: Text(e));
                  }).toList(),
                  onChanged: (v) {
                    setState(() => selectedEducation = v);
                  },
                  decoration: const InputDecoration(border: InputBorder.none),
                ),
              ),
            ],
          ),

          /// BODY
          ProfileSection(
            "Cơ thể",
            children: [
              ProfileInput(
                controller: heightController,
                hint: "Chiều cao (cm)",
                keyboard: TextInputType.number,
              ),
              ProfileInput(
                controller: weightController,
                hint: "Cân nặng (kg)",
                keyboard: TextInputType.number,
              ),
            ],
          ),

          /// LOCATION
          ProfileSection(
            "Địa chỉ",
            children: [
              ProfileInput(controller: cityController, hint: "Thành phố"),
              ProfileInput(controller: districtController, hint: "Quận"),
            ],
          ),

          /// BUDGET
          ProfileSection(
            "Ngân sách",
            children: [
              ProfileInput(
                controller: budgetMinController,
                hint: "Min",
                keyboard: TextInputType.number,
              ),
              ProfileInput(
                controller: budgetMaxController,
                hint: "Max",
                keyboard: TextInputType.number,
              ),
            ],
          ),

          /// SWITCH
          SwitchListTile(
            title: const Text("Có nuôi thú"),
            value: hasPet,
            onChanged: (v) => setState(() => hasPet = v),
          ),

          SwitchListTile(
            title: const Text("Hút thuốc"),
            value: smoking,
            onChanged: (v) => setState(() => smoking = v),
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: GestureDetector(
              onTap: provider.isLoading ? null : _submit,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: provider.isLoading
                      ? const LinearGradient(colors: [Colors.grey, Colors.grey])
                      : const LinearGradient(
                          colors: [
                            Color(0xFF8093F1),
                            Color(0xFFB388EB),
                            Color(0xFFF7AEF8),
                          ],
                        ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Center(
                  child: provider.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : const Text(
                          "Lưu thay đổi",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
