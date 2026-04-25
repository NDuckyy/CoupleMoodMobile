import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../providers/post/post_share_provider.dart';

class PostDetailFromShareScreen extends StatefulWidget {
  final String code;

  const PostDetailFromShareScreen({super.key, required this.code});

  @override
  State<PostDetailFromShareScreen> createState() =>
      _PostDetailFromShareScreenState();
}

class _PostDetailFromShareScreenState extends State<PostDetailFromShareScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PostShareProvider>().loadByShareCode(widget.code);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PostShareProvider>();

    /// loading
    if (provider.loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    /// error
    if (provider.error != null) {
      return Scaffold(body: Center(child: Text(provider.error!)));
    }

    /// success → navigate
    final post = provider.post;

    if (post != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.goNamed(
          'post_detail',
          pathParameters: {'postId': post.id.toString()},
        );
      });
    }

    return const Scaffold(body: SizedBox());
  }
}
