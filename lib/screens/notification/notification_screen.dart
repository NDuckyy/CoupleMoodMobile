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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationProvider>().getNotifications(1, 10, "LOCATION");
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NotificationProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text("Thông báo"), backgroundColor: Colors.white),
      body: RefreshIndicator(
        color: Color(0xFF8093F1),
        onRefresh: () async {
          await context.read<NotificationProvider>().getNotifications(
            1,
            10,
            "LOCATION",
          );
        },
        child: _buildBody(provider),
      ),
    );
  }

  Widget _buildBody(NotificationProvider provider) {
    if (provider.isLoading && provider.notifications == null) {
      return Center(child: CircularProgressIndicator());
    }

    if (provider.notifications == null ||
        provider.notifications!.items.isEmpty) {
      return ListView(
        children: [
          SizedBox(height: 200),
          Center(child: Text("Không có thông báo")),
        ],
      );
    }

    return ListView.builder(
      physics: AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.all(12),
      itemCount: provider.notifications!.items.length,
      itemBuilder: (context, index) {
        final item = provider.notifications!.items[index];
        return NotificationItem(notification: item);
      },
    );
  }
}
