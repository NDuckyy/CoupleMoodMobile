import 'package:couple_mood_mobile/providers/advertisement_provider.dart';
import 'package:couple_mood_mobile/providers/auth_provider.dart';
import 'package:couple_mood_mobile/providers/couple_invitation_provider.dart';
import 'package:couple_mood_mobile/providers/date_plan_provider.dart';
import 'package:couple_mood_mobile/providers/chat/chat_provider.dart';
import 'package:couple_mood_mobile/providers/mood_provider.dart';
import 'package:couple_mood_mobile/providers/notification_provider.dart';
import 'package:couple_mood_mobile/providers/recommendation_provider.dart';
import 'package:couple_mood_mobile/providers/venue/venue_detail_provider.dart';
import 'package:couple_mood_mobile/providers/venue/venue_review_provider.dart';
import 'package:couple_mood_mobile/routes/app_route.dart';
import 'package:couple_mood_mobile/services/location_service.dart';
import 'package:couple_mood_mobile/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'services/local_notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint("🔥 Firebase initialized successfully");
  } catch (e, stack) {
    debugPrint("❌ Firebase init failed: $e");
    debugPrint(stack.toString());
  }
  await NotificationService.requestNotificationPermission();
  await LocalNotificationService.init();
  NotificationService.listenNotification();
  await NotificationService.init();
  await NotificationService().setupInteractedMessage();
  await initializeDateFormatting('vi');
  final auth = AuthProvider();
  await auth.init();
  LocationService.startListening();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: auth),
        ChangeNotifierProvider(create: (_) => VenueDetailProvider()),
        ChangeNotifierProvider(create: (_) => DatePlanProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(create: (_) => RecommendationProvider()),
        ChangeNotifierProvider(create: (_) => MoodProvider()),
        ChangeNotifierProvider(create: (_) => CoupleInvitationProvider()),
        ChangeNotifierProvider(create: (_) => AdvertisementProvider()),
        ChangeNotifierProvider(create: (_) => VenueReviewProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
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
