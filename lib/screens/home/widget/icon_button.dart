// import 'package:couple_mood_mobile/widgets/home_icon_button.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';

// class IconButton extends StatelessWidget {
//   const IconButton({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(20),
//       child: GridView.count(
//         shrinkWrap: true,
//         physics: const NeverScrollableScrollPhysics(),
//         crossAxisCount: 4,
//         mainAxisSpacing: 12,
//         crossAxisSpacing: 12,
//         childAspectRatio: 1,
//         children: [
//           HomeIconButton(
//             icon: Icons.mood,
//             label: "Cảm xúc",
//             color: const Color(0xFFF7AEF8),
//             onTap: () {
//               context.pushNamed("moodChooseMethod");
//             },
//           ),

//           HomeIconButton(
//             icon: Icons.science,
//             label: "Khám phá\nbạn",
//             color: const Color(0xFFB388EB),
//             onTap: () {
//               context.pushNamed("test");
//             },
//           ),

//           HomeIconButton(
//             icon: Icons.group_add,
//             label: "Ghép cặp",
//             color: const Color(0xFF8093F1),
//             onTap: () {
//               context.pushNamed("member_search");
//             },
//           ),

//           HomeIconButton(
//             icon: Icons.collections_bookmark,
//             label: "Bộ sưu\ntập",
//             color: const Color(0xFF72DDF7),
//             onTap: () {
//               context.goNamed("collections");
//             },
//           ),

//           HomeIconButton(
//             icon: Icons.logout,
//             label: "Đăng xuất",
//             color: const Color(0xFFB388EB),
//             onTap: () {
//               _logout();
//               Future.delayed(const Duration(milliseconds: 800), () {
//                 if (!mounted) return;
//                 context.pushNamed("login");
//               });
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
