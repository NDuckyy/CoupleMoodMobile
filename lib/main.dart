import 'package:couple_mood_mobile/providers/auth_provider.dart';
import 'package:couple_mood_mobile/routes/app_route.dart';
import 'package:couple_mood_mobile/routes/main_layout.dart';
import 'package:couple_mood_mobile/screens/auth/login_screen.dart';
import 'package:couple_mood_mobile/screens/auth/register_screen.dart';
import 'package:couple_mood_mobile/screens/mood/choose_mood_method_screen.dart';
import 'package:couple_mood_mobile/screens/mood/choose_mood_screen.dart';
import 'package:couple_mood_mobile/screens/mood/mood_face_result.dart';
import 'package:couple_mood_mobile/widgets/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print('🔥 Firebase initialized');
  final auth = AuthProvider();
  await auth.init();
  runApp(ChangeNotifierProvider.value(value: auth, child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(),
      home: const SplashScreen(),
      routes: {
        AppRoutes.login: (_) => const LoginScreen(),
        AppRoutes.register: (_) => const RegisterScreen(),
        AppRoutes.home: (_) => const MainLayout(),
        //Mood routes
        AppRoutes.moodChooseByIcon: (_) => const ChooseMoodScreen(),
        AppRoutes.moodChooseMethod: (_) => const ChooseMoodMethodScreen(),
        AppRoutes.moodFaceResult: (_) => const MoodFaceResultScreen(),
      },
    );
  }
}
