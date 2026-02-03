import 'package:couple_mood_mobile/providers/auth_provider.dart';
import 'package:couple_mood_mobile/providers/mood_provider.dart';
import 'package:couple_mood_mobile/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ChooseMoodScreen extends StatefulWidget {
  const ChooseMoodScreen({super.key});

  @override
  State<ChooseMoodScreen> createState() => _ChooseMoodScreenState();
}

class _ChooseMoodScreenState extends State<ChooseMoodScreen> {
  @override
  void initState() {
    super.initState();
    final gender = context.read<AuthProvider>().session?.gender ?? 'MALE';
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadMood(context.read<MoodProvider>(), gender);
    });
  }

  Future<void> _loadMood(MoodProvider moodProvider, String gender) async {
    try {
      await moodProvider.getMoodTypes(gender);
      if (!mounted) return;
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lấy danh sách mood thất bại: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final moodProvider = context.watch<MoodProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Quay lại')),
      body: Center(
        child: moodProvider.isLoading
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'lib/assets/images/register.png',
                    width: 70,
                    height: 70,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Hãy chọn mood của bạn',
                    style: GoogleFonts.balooChettan2(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 20,
                    runSpacing: 20,
                    children: [
                      for (final m in moodProvider.moodTypes)
                        _moodItem(
                          iconUrl: m.iconUrl,
                          name: m.name,
                          onTap: () {
                            final moodProvider = context.read<MoodProvider>();
                            moodProvider
                                .updateMood(m.id)
                                .then((_) {
                                  if (!context.mounted) return;
                                  showMsg(context, "Cập nhật mood thành công", true);
                                  context.goNamed("listLocation");
                                })
                                .catchError((e) {
                                  if (!context.mounted) return;
                                  showMsg(
                                    context,
                                    'Cập nhật mood thất bại: $e',
                                    false,
                                  );
                                });
                          },
                        ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }

  Widget _moodItem({
    required String name,
    required String iconUrl,
    required VoidCallback onTap,
  }) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      ),
      onPressed: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.network(
            iconUrl,
            width: 70,
            height: 70,
            errorBuilder: (_, __, ___) =>
                const Icon(Icons.broken_image, size: 70),
            loadingBuilder: (context, child, progress) {
              if (progress == null) return child;
              return const SizedBox(
                width: 70,
                height: 70,
                child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
              );
            },
          ),
          const SizedBox(height: 6),
          Text(name),
        ],
      ),
    );
  }
}
