import 'package:couple_mood_mobile/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

enum Gender { MALE, FEMALE }

class ChooseMoodScreen extends StatefulWidget {
  const ChooseMoodScreen({super.key});

  @override
  State<ChooseMoodScreen> createState() => _ChooseMoodScreenState();
}

class _ChooseMoodScreenState extends State<ChooseMoodScreen> {
  Gender gender = Gender.FEMALE;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _loadGender();
  }

  Future<void> _loadGender() async {
    final g =  context.read<AuthProvider>().session?.gender ?? 'MALE';
    print('${g}');

    setState(() {
      gender = (g == 'FEMALE' || g == 'female') ? Gender.FEMALE : Gender.MALE;
      loading = false;
    });
  }

  String moodAsset(String moodKey) {
    final prefix = gender == Gender.MALE ? 'nam_' : 'nu_';
    return 'lib/assets/images/${prefix}$moodKey.png';
  }

  final moods = const [
    ('vui', 'Vui vẻ'),
    ('binh_tinh', 'Bình tĩnh'),
    ('ngac_nhien', 'Ngạc nhiên'),
    ('boi_roi', 'Bối rối'),
    ('buon', 'Buồn'),
    ('kinh_tom', 'Kinh tởm'),
    ('so_hai', 'Sợ hãi'),
    ('gian_du', 'Giận dữ'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quay lại')),
      body: Center(
        child: loading
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
                      for (final m in moods)
                        _moodItem(
                          imagePath: moodAsset(m.$1),
                          label: m.$2,
                          onTap: () {},
                        ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }

  Widget _moodItem({
    required String imagePath,
    required String label,
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
          Image.asset(imagePath, width: 70, height: 70),
          const SizedBox(height: 6),
          Text(label),
        ],
      ),
    );
  }
}
