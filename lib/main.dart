import 'package:couple_mood_mobile/providers/auth_provider.dart';
import 'package:couple_mood_mobile/providers/date_plan_provider.dart';
import 'package:couple_mood_mobile/providers/chat/chat_provider.dart';
import 'package:couple_mood_mobile/providers/mood_provider.dart';
import 'package:couple_mood_mobile/providers/recommendation_provider.dart';
import 'package:couple_mood_mobile/providers/venue/venue_detail_provider.dart';
import 'package:couple_mood_mobile/routes/app_route.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final auth = AuthProvider();
  await auth.init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: auth),
        ChangeNotifierProvider(create:  (_) => VenueDetailProvider()),
        ChangeNotifierProvider(create: (_) => DatePlanProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(create: (_) => RecommendationProvider()),
        ChangeNotifierProvider(create: (_) => MoodProvider()),
      ],
      child: const MyApp(),
    ),
  );
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
    );
  }
}
