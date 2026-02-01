import 'package:couple_mood_mobile/providers/auth_provider.dart';
import 'package:couple_mood_mobile/providers/venue_detail_provider.dart';
import 'package:couple_mood_mobile/routes/app_route.dart';
import 'package:couple_mood_mobile/routes/main_layout.dart';
import 'package:couple_mood_mobile/screens/auth/login_screen.dart';
import 'package:couple_mood_mobile/screens/auth/register_screen.dart';
import 'package:couple_mood_mobile/screens/mood/choose_mood_method_screen.dart';
import 'package:couple_mood_mobile/screens/mood/choose_mood_screen.dart';
import 'package:couple_mood_mobile/screens/mood/mood_face_result.dart';
import 'package:couple_mood_mobile/screens/venue/venue_detail_screen.dart';
import 'package:couple_mood_mobile/widgets/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final auth = AuthProvider();
  await auth.init();
  runApp(ChangeNotifierProvider.value(value: auth, child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final GoRouter _router;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // tạo 1 lần
    _router = createRouter(context);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
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
      // Venue Detail (testttt venueId = 1)
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case AppRoutes.venueDetail:
            final venueId = settings.arguments as int;

            return MaterialPageRoute(
              builder: (_) => ChangeNotifierProvider(
                create: (_) => VenueDetailProvider(),
                child: VenueDetailScreen(venueId: venueId),
              ),
            );

          default:
            return null;
        }
      },
    );
  }
}
