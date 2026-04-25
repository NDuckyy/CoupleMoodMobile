import 'package:flutter/material.dart';

class BuildAvatar extends StatelessWidget {
  final String? url;

  const BuildAvatar({super.key, this.url});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 45,
      backgroundColor: Colors.grey.shade200,
      child: url != null && url!.isNotEmpty
          ? CircleAvatar(radius: 42, backgroundImage: NetworkImage(url!))
          : const Icon(Icons.person, size: 42, color: Colors.grey),
    );
  }
}
