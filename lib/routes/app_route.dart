import 'package:couple_mood_mobile/screens/coupleProfile/couple_profile_screen.dart';
import 'package:couple_mood_mobile/screens/coupleProfile/edit_couple_profile_screen.dart';
import 'package:couple_mood_mobile/screens/map/couple_location_screen.dart';
import 'package:couple_mood_mobile/screens/notification/notification_screen.dart';
import 'package:couple_mood_mobile/screens/test/test_history.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

//---Provider
//auth
import 'package:couple_mood_mobile/providers/auth_provider.dart';

//Dateplan
import 'package:couple_mood_mobile/providers/date_plan_provider.dart';

//Collection
import 'package:couple_mood_mobile/providers/collection/collection_provider.dart';
import 'package:couple_mood_mobile/providers/collection/collection_detail_provider.dart';

//Post
import 'package:couple_mood_mobile/providers/post/post_detail_provider.dart';
import 'package:couple_mood_mobile/providers/post/post_provider.dart';
import 'package:couple_mood_mobile/providers/post/my_posts_provider.dart';

//Member, user
import 'package:couple_mood_mobile/providers/user/user_provider.dart';
import 'package:couple_mood_mobile/providers/member_provider.dart';
import 'package:couple_mood_mobile/providers/user/my_review_provider.dart';
import 'package:couple_mood_mobile/providers/user/edit_profile_provider.dart';

//mood
import 'package:couple_mood_mobile/providers/mood_provider.dart';

//voucher
import 'package:couple_mood_mobile/providers/voucher/voucher_detail_provider.dart';
import 'package:couple_mood_mobile/providers/voucher/my_voucher_provider.dart';
import 'package:couple_mood_mobile/providers/voucher/my_voucher_detail_provider.dart';

//leaderboard
import 'package:couple_mood_mobile/providers/leaderboard/leaderboard_provider.dart';

//payment, subscription, wallet
import 'package:couple_mood_mobile/providers/payment/payment_result_provider.dart';
import 'package:couple_mood_mobile/providers/subscription/subscription_provider.dart';
import 'package:couple_mood_mobile/providers/wallet/wallet_provider.dart';

//---Screen
//Chat
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
import 'package:couple_mood_mobile/screens/feed/my_posts_screen.dart';
import 'package:couple_mood_mobile/screens/feed/post_detail_screen.dart';

// invitation
import 'package:couple_mood_mobile/screens/invite/invite_screen.dart';

//bài test, personality
import 'package:couple_mood_mobile/screens/test/test_detail_screen.dart';
import 'package:couple_mood_mobile/screens/test/test_result_screen.dart';
import 'package:couple_mood_mobile/screens/test/test_type_screen.dart';
import 'package:couple_mood_mobile/screens/venue/venue_detail_screen.dart';
import 'package:couple_mood_mobile/screens/chat/conversation_list_screen.dart';
import 'package:couple_mood_mobile/widgets/splash_screen.dart';

//challenge
import 'package:couple_mood_mobile/screens/challenge/challenge_screen.dart';

//leaderboard
import 'package:couple_mood_mobile/screens/leaderboard/leaderboard_screen.dart';

//voucher
import 'package:couple_mood_mobile/screens/voucher/voucher_detail_screen.dart';
import 'package:couple_mood_mobile/screens/voucher/my_voucher_detail_screen.dart';
import 'package:couple_mood_mobile/screens/voucher/my_voucher_screen.dart';
import 'package:couple_mood_mobile/screens/voucher/voucher_hub_screen.dart';

//auth
import 'package:couple_mood_mobile/screens/auth/login_screen.dart';
import 'package:couple_mood_mobile/screens/auth/register_screen.dart';

//mood
import 'package:couple_mood_mobile/screens/mood/choose_mood_screen.dart';
import 'package:couple_mood_mobile/screens/mood/choose_mood_method_screen.dart';
import 'package:couple_mood_mobile/screens/mood/emotion_camera_screen.dart';

//payment, package, advertisement, wallet
import 'package:couple_mood_mobile/screens/payment/payment_result_screen.dart';
import 'package:couple_mood_mobile/screens/advertisement/advertisement_detail_screen.dart';
import 'package:couple_mood_mobile/screens/subscriptions/subscriptions_screen.dart';
import 'package:couple_mood_mobile/screens/wallet/wallet_hub_screen.dart';

//home, location, profile, review, user related, etc..
import 'package:couple_mood_mobile/screens/home/home_screen.dart';
import 'package:couple_mood_mobile/screens/location/list_location_screen.dart';
import 'package:couple_mood_mobile/screens/location/filter_location_screen.dart';
import 'package:couple_mood_mobile/screens/review/review_screen.dart';
import 'package:couple_mood_mobile/screens/user/profile_screen.dart';
import 'package:couple_mood_mobile/screens/guest/guest_screen.dart';
import 'package:couple_mood_mobile/screens/user/my_review_screen.dart';
import 'package:couple_mood_mobile/screens/user/edit_profile_screen.dart';

