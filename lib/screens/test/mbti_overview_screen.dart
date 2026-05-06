import 'package:couple_mood_mobile/models/test/test_description.dart';
import 'package:couple_mood_mobile/providers/test_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MbtiOverviewScreen extends StatefulWidget {
  const MbtiOverviewScreen({super.key});

  @override
  State<MbtiOverviewScreen> createState() => _MbtiOverviewScreenState();
}

class _MbtiOverviewScreenState extends State<MbtiOverviewScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = context.read<TestProvider>();
      await provider.fetchTestDescription();
      await provider.getMyPersonalityType();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TestProvider>();

    if (provider.isLoading || provider.testDescription == null) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final list = [...provider.testDescription!];
    final myCode = provider.personalityType?.resultCode;

    list.sort((a, b) {
      final aCode = a.code ?? "";
      final bCode = b.code ?? "";

      if (myCode != null) {
        if (aCode == myCode) return -1;
        if (bCode == myCode) return 1;
      }

      return aCode.compareTo(bCode);
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text("16 Nhóm tính cách"),
        backgroundColor: const Color(0xFFFDFDFD),
      ),
      backgroundColor: const Color(0xFFF7F0FF),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: list.length,
        itemBuilder: (context, index) {
          final type = list[index];

          return _buildCard(type, myCode);
        },
      ),
    );
  }

  Widget _buildCard(TestDescription type, String? myCode) {
    final code = type.code;
    final isMine = myCode != null && code == myCode;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: isMine ? const Color(0xFFB388EB) : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.network(
                type.imageUrl ?? "",
                height: 50,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.image_not_supported, size: 50);
                },
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      type.code ?? "",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isMine ? Colors.white : Colors.black,
                      ),
                    ),

                    Text(
                      type.name ?? "",
                      style: TextStyle(
                        fontSize: 14,
                        color: isMine
                            ? Colors.white.withOpacity(0.9)
                            : Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),

              if (isMine)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "Của bạn",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 14),

          Text(
            type.definition ?? "",
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
              color: isMine ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
