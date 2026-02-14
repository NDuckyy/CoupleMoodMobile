import 'package:flutter/material.dart';

class MemberProfileMatch extends StatefulWidget {
  final int userId;

  const MemberProfileMatch({super.key, required this.userId});

  @override
  State<MemberProfileMatch> createState() => _MemberProfileState();
}

class _MemberProfileState extends State<MemberProfileMatch> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Thông tin thành viên")),
      body: Center(child: Text("Thông tin thành viên ID: ${widget.userId}")),
    );
  }
}
