//bầy con provider
import 'package:couple_mood_mobile/providers/date_plan_provider.dart';

import 'package:couple_mood_mobile/providers/collection/collection_provider.dart';
import 'package:couple_mood_mobile/providers/collection/collection_detail_provider.dart';

import 'package:couple_mood_mobile/providers/member_provider.dart';
import 'package:couple_mood_mobile/providers/post/post_provider.dart';

import 'package:couple_mood_mobile/providers/test_provider.dart';
import 'package:couple_mood_mobile/screens/advertisement/advertisement_detail_screen.dart';
import 'package:couple_mood_mobile/screens/chat/chat_screen.dart';
import 'package:couple_mood_mobile/screens/chat/create_group_screen.dart';
import 'package:couple_mood_mobile/screens/chat/user_search_screen.dart';

//Couple invatation
import 'package:couple_mood_mobile/screens/coupleInvitation/receive_invitation_screen.dart';
import 'package:couple_mood_mobile/screens/coupleInvitation/sent_invitation_screen.dart';
import 'package:couple_mood_mobile/screens/coupleInvitation/member_profile_match_screen.dart';
import 'package:couple_mood_mobile/screens/coupleInvitation/member_search_screen.dart';

//Date plan
import 'package:couple_mood_mobile/screens/datePlanItem/chooseLocation/choose_location_screen.dart';
import 'package:couple_mood_mobile/screens/datePlanItem/createDatePlanItem/create_date_plan_item_screen.dart';
import 'package:couple_mood_mobile/screens/dateplan/createDatePlan/create_date_plan_screen.dart';
import 'package:couple_mood_mobile/screens/dateplan/datePlan/date_plan_screen.dart';
import 'package:couple_mood_mobile/screens/datePlanItem/datePlanItem/date_plan_item_screen.dart';
import 'package:couple_mood_mobile/screens/datePlanItem/updateDatePlanItem/edit_date_plan_item_screen.dart';
import 'package:couple_mood_mobile/screens/dateplan/updateDatePlan/date_plan_edit_screen.dart';

//Collection
import 'package:couple_mood_mobile/screens/collection/collection_list_screen.dart';
import 'package:couple_mood_mobile/screens/collection/collection_detail_screen.dart';
import 'package:couple_mood_mobile/screens/collection/edit_collection_screen.dart';
import 'package:couple_mood_mobile/screens/collection/create_collection_screen.dart';
import 'package:couple_mood_mobile/screens/collection/add_venue_to_collection_screen.dart';

//news, post
import 'package:couple_mood_mobile/screens/feed/news_feed_screen.dart';

// lú quá Nghĩa tự sort lại đi
import 'package:couple_mood_mobile/screens/invite/invite_screen.dart';
import 'package:couple_mood_mobile/screens/location/filter_location_screen.dart';
import 'package:couple_mood_mobile/screens/profile/profile_screen.dart';
import 'package:couple_mood_mobile/screens/review/review_screen.dart';
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
          return DatePlanItemScreen(
            datePlanId: extra['datePlanId'],
            status: extra['status'],
          );
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
      GoRoute(
        path: '/member-search',
        name: 'member_search',
        pageBuilder: (_, __) => const MaterialPage(child: MemberSearchScreen()),
      ),

      GoRoute(
        path: '/receive-invitation',
        name: 'receive_invitation',
        pageBuilder: (_, __) =>
            const MaterialPage(child: ReceiveInvitationScreen()),
      ),

      GoRoute(
        path: '/sent-invitation',
        name: 'sent_invitation',
        pageBuilder: (_, __) =>
            const MaterialPage(child: SentInvitationScreen()),
      ),

      GoRoute(
        path: '/member-profile-match',
        name: 'member_profile_match',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return MemberProfileMatchScreen(userId: extra['userId']);
        },
      ),

      GoRoute(
        path: '/direct',
        name: 'direct',
        pageBuilder: (_, __) => const MaterialPage(child: UserSearchScreen()),
      ),

      GoRoute(
        path: '/group',
        name: 'group',
        pageBuilder: (_, __) => const MaterialPage(child: CreateGroupScreen()),
      ),

      GoRoute(
        path: '/chat-screen',
        name: 'chat_screen',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return ChatScreen(conversation: extra['conversation']);
        },
      ),

      GoRoute(
        parentNavigatorKey: _rootNavKey,
        path: '/review-venue',
        name: 'review_venue',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return ReviewScreen(
            venueLocationId: extra['venueLocationId'],
            checkInId: extra['checkInId'],
          );
        },
      ),
      GoRoute(
        path: '/advertisement-detail',
        name: 'advertisement_detail',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return AdvertisementDetailScreen(
            advertisementId: extra['advertisementId'],
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
          GoRoute(
            path: '/collections/create',
            name: 'create_collection',
            pageBuilder: (_, __) =>
                const MaterialPage(child: CreateCollectionScreen()),
          ),
          GoRoute(
            path: '/collections/edit',
            name: 'edit_collection',
            pageBuilder: (context, state) {
              final extra = state.extra as Map<String, dynamic>;
              return MaterialPage(
                child: EditCollectionScreen(collection: extra['collection']),
              );
            },
          ),
          GoRoute(
            name: 'add_venue_to_collection',
            path: '/collections/add-venue',
            builder: (context, state) {
              final extra = state.extra as Map<String, dynamic>;

              return AddVenueToCollectionScreen(
                collectionId: extra['collectionId'],
                existingVenueIds: List<int>.from(extra['existingIds']),
              );
            },
          ),
        ],
      ),

      ShellRoute(
        parentNavigatorKey: _rootNavKey,
        builder: (context, state, child) {
          return ChangeNotifierProvider(
            create: (_) => PostProvider(),
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: '/newsfeed',
            name: 'newsfeed',
            pageBuilder: (_, __) => const MaterialPage(child: NewsFeedScreen()),
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
    final keyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: navigationShell,

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: keyboardOpen ? null : _buildCenterButton(),

      bottomNavigationBar: keyboardOpen ? null : _buildBottomBar(),
    );
  }

  Widget _buildBottomBar() {
    final currentIndex = navigationShell.currentIndex;

    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 6,
      height: 60,
      child: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildItem(Icons.local_fire_department, 3, currentIndex),
                const SizedBox(width: 16),
                _buildItem(Icons.chat_outlined, 2, currentIndex),
              ],
            ),

            const SizedBox(width: 48),

            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildItem(Icons.calendar_month, 5, currentIndex),
                const SizedBox(width: 16),
                _buildItem(Icons.person_outline, 6, currentIndex),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCenterButton() {
    return Transform.translate(
      offset: const Offset(0, 16),
      child: SizedBox(
        height: 70,
        width: 70,
        child: FloatingActionButton(
          shape: const CircleBorder(),
          elevation: 8,
          backgroundColor: const Color(0xFFB388EB),
          onPressed: () => _onTap(0),
          child: const Icon(Icons.home_outlined, size: 32, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildItem(IconData icon, int index, int currentIndex) {
    final isActive = index == currentIndex;

    return GestureDetector(
      onTap: () => _onTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          gradient: isActive
              ? const LinearGradient(
                  colors: [Color(0xFFB388EB), Color(0xFF8093F1)],
                )
              : null,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(
          icon,
          size: 22,
          color: isActive ? Colors.white : const Color(0xFF8093F1),
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

void navigateToReviewVenue({required int venueId, required int checkInId}) {
  final context = _rootNavKey.currentContext;
  if (context == null) return;
  context.pushNamed(
    'review_venue',
    extra: {'venueLocationId': venueId, 'checkInId': checkInId},
  );
}
