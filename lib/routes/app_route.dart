import 'package:couple_mood_mobile/providers/date_plan_provider.dart';
import 'package:couple_mood_mobile/providers/collection/collection_provider.dart';
import 'package:couple_mood_mobile/providers/member_provider.dart';
import 'package:couple_mood_mobile/providers/test_provider.dart';
import 'package:couple_mood_mobile/screens/datePlanItem/chooseLocation/choose_location_screen.dart';
import 'package:couple_mood_mobile/screens/datePlanItem/createDatePlanItem/create_date_plan_item_screen.dart';
import 'package:couple_mood_mobile/screens/dateplan/createDatePlan/create_date_plan_screen.dart';
import 'package:couple_mood_mobile/screens/dateplan/datePlan/date_plan_screen.dart';
import 'package:couple_mood_mobile/screens/datePlanItem/datePlanItem/date_plan_item_screen.dart';
import 'package:couple_mood_mobile/screens/datePlanItem/updateDatePlanItem/edit_date_plan_item_screen.dart';
import 'package:couple_mood_mobile/screens/dateplan/updateDatePlan/date_plan_edit_screen.dart';
import 'package:couple_mood_mobile/screens/collection/collection_list_screen.dart';
import 'package:couple_mood_mobile/screens/collection/collection_detail_screen.dart';
import 'package:couple_mood_mobile/providers/collection/collection_detail_provider.dart';
import 'package:couple_mood_mobile/screens/invite/invite_screen.dart';
import 'package:couple_mood_mobile/screens/location/filter_location_screen.dart';
import 'package:couple_mood_mobile/screens/profile/profile_screen.dart';
import 'package:couple_mood_mobile/screens/subscriptions/subscriptions_screen.dart';
import 'package:couple_mood_mobile/screens/test/test_detail_screen.dart';
import 'package:couple_mood_mobile/screens/test/test_result_screen.dart';
import 'package:couple_mood_mobile/screens/test/test_type_screen.dart';
import 'package:couple_mood_mobile/screens/venue/venue_detail_screen.dart';
import 'package:couple_mood_mobile/screens/chat/conversation_list_screen.dart';
import 'package:couple_mood_mobile/widgets/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:couple_mood_mobile/providers/auth_provider.dart';
import 'package:couple_mood_mobile/providers/mood_provider.dart';
import 'package:couple_mood_mobile/providers/recommendation_provider.dart';

import 'package:couple_mood_mobile/screens/auth/login_screen.dart';
import 'package:couple_mood_mobile/screens/auth/register_screen.dart';

import 'package:couple_mood_mobile/screens/mood/choose_mood_screen.dart';
import 'package:couple_mood_mobile/screens/mood/choose_mood_method_screen.dart';
import 'package:couple_mood_mobile/screens/mood/emotion_camera_screen.dart';

import 'package:couple_mood_mobile/screens/home/home_screen.dart';
import 'package:couple_mood_mobile/screens/location/list_location_screen.dart';

final _rootNavKey = GlobalKey<NavigatorState>();
final _homeTabNavKey = GlobalKey<NavigatorState>();
final _searchTabNavKey = GlobalKey<NavigatorState>();
final _chatTabNavKey = GlobalKey<NavigatorState>();
final _hotTabNavKey = GlobalKey<NavigatorState>();
final _worldTabNavKey = GlobalKey<NavigatorState>();
final _collectionTabNavKey = GlobalKey<NavigatorState>();
final _profileTabNavKey = GlobalKey<NavigatorState>();

