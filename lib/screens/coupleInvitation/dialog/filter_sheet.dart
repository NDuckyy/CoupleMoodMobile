import 'package:couple_mood_mobile/models/coupleInvitation/member_filter.dart';
import 'package:couple_mood_mobile/models/coupleInvitation/provinces.dart';
import 'package:couple_mood_mobile/models/coupleInvitation/communes.dart';
import 'package:couple_mood_mobile/providers/user/edit_profile_provider.dart';
import 'package:couple_mood_mobile/screens/coupleInvitation/widget/filter/filter_section.dart';
import 'package:couple_mood_mobile/screens/coupleInvitation/widget/filter/picker_field.dart';
import 'package:couple_mood_mobile/screens/coupleInvitation/widget/filter/range_filter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FilterSheet extends StatefulWidget {
  final Function(MemberFilter) onApply;
  final MemberFilter? initialFilter;

  const FilterSheet({super.key, required this.onApply, this.initialFilter});

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  late RangeValues ageRange;
  late RangeValues heightRange;
  late RangeValues weightRange;

  String? city;
  String? district;
  String? selectedJob;
  String? selectedInterest;

  String? provinceCode;

  bool useAge = false;
  bool useHeight = false;
  bool useWeight = false;
  bool useLocation = false;
  bool useJob = false;
  bool useInterest = false;

  @override
  void initState() {
    super.initState();

    final f = widget.initialFilter;

    ageRange = RangeValues(
      (f?.ageFrom ?? 18).toDouble(),
      (f?.ageTo ?? 30).toDouble(),
    );

    heightRange = RangeValues(
      (f?.heightFrom ?? 150).toDouble(),
      (f?.heightTo ?? 180).toDouble(),
    );

    weightRange = RangeValues(
      (f?.weightFrom ?? 45).toDouble(),
      (f?.weightTo ?? 70).toDouble(),
    );

    city = f?.city;
    district = f?.district;
    selectedJob = f?.jobTitle;
    selectedInterest = f?.interest;

    useAge = f?.ageFrom != null || f?.ageTo != null;
    useHeight = f?.heightFrom != null || f?.heightTo != null;
    useWeight = f?.weightFrom != null || f?.weightTo != null;
    useLocation = f?.city != null || f?.district != null;
    useJob = f?.jobTitle != null;
    useInterest = f?.interest != null;

    Future.microtask(() {
      final provider = context.read<EditProfileProvider>();
      provider.fetchProvinces(
        DateTime.now().toIso8601String().split("T").first,
      );
    });
  }

  /// ================= PROVINCE =================
  Future<void> _openProvincePicker() async {
    final provider = context.read<EditProfileProvider>();
    final baseList = provider.provinces ?? [];

    String query = "";

    final result = await showModalBottomSheet<Provinces>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            final filtered = baseList
                .where(
                  (p) => p.name.toLowerCase().contains(query.toLowerCase()),
                )
                .toList();

            return SafeArea(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.7,
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 10),

                    Container(
                      height: 5,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      "Chọn tỉnh/thành",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextField(
                        onChanged: (v) => setState(() => query = v),
                        decoration: InputDecoration(
                          hintText: "Tìm kiếm...",
                          prefixIcon: const Icon(Icons.search),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    /// LIST
                    Expanded(
                      child: ListView.builder(
                        itemCount: filtered.length,
                        itemBuilder: (_, i) {
                          final p = filtered[i];
                          return ListTile(
                            title: Text(p.name),
                            onTap: () => Navigator.pop(context, p),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    if (result != null) {
      setState(() {
        city = result.name;
        provinceCode = result.code;
        district = null;
      });

      await provider.fetchCommunes(
        DateTime.now().toIso8601String().split("T").first,
        provinceCode!,
      );
    }
  }

  /// ================= COMMUNE =================
  Future<void> _openCommunePicker() async {
    if (provinceCode == null) return;

    final provider = context.read<EditProfileProvider>();
    final baseList = provider.communes ?? [];

    String query = "";

    final result = await showModalBottomSheet<Communes>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            final filtered = baseList
                .where(
                  (c) => c.name.toLowerCase().contains(query.toLowerCase()),
                )
                .toList();

            return SafeArea(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.7,
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 10),

                    Container(
                      height: 5,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      "Chọn phường",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 12),

                    /// SEARCH đẹp
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextField(
                        onChanged: (v) => setState(() => query = v),
                        decoration: InputDecoration(
                          hintText: "Tìm kiếm...",
                          prefixIcon: const Icon(Icons.search),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    Expanded(
                      child: ListView.builder(
                        itemCount: filtered.length,
                        itemBuilder: (_, i) {
                          final c = filtered[i];
                          return ListTile(
                            title: Text(c.name),
                            onTap: () => Navigator.pop(context, c),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    if (result != null) {
      setState(() {
        district = result.name;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<EditProfileProvider>();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        color: Color(0xFFF9F9FB),
      ),
      child: Column(
        children: [
          const SizedBox(height: 6),
          Container(
            height: 5,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          const SizedBox(height: 12),

          const Text(
            "Bộ lọc",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 16),

          Expanded(
            child: ListView(
              children: [
                /// AGE
                FilterSection(
                  title: "Tuổi",
                  enabled: useAge,
                  onToggle: (v) => setState(() => useAge = v),
                  child: RangeFilter(
                    values: ageRange,
                    min: 18,
                    max: 60,
                    onChanged: (v) => setState(() => ageRange = v),
                  ),
                ),

                /// HEIGHT
                FilterSection(
                  title: "Chiều cao",
                  enabled: useHeight,
                  onToggle: (v) => setState(() => useHeight = v),
                  child: RangeFilter(
                    values: heightRange,
                    min: 140,
                    max: 200,
                    onChanged: (v) => setState(() => heightRange = v),
                  ),
                ),

                /// WEIGHT
                FilterSection(
                  title: "Cân nặng",
                  enabled: useWeight,
                  onToggle: (v) => setState(() => useWeight = v),
                  child: RangeFilter(
                    values: weightRange,
                    min: 40,
                    max: 100,
                    onChanged: (v) => setState(() => weightRange = v),
                  ),
                ),

                /// LOCATION
                FilterSection(
                  title: "Địa điểm",
                  enabled: useLocation,
                  onToggle: (v) => setState(() => useLocation = v),
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(city ?? "Chọn tỉnh/thành"),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: _openProvincePicker,
                      ),
                      ListTile(
                        title: Text(
                          provinceCode == null
                              ? "Chọn tỉnh trước"
                              : (district ?? "Chọn phường"),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: provinceCode == null ? null : _openCommunePicker,
                      ),
                    ],
                  ),
                ),

                /// JOB
                FilterSection(
                  title: "Nghề nghiệp",
                  enabled: useJob,
                  onToggle: (v) => setState(() => useJob = v),
                  child: PickerField(
                    value: selectedJob,
                    items: provider.jobTitles ?? [],
                    title: "Chọn nghề",
                    onSelected: (v) => setState(() => selectedJob = v),
                  ),
                ),

                /// INTEREST
                FilterSection(
                  title: "Sở thích",
                  enabled: useInterest,
                  onToggle: (v) => setState(() => useInterest = v),
                  child: PickerField(
                    value: selectedInterest,
                    items:
                        provider.interests?.map((e) => e.name!).toList() ?? [],
                    title: "Chọn sở thích",
                    onSelected: (v) => setState(() => selectedInterest = v),
                  ),
                ),
              ],
            ),
          ),

          /// APPLY
          GestureDetector(
            onTap: () {
              widget.onApply(
                MemberFilter(
                  ageFrom: useAge ? ageRange.start.toInt() : null,
                  ageTo: useAge ? ageRange.end.toInt() : null,
                  heightFrom: useHeight ? heightRange.start.toInt() : null,
                  heightTo: useHeight ? heightRange.end.toInt() : null,
                  weightFrom: useWeight ? weightRange.start.toInt() : null,
                  weightTo: useWeight ? weightRange.end.toInt() : null,
                  city: useLocation ? city : null,
                  district: useLocation ? district : null,
                  jobTitle: useJob ? selectedJob : null,
                  interest: useInterest ? selectedInterest : null,
                ),
              );

              Navigator.pop(context);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF8093F1),
                    Color(0xFFB388EB),
                    Color(0xFFF7AEF8),
                  ],
                ),
              ),
              child: const Center(
                child: Text(
                  "Áp dụng",
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
    );
  }
}
