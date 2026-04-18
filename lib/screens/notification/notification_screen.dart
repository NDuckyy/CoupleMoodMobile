import 'package:couple_mood_mobile/providers/notification_provider.dart';
import 'package:couple_mood_mobile/screens/notification/widgets/notification_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationProvider>().getNotifications(1, 1, "");
    });

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() async {
    final provider = context.read<NotificationProvider>();

    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !provider.isLoadingMore &&
        provider.notifications != null &&
        provider.notifications!.hasNextPage) {
      await provider.loadMoreNotifications("");
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NotificationProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Thông báo"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: RefreshIndicator(
        color: const Color(0xFF8093F1),
        onRefresh: () async {
          await context.read<NotificationProvider>().getNotifications(
            1,
            10,
            "",
          );
        },
        child: _buildBody(provider),
      ),
    );
  }

  Widget _buildBody(NotificationProvider provider) {
    if (provider.isLoading && provider.notifications == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.notifications == null ||
        provider.notifications!.items.isEmpty) {
      return ListView(
        children: const [
          SizedBox(height: 200),
          Center(child: Text("Không có thông báo")),
        ],
      );
    }

    return ListView.builder(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(12),
      itemCount:
          provider.notifications!.items.length +
          (provider.notifications!.hasNextPage ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < provider.notifications!.items.length) {
          final item = provider.notifications!.items[index];
          return NotificationItem(notification: item);
        }

        if (provider.isLoadingMore) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Center(
            child: Text(
              "Bạn đã xem hết thông báo 🎉",
              style: TextStyle(color: Colors.grey),
            ),
          ),
        );
      },
    );
  }
}