GoRouter createRouter(BuildContext context) {
  final auth = context.read<AuthProvider>();

  return GoRouter(
    navigatorKey: _rootNavKey,
    initialLocation: '/splash',
    // để router refresh khi auth notifyListeners
    refreshListenable: auth,

    redirect: (ctx, state) {
      final isLoggedIn = auth.isLoggedIn; // bạn tự map theo provider của bạn
      final loc = state.uri.toString();

      final isAuthRoute =
          loc.startsWith('/login') || loc.startsWith('/register');
      final isSplash = loc == '/splash';

      // Nếu đang splash thì để Splash tự quyết (hoặc redirect theo auth)
      if (isSplash) {
        return null;
      }

      // Chưa login mà không ở auth routes => đá về login
      if (!isLoggedIn && !isAuthRoute) return '/login';

      // Đã login mà còn ở login/register => đá về home
      if (isLoggedIn && isAuthRoute) return '/home';

      return null;
    },

    routes: [
      // Splash route (ngoài shell)
      GoRoute(
        parentNavigatorKey: _rootNavKey,
        path: '/splash',
        name: 'splash',
        pageBuilder: (_, __) => const MaterialPage(child: SplashScreen()),
      ),

      // Auth routes (ngoài shell)
      GoRoute(
        parentNavigatorKey: _rootNavKey,
        path: '/login',
        name: 'login',
        pageBuilder: (_, __) => const MaterialPage(child: LoginScreen()),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavKey,
        path: '/register',
        name: 'register',
        pageBuilder: (_, __) => const MaterialPage(child: RegisterScreen()),
      ),

      /// SHELL: sau khi login mới vào đây => có bottom bar
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShell(navigationShell: navigationShell); // MainLayout mới
        },
        branches: [
          // TAB 0: Home + ListLocation (có bottom bar)
          StatefulShellBranch(
            navigatorKey: _homeTabNavKey,
            routes: [
              GoRoute(
                path: '/home',
                name: 'home',
                pageBuilder: (_, __) =>
                    const NoTransitionPage(child: HomeScreen()),
              ),
              GoRoute(
                path: '/list-location',
                name: 'listLocation',
                pageBuilder: (_, __) => NoTransitionPage(
                  child: MultiProvider(
                    providers: [
                      ChangeNotifierProvider(
                        create: (_) => RecommendationProvider(),
                      ),
                      ChangeNotifierProvider(create: (_) => MoodProvider()),
                    ],
                    child: const ListLocationScreen(),
                  ),
                ),
              ),

              GoRoute(
                path: '/test',
                name: 'test',
                pageBuilder: (_, __) => NoTransitionPage(
                  child: ChangeNotifierProvider(
                    create: (_) => TestProvider(),
                    child: const TestTypeScreen(),
                  ),
                ),
              ),
            ],
          ),

          // TAB 1..6: giữ đủ như bạn (placeholder hoặc màn thật)
          StatefulShellBranch(
            navigatorKey: _searchTabNavKey,
            routes: [
              GoRoute(
                path: '/search',
                name: 'search',
                pageBuilder: (_, __) =>
                    const NoTransitionPage(child: _Placeholder('Search')),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _chatTabNavKey,
            routes: [
              GoRoute(
                path: '/chat',
                name: 'chat',
                pageBuilder: (_, __) =>
                    const NoTransitionPage(child: ConversationListScreen()),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _hotTabNavKey,
            routes: [
              GoRoute(
                path: '/hot',
                name: 'hot',
                pageBuilder: (_, __) =>
                    const NoTransitionPage(child: _Placeholder('Hot')),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _worldTabNavKey,
            routes: [
              GoRoute(
                path: '/world',
                name: 'world',
                pageBuilder: (_, __) =>
                    const NoTransitionPage(child: _Placeholder('World')),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _collectionTabNavKey,
            routes: [
              GoRoute(
                path: '/date-plan',
                name: 'datePlan',
                pageBuilder: (_, __) => NoTransitionPage(
                  child: MultiProvider(
                    providers: [
                      ChangeNotifierProvider(create: (_) => DatePlanProvider()),
                    ],
                    child: const DatePlanScreen(),
                  ),
                ),
              ),
            ],
          ),

          StatefulShellBranch(
            navigatorKey: _profileTabNavKey,
            routes: [
              GoRoute(
                path: '/profile',
                name: 'profile',
                pageBuilder: (_, __) =>
                    const NoTransitionPage(child: ProfileScreen()),
              ),
            ],
          ),
        ],
      ),

      /// Mood flow ngoài shell => ẩn bottom bar
      ShellRoute(
        parentNavigatorKey:
            _rootNavKey, // ngoài main shell => không có bottom bar
        builder: (context, state, child) {
          return ChangeNotifierProvider(
            create: (_) => MoodProvider(),
            child: child, // các màn con sẽ dùng CHUNG provider này
          );
        },
        routes: [
          GoRoute(
            path: '/mood/icon',
            name: 'moodChooseByIcon',
            pageBuilder: (_, __) =>
                const MaterialPage(child: ChooseMoodScreen()),
          ),
          GoRoute(
            path: '/mood/method',
            name: 'moodChooseMethod',
            pageBuilder: (_, __) =>
                const MaterialPage(child: ChooseMoodMethodScreen()),
          ),
          GoRoute(
            path: '/mood/camera',
            name: 'emotionCamera',
            pageBuilder: (_, __) =>
                const MaterialPage(child: EmotionCameraScreen()),
          ),
        ],
      ),
      GoRoute(
        parentNavigatorKey: _rootNavKey,
        path: '/subscriptions',
        name: 'subscriptions',
        pageBuilder: (_, __) {
          return const MaterialPage(child: SubscriptionsScreen());
        },
      ),
      GoRoute(
        path: '/filter-location',
        name: 'filter_location',
        pageBuilder: (_, __) {
          return const NoTransitionPage(child: FilterLocationScreen());
        },
      ),
      ShellRoute(
        parentNavigatorKey: _rootNavKey,
        builder: (context, state, child) {
          return ChangeNotifierProvider(
            create: (_) => TestProvider(),
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: '/test-detail',
            name: 'test_detail',
            pageBuilder: (_, __) =>
                const MaterialPage(child: TestDetailScreen()),
          ),
          GoRoute(
            path: '/test-result',
            name: 'test_result',
            pageBuilder: (_, __) =>
                const MaterialPage(child: TestResultScreen()),
          ),
        ],
      ),
      GoRoute(
        parentNavigatorKey: _rootNavKey,
        path: '/venue-detail',
        name: 'venue_detail',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return VenueDetailScreen(venueId: extra['venueId']);
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavKey,
        path: '/invite',
        name: 'invite',
        pageBuilder: (_, __) => NoTransitionPage(
          child: ChangeNotifierProvider(
            create: (_) => MemberProvider(),
            child: InviteScreen(),
          ),
        ),
      ),
      GoRoute(
        path: '/create-date-plan',
        name: 'create_date_plan',
        pageBuilder: (_, __) =>
            const NoTransitionPage(child: CreateDatePlanScreen()),
      ),
      GoRoute(
        path: '/date-plan/date-plan-item',
        name: 'date_plan_item',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return DatePlanItemScreen(datePlanId: extra['datePlanId']);
        },
      ),
      GoRoute(
        path: '/date-plan/edit',
        name: 'date_plan_edit',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return UpdateDatePlanScreen(datePlanId: extra['datePlanId']);
        },
      ),
      GoRoute(
        path: '/date-plan/date-plan-item/create',
        name: 'date_plan_item_create',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return CreateDatePlanItemScreen(datePlanId: extra['datePlanId']);
        },
      ),
      GoRoute(
        path: '/date-plan/date-plan-item/choose-location',
        name: 'choose_location',
        pageBuilder: (_, __) {
          return const NoTransitionPage(child: ChooseLocationScreen());
        },
      ),
      GoRoute(
        path: '/date-plan/date-plan-item/edit',
        name: 'date_plan_item_edit',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return EditDatePlanItemScreen(
            datePlanItemId: extra['datePlanItemId'],
            datePlanId: extra['datePlanId'],
          );
        },
      ),

      ShellRoute(
        parentNavigatorKey: _rootNavKey,
        builder: (context, state, child) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => CollectionProvider()),
            ],
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: '/collections',
            name: 'collections',
            pageBuilder: (_, __) =>
                const MaterialPage(child: CollectionListScreen()),
          ),
          GoRoute(
            path: '/collections/detail',
            name: 'collection_detail',
            pageBuilder: (context, state) {
              final extra = state.extra as Map<String, dynamic>;
              return MaterialPage(
                child: ChangeNotifierProvider(
                  create: (_) => CollectionDetailProvider(),
                  child: CollectionDetailScreen(
                    collectionId: extra['collectionId'],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    ],
  );
}

class MainShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  const MainShell({super.key, required this.navigationShell});

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 6.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.local_fire_department_rounded),
              color: const Color(0xFF7B8CE4),
              onPressed: () => _onTap(3),
            ),
            IconButton(
              icon: const Icon(Icons.search),
              color: const Color(0xFF7B8CE4),
              onPressed: () => _onTap(1),
            ),
            IconButton(
              icon: const Icon(Icons.chat_outlined),
              color: const Color(0xFF7B8CE4),
              // mở mood flow ngoài shell => ẩn bottom bar
              onPressed: () => _onTap(2),
            ),
            IconButton(
              icon: const Icon(Icons.home_outlined),
              color: const Color(0xFF7B8CE4),
              onPressed: () => _onTap(0),
            ),
            IconButton(
              icon: const Icon(Icons.south_america_outlined),
              color: const Color(0xFF7B8CE4),
              onPressed: () => _onTap(4),
            ),
            IconButton(
              icon: const Icon(Icons.collections_outlined),
              color: const Color(0xFF7B8CE4),
              onPressed: () => _onTap(5),
            ),
            IconButton(
              icon: const Icon(Icons.person_outline),
              color: const Color(0xFF7B8CE4),
              onPressed: () => _onTap(6),
            ),
          ],
        ),
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  final String title;
  const _Placeholder(this.title);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text('$title (todo)')),
    );
  }
}