final _rootNavKey = GlobalKey<NavigatorState>();
final _homeTabNavKey = GlobalKey<NavigatorState>();
final _searchTabNavKey = GlobalKey<NavigatorState>();
final _chatTabNavKey = GlobalKey<NavigatorState>();
final _mapTabNavKey = GlobalKey<NavigatorState>();
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
      final uri =
          state.uri; // Dùng state.uri để lấy đầy đủ scheme/host/path/query

      // Debug để xem chính xác GoRouter nhận URI gì khi cold start từ MoMo
      debugPrint('🔍 Redirect called | Full URI: $uri');
      debugPrint(
        '   Scheme: ${uri.scheme} | Host: ${uri.host} | Path: ${uri.path} | Query: ${uri.queryParameters}',
      );

      // 1. Xử lý custom scheme deep link (chạy trước auth để tránh miss cold start)
      if (uri.scheme == 'couplemood') {
        if (uri.host == 'payment-result') {
          final orderId = uri.queryParameters['orderId'];
          if (orderId != null && orderId.isNotEmpty) {
            // Normalize về path nội bộ hợp lệ → GoRouter sẽ match route '/payment-result'
            // Truyền orderId qua query (dễ lấy ở builder)
            return '/payment-result?orderId=$orderId';
          }
        }
        // Nếu có deep link khác (ví dụ invite, reset pass) → thêm case ở đây
        // fallback về splash hoặc home nếu không match
        return '/splash'; // hoặc '/home' tùy logic
      }

      // 2. Logic auth cũ của bạn (giữ nguyên, chỉ chạy nếu không phải deep link custom)
      final isLoggedIn = auth.isLoggedIn;
      final loc = uri.toString(); // hoặc state.matchedLocation nếu chỉ cần path

      final isAuthRoute =
          loc.startsWith('/login') ||
          loc.startsWith('/register') ||
          loc.startsWith('/guest');
      final isSplash = loc == '/splash';

      if (isSplash) {
        return null;
      }

      if (!isLoggedIn && !isAuthRoute) return '/guest';

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
                pageBuilder: (_, __) =>
                    const MaterialPage(child: ListLocationScreen()),
              ),

              GoRoute(
                path: '/test',
                name: 'test',
                pageBuilder: (_, __) =>
                    const MaterialPage(child: TestTypeScreen()),
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
            navigatorKey: _mapTabNavKey,
            routes: [
              GoRoute(
                path: '/map',
                name: 'map',
                pageBuilder: (_, __) =>
                    const NoTransitionPage(child: CoupleLocationScreen()),
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
      GoRoute(
        path: '/mood/icon',
        name: 'moodChooseByIcon',
        pageBuilder: (_, __) => const MaterialPage(child: ChooseMoodScreen()),
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

      GoRoute(
        parentNavigatorKey: _rootNavKey,
        path: '/subscriptions',
        name: 'subscriptions',
        pageBuilder: (_, __) {
          return MaterialPage(
            child: ChangeNotifierProvider(
              create: (_) => SubscriptionProvider(),
              child: const SubscriptionScreen(),
            ),
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavKey,
        path: '/challenge',
        name: 'challenge',
        pageBuilder: (_, __) {
          return const MaterialPage(child: ChallengeScreen());
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavKey,
        path: '/voucher',
        name: 'voucher',
        pageBuilder: (_, __) {
          return const MaterialPage(child: VoucherHubScreen());
        },
      ),
      GoRoute(
        name: "leaderboard",
        path: "/leaderboard",
        pageBuilder: (_, __) => MaterialPage(
          child: ChangeNotifierProvider(
            create: (_) => LeaderboardProvider(),
            child: const LeaderboardScreen(),
          ),
        ),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavKey,
        path: '/voucher-detail',
        name: 'voucher_detail',
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;

          return MaterialPage(
            child: ChangeNotifierProvider(
              create: (_) => VoucherDetailProvider(),
              child: VoucherDetailScreen(voucherId: extra['voucherId']),
            ),
          );
        },
      ),
      GoRoute(
        path: '/my-voucher',
        name: 'my_voucher',
        pageBuilder: (_, __) => MaterialPage(
          child: ChangeNotifierProvider(
            create: (_) => MyVoucherProvider()..fetchMyVouchers(refresh: true),
            child: const MyVoucherScreen(),
          ),
        ),
      ),

      GoRoute(
        path: '/my-voucher-detail',
        name: 'my_voucher_detail',
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;

          return MaterialPage(
            child: ChangeNotifierProvider(
              create: (_) => MyVoucherDetailProvider(),
              child: MyVoucherDetailScreen(
                voucherItemId: extra['voucherItemId'],
              ),
            ),
          );
        },
      ),

      GoRoute(
        path: '/payment-result',
        name: 'payment-result',
        builder: (context, state) {
          // Ưu tiên extra (từ goNamed/pushNamed), fallback về query (từ redirect cold start)
          String? orderId = state.extra as String?;
          orderId ??= state.uri.queryParameters['orderId'];

          if (orderId == null || orderId.isEmpty) {
            return const Scaffold(
              body: Center(child: Text('OrderId trống hoặc không hợp lệ')),
            );
          }

          return ChangeNotifierProvider(
            create: (_) => PaymentResultProvider()..fetchStatus(orderId!),
            child: const PaymentResultScreen(),
          );
        },
      ),

      GoRoute(
        parentNavigatorKey: _rootNavKey,
        path: '/wallet',
        name: 'wallet',
        pageBuilder: (_, state) {
          // Lấy tab từ query parameter (nếu có)
          final tab =
              int.tryParse(state.uri.queryParameters['tab'] ?? '0') ?? 0;

          return MaterialPage(
            child: ChangeNotifierProvider(
              create: (_) => WalletProvider(),
              child: WalletHubScreen(
                initialTab: tab.clamp(0, 2),
              ), // giới hạn 0-2
            ),
          );
        },
      ),

      GoRoute(
        parentNavigatorKey: _rootNavKey,
        path: '/my-reviews',
        name: 'my_reviews',
        pageBuilder: (_, __) {
          return MaterialPage(
            child: ChangeNotifierProvider(
              create: (_) => MyReviewProvider(),
              child: const MyReviewScreen(),
            ),
          );
        },
      ),

      GoRoute(
        path: '/edit-profile',
        name: 'edit_profile',
        pageBuilder: (_, __) {
          return MaterialPage(
            child: ChangeNotifierProvider(
              create: (_) => EditProfileProvider(),
              child: const EditProfileScreen(),
            ),
          );
        },
      ),

      GoRoute(
        path: '/filter-location',
        name: 'filter_location',
        pageBuilder: (_, __) {
          return const NoTransitionPage(child: FilterLocationScreen());
        },
      ),

      GoRoute(
        path: '/test-detail',
        name: 'test_detail',
        pageBuilder: (_, __) => const MaterialPage(child: TestDetailScreen()),
      ),
      GoRoute(
        path: '/test-result',
        name: 'test_result',
        pageBuilder: (_, __) => const MaterialPage(child: TestResultScreen()),
      ),

      GoRoute(
        path: '/test-history',
        name: 'test_history',
        pageBuilder: (_, __) => const MaterialPage(child: TestHistoryScreen()),
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
        path: '/couple-profile',
        name: 'couple_profile',
        pageBuilder: (_, __) => const MaterialPage(child: CoupleProfilePage()),
      ),

      GoRoute(
        path: '/notification',
        name: 'notification',
        pageBuilder: (_, __) => const MaterialPage(child: NotificationScreen()),
      ),

      GoRoute(
        path: '/couple-profile/edit',
        name: 'edit_couple_profile',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return EditCoupleProfilePage(
            coupleName: extra['coupleName'],
            anniversaryDate: extra['anniversaryDate'],
            budgetMin: extra['budgetMin'],
            budgetMax: extra['budgetMax'],
          );
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

      GoRoute(
        path: '/guest',
        name: 'guest',
        pageBuilder: (_, __) => const MaterialPage(child: GuestScreen()),
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
          return MultiProvider(
            providers: [
              /// 1. MyPostsProvider (nguồn dữ liệu riêng)
              ChangeNotifierProvider(create: (_) => MyPostsProvider()),

              /// 2. PostProvider phụ thuộc MyPostsProvider
              ChangeNotifierProxyProvider<MyPostsProvider, PostProvider>(
                create: (_) => PostProvider(null),
                update: (_, myPostsProvider, previous) {
                  previous!.setMyPostsProvider(myPostsProvider);
                  return previous;
                },
              ),

              /// 3. User
              ChangeNotifierProvider(create: (_) => UserProvider()..fetchMe()),
            ],
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: '/newsfeed',
            name: 'newsfeed',
            pageBuilder: (_, __) => const MaterialPage(child: NewsFeedScreen()),
          ),

          GoRoute(
            name: "my_posts",
            path: "/my-posts",
            builder: (context, state) {
              return const MyPostsScreen();
            },
          ),
          GoRoute(
            path: '/post/:postId',
            name: 'post_detail',
            builder: (context, state) {
              final postId = int.parse(state.pathParameters['postId']!);

              return ChangeNotifierProvider(
                create: (_) =>
                    PostDetailProvider(context.read<PostProvider>())
                      ..init(postId),
                child: PostDetailScreen(postId: postId),
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
      color: Colors.white,
      child: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildItem(Icons.map, 3, currentIndex),
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

void navigateToChatScreen({required conversation}) {
  final context = _rootNavKey.currentContext;
  if (context == null) return;
  context.pushNamed('chat_screen', extra: {'conversation': conversation});
}
