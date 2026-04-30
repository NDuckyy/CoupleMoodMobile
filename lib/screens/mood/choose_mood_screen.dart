import 'package:couple_mood_mobile/models/mood/mood_type.dart';
import 'package:couple_mood_mobile/providers/auth_provider.dart';
import 'package:couple_mood_mobile/providers/mood_provider.dart';
import 'package:couple_mood_mobile/screens/mood/widgets/mood_carousel.dart';
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
  MoodType? selectedMood;
  bool isLoading = false;

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
    } catch (e) {
      if (!mounted) return;
      showMsg(context, "Lấy danh sách mood thất bại", false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final moodProvider = context.watch<MoodProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chọn tâm trạng'),
        backgroundColor: const Color(0xFFFDFDFD),
      ),
      backgroundColor: const Color(0xFFF7F0FF),

      body: Center(
        child: moodProvider.isLoading
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Hôm nay bạn cảm thấy thế nào?',
                    style: GoogleFonts.balooChettan2(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    'Chọn tâm trạng phù hợp để khám phá địa điểm lý tưởng 💜',
                    style: TextStyle(color: Colors.grey[600]),
                  ),

                  const SizedBox(height: 30),

                  MoodCarousel(
                    moods: moodProvider.moodTypes.data!,
                    onSelect: (m) {
                      setState(() {
                        selectedMood = m;
                      });
                    },
                  ),

                  const SizedBox(height: 20),

                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: selectedMood == null
                        ? const SizedBox()
                        : Text(
                            'Bạn đang chọn: ${selectedMood!.name}',
                            key: ValueKey(selectedMood!.id),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                  ),

                  const SizedBox(height: 30),

                  AnimatedOpacity(
                    opacity: selectedMood == null ? 0.5 : 1,
                    duration: const Duration(milliseconds: 200),
                    child: SizedBox(
                      width: 220,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: selectedMood == null || isLoading
                            ? null
                            : () async {
                                setState(() => isLoading = true);

                                try {
                                  await context.read<MoodProvider>().updateMood(
                                    selectedMood!.id,
                                  );

                                  if (!context.mounted) return;

                                  context.goNamed("listLocation");
                                } catch (e) {
                                  if (!context.mounted) return;
                                  showMsg(context, "Lỗi: $e", false);
                                } finally {
                                  if (mounted) {
                                    setState(() => isLoading = false);
                                  }
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF8093F1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                "Xác nhận",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
