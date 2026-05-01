import 'package:couple_mood_mobile/providers/collection/collection_share_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class CollectionDetailFromShareScreen extends StatefulWidget {
  final String code;

  const CollectionDetailFromShareScreen({super.key, required this.code});

  @override
  State<CollectionDetailFromShareScreen> createState() =>
      _CollectionDetailFromShareScreenState();
}

class _CollectionDetailFromShareScreenState
    extends State<CollectionDetailFromShareScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CollectionShareProvider>().loadByShareCode(widget.code);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CollectionShareProvider>();

    /// loading
    if (provider.loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    /// error
    if (provider.error != null) {
      return Scaffold(body: Center(child: Text(provider.error!)));
    }

    final collection = provider.collection;

    /// success → redirect sang detail
    if (collection != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.goNamed(
          'collection_detail',
          extra: {'collectionId': collection.id},
        );
      });
    }

    return const Scaffold(body: SizedBox());
  }
}
