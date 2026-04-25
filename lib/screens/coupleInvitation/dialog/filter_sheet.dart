import 'package:couple_mood_mobile/models/coupleInvitation/member_filter.dart';
import 'package:couple_mood_mobile/providers/user/edit_profile_provider.dart';
import 'package:couple_mood_mobile/screens/coupleInvitation/widget/filter/filter_section.dart';
import 'package:couple_mood_mobile/screens/coupleInvitation/widget/filter/picker_field.dart';
import 'package:couple_mood_mobile/screens/coupleInvitation/widget/filter/range_filter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FilterSheet extends StatefulWidget {
  final Function(MemberFilter) onApply;
  final MemberFilter? initialFilter;

  const FilterSheet({
    super.key,
    required this.onApply,
    this.initialFilter,
  });

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

    /// auto bật nếu có data
    useAge = f?.ageFrom != null || f?.ageTo != null;
    useHeight = f?.heightFrom != null || f?.heightTo != null;
    useWeight = f?.weightFrom != null || f?.weightTo != null;
    useLocation = f?.city != null || f?.district != null;
    useJob = f?.jobTitle != null;
    useInterest = f?.interest != null;
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

                FilterSection(
                  title: "Địa điểm",
                  enabled: useLocation,
                  onToggle: (v) => setState(() => useLocation = v),
                  child: Column(
                    children: [
                      TextField(
                        decoration: const InputDecoration(labelText: "Thành phố"),
                        onChanged: (v) => city = v,
                        controller: TextEditingController(text: city),
                      ),
                      TextField(
                        decoration: const InputDecoration(labelText: "Quận"),
                        onChanged: (v) => district = v,
                        controller: TextEditingController(text: district),
                      ),
                    ],
                  ),
                ),

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

                FilterSection(
                  title: "Sở thích",
                  enabled: useInterest,
                  onToggle: (v) => setState(() => useInterest = v),
                  child: PickerField(
                    value: selectedInterest,
                    items: provider.interests
                            ?.map((e) => e.name!)
                            .toList() ??
                        [],
                    title: "Chọn sở thích",
                    onSelected: (v) => setState(() => selectedInterest = v),
                  ),
                ),
              ],
            ),
          ),

          _applyButton(),
        ],
      ),
    );
  }

  Widget _applyButton() {
    return GestureDetector(
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
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [Color(0xFF8093F1), Color(0xFFB388EB), Color(0xFFF7AEF8)],
          ),
        ),
        child: const Center(
          child: Text(
            "Áp dụng",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}