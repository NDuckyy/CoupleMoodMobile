import 'dart:io';
import 'package:couple_mood_mobile/screens/user/sheet/commune_picker.dart';
import 'package:couple_mood_mobile/screens/user/sheet/education_picker.dart';
import 'package:couple_mood_mobile/screens/user/sheet/interest_picker_sheet.dart';
import 'package:couple_mood_mobile/screens/user/sheet/job_picker.dart';
import 'package:couple_mood_mobile/screens/user/sheet/pet_picker_sheet.dart';
import 'package:couple_mood_mobile/screens/user/sheet/province_picker.dart';
import 'package:couple_mood_mobile/screens/user/widget/box_section.dart';
import 'package:couple_mood_mobile/screens/user/widget/edit_section.dart';
import 'package:couple_mood_mobile/screens/user/sheet/gender_picker.dart';
import 'package:couple_mood_mobile/screens/user/widget/input_section.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:collection/collection.dart';

import '../../providers/user/user_provider.dart';
import '../../providers/user/edit_profile_provider.dart';
import '../../widgets/snack_bar.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController fullNameController;
  late TextEditingController phoneController;
  late TextEditingController bioController;
  late TextEditingController jobController;
  late TextEditingController heightController;
  late TextEditingController weightController;
  late TextEditingController budgetMinController;
  late TextEditingController budgetMaxController;

  String gender = "MALE";
  DateTime? dateOfBirth;

  List<String> favoritePets = [];
  List<String> interests = [];
  String? selectedProvinceCode;
  String? selectedProvinceName;

  String? selectedCommuneCode;
  String? selectedCommuneName;
  bool hasPet = false;
  bool smoking = false;

  File? selectedAvatar;
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

  Future<void> _openInterestPicker() async {
    final result = await openInterestPicker(
      context: context,
      interests: interests,
    );
    if (result != null) {
      setState(() => interests = result);
    }
  }

  Future<void> _openPetPicker() async {
    final result = await openPetPicker(
      context: context,
      favoritePets: favoritePets,
    );
    if (result != null) {
      setState(() => favoritePets = result);
    }
  }

  @override
  void initState() {
    super.initState();

    final provider = context.read<EditProfileProvider>();
    provider.fetchAnimals();
    provider.fetchInterests();
    provider.fetchJobTitles();

    final user = context.read<UserProvider>().user;
    final profile = user?.memberProfile;

    fullNameController = TextEditingController(text: profile?.fullName ?? "");
    phoneController = TextEditingController(text: user?.phoneNumber ?? "");
    bioController = TextEditingController(text: profile?.bio ?? "");
    jobController = TextEditingController(text: profile?.jobTitle ?? "");

    heightController = TextEditingController(
      text: profile?.height?.toString() ?? "",
    );
    weightController = TextEditingController(
      text: profile?.weight?.toString() ?? "",
    );

    selectedProvinceName = profile?.city;
    selectedCommuneName = profile?.district;

    budgetMinController = TextEditingController(
      text: profile?.budgetMin?.toString() ?? "",
    );
    budgetMaxController = TextEditingController(
      text: profile?.budgetMax?.toString() ?? "",
    );

    gender = profile?.gender ?? "MALE";
    favoritePets = profile?.favoritePets ?? [];
    hasPet = profile?.hasPet ?? false;
    smoking = profile?.smoking ?? false;

    if (profile?.dateOfBirth != null) {
      dateOfBirth = DateTime.tryParse(profile!.dateOfBirth!);
    }

    interests = (profile?.interests ?? []).toList();
    selectedEducation = profile?.educationLevel;

    /// 🔥 Load location data SAFE
    _initLocationData();
  }

  Future<void> _initLocationData() async {
    if (!mounted) return;

    final provider = context.read<EditProfileProvider>();
    final today = DateTime.now().toIso8601String().split("T").first;

    try {
      /// 1. Fetch provinces
      await provider.fetchProvinces("2026-04-30");

      final provinces = provider.provinces;
      if (provinces == null || provinces.isEmpty) return;

      /// 2. Map province từ name → code
      final province = provinces.firstWhereOrNull(
        (p) => p.name == selectedProvinceName,
      );

      if (province == null) return;

      selectedProvinceCode = province.code;

      /// 3. Fetch communes nếu có provinceCode
      final code = selectedProvinceCode;
      if (code == null) return;

      await provider.fetchCommunes(today, code);

      final communes = provider.communes;
      if (communes == null || communes.isEmpty) return;

      /// 4. Map commune
      final commune = communes.firstWhereOrNull(
        (c) =>
            c.name == selectedCommuneName &&
            c.provinceName == selectedProvinceName,
      );

      if (commune != null) {
        selectedCommuneCode = commune.code;
      }

      /// 5. Update UI
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      debugPrint("Init location error: $e");
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
    FocusManager.instance.primaryFocus?.unfocus();

    if (!_formKey.currentState!.validate()) return;

    final user = context.read<UserProvider>().user;
    if (user == null) return;

    final provider = context.read<EditProfileProvider>();

    if (selectedProvinceCode != null && selectedCommuneCode == null) {
      showMsg(context, "Vui lòng chọn quận/huyện", false);
      return;
    }

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
        jobTitle: jobController.text,
        educationLevel: selectedEducation,
        height: int.tryParse(heightController.text),
        weight: int.tryParse(weightController.text),
        city: selectedProvinceName,
        district: selectedCommuneName,
        favoritePets: favoritePets,
        hasPet: hasPet,
        smoking: smoking,
        interests: interests,
      );

      if (!mounted) return;

      if (success) {
        await context.read<UserProvider>().fetchMe();
        if (!mounted) return;
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
      backgroundColor: const Color(0xFFF9F9FB),
      appBar: AppBar(
        title: const Text("Chỉnh sửa hồ sơ"),
        backgroundColor: Colors.white,
      ),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        behavior: HitTestBehavior.translucent,
        child: Form(
          key: _formKey,
          child: ListView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.all(16),
            children: [
              /// AVATAR
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 55,
                        backgroundColor: Colors.white,
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
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.camera_alt, size: 18),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// BASIC
              editSection("Thông tin cơ bản", [
                inputSection(
                  fullNameController,
                  "Họ và tên",
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return "Không được để trống";
                    }
                    return null;
                  },
                ),
                inputSection(
                  phoneController,
                  "SĐT",
                  type: TextInputType.phone,
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return "Không được để trống";
                    }
                    if (!RegExp(r'^[0-9]{9,11}$').hasMatch(v)) {
                      return "SĐT không hợp lệ";
                    }
                    return null;
                  },
                ),
                GestureDetector(
                  onTap: _pickDate,
                  child: boxSection(
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
                inputSection(bioController, "Bio"),
                const SizedBox(height: 10),
                GenderPickerField(
                  value: gender,
                  onChanged: (val) => setState(() => gender = val),
                ),
              ]),

              /// INTEREST
              editSection("Sở thích (${interests.length}/5)", [
                GestureDetector(
                  onTap: _openInterestPicker,
                  child: boxSection(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          interests.isEmpty
                              ? "Chọn sở thích"
                              : "${interests.length} sở thích đã chọn",
                        ),
                        const Icon(Icons.arrow_forward_ios, size: 16),
                      ],
                    ),
                  ),
                ),
                if (interests.isNotEmpty)
                  Wrap(
                    spacing: 6,
                    children: interests
                        .map(
                          (e) => Chip(
                            label: Text(e),
                            backgroundColor: const Color(0xFFF1F2F6),
                          ),
                        )
                        .toList(),
                  ),
              ]),

              editSection("Trình độ học vấn", [
                EducationPickerField(
                  value: selectedEducation,
                  options: educationOptions,
                  onChanged: (val) => setState(() => selectedEducation = val),
                ),
              ]),

              editSection("Công việc", [
                JobPickerField(
                  value: jobController.text.isEmpty ? null : jobController.text,
                  options: provider.jobTitles ?? [],
                  onChanged: (val) {
                    setState(() {
                      jobController.text = val;
                    });
                  },
                ),
              ]),

              /// BODY
              editSection("Cơ thể", [
                inputSection(
                  heightController,
                  "Chiều cao (cm)",
                  type: TextInputType.number,
                  suffix: "cm",
                  validator: (v) {
                    if (v == null || v.isEmpty) return null;
                    final h = int.tryParse(v);
                    if (h == null) return "Sai định dạng";
                    if (h < 100 || h > 250) return "Không hợp lệ";
                    return null;
                  },
                ),
                inputSection(
                  weightController,
                  "Cân nặng (kg)",
                  type: TextInputType.number,
                  suffix: "kg",
                  validator: (v) {
                    if (v == null || v.isEmpty) return null;
                    final w = int.tryParse(v);
                    if (w == null) return "Sai định dạng";
                    if (w < 30 || w > 200) return "Không hợp lệ";
                    return null;
                  },
                ),
              ]),

              /// LOCATION
              editSection("Địa chỉ", [
                ProvincePickerField(
                  value: selectedProvinceName,
                  provider: provider,
                  onSelected: (p) async {
                    final code = p.code;

                    setState(() {
                      selectedProvinceCode = code;
                      selectedProvinceName = p.name;
                      selectedCommuneCode = null;
                      selectedCommuneName = null;
                    });

                    if (code == null) return;

                    await provider.fetchCommunes(
                      DateTime.now().toIso8601String().split("T").first,
                      code,
                    );
                  },
                ),

                CommunePickerField(
                  value: selectedCommuneName,
                  provinceCode: selectedProvinceCode,
                  provider: provider,
                  onSelected: (c) {
                    setState(() {
                      selectedCommuneCode = c.code;
                      selectedCommuneName = c.name;
                    });
                  },
                ),
              ]),

              /// PET
              editSection("Thú cưng yêu thích", [
                GestureDetector(
                  onTap: _openPetPicker,
                  child: boxSection(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          favoritePets.isEmpty
                              ? "Chọn thú cưng"
                              : "${favoritePets.length} đã chọn",
                        ),
                        const Icon(Icons.arrow_forward_ios, size: 16),
                      ],
                    ),
                  ),
                ),
                if (favoritePets.isNotEmpty)
                  Wrap(
                    spacing: 6,
                    children: favoritePets
                        .map(
                          (e) => Chip(
                            label: Text(e),
                            backgroundColor: const Color(0xFFF1F2F6),
                          ),
                        )
                        .toList(),
                  ),
              ]),

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

              GestureDetector(
                onTap: provider.isLoading ? null : _submit,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: provider.isLoading
                        ? const LinearGradient(
                            colors: [Colors.grey, Colors.grey],
                          )
                        : const LinearGradient(
                            colors: [
                              Color(0xFF8093F1),
                              Color(0xFFB388EB),
                              Color(0xFFF7AEF8),
                            ],
                          ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFB388EB).withOpacity(0.4),
                        blurRadius: 15,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Center(
                    child: provider.isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "Lưu thay đổi",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
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
}
