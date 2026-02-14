import 'package:couple_mood_mobile/models/coupleInvitation/member_response.dart';
import 'package:flutter/material.dart';

class CoupleInvitationProvider extends ChangeNotifier {
  int inviteCount = 5;
  List<MemberResponse> users = [
    MemberResponse(
      userId: 1,
      fullName: 'Nguyen Van A',
      avatarUrl: 'https://i.pravatar.cc/150?img=1',
      bio: 'Yêu thích du lịch và ẩm thực',
      relationshipStatus: 'SINGLE',
      canSendInvitation: true,
    ),
    MemberResponse(
      userId: 2,
      fullName: 'Tran Thi B',
      avatarUrl: 'https://i.pravatar.cc/150?img=2',
      bio: 'Thích đọc sách và nghe nhạc',
      relationshipStatus: 'IN_RELATIONSHIP',
      canSendInvitation: false,
    ),
    MemberResponse(
      userId: 3,
      fullName: 'Le Van C',
      avatarUrl: 'https://i.pravatar.cc/150?img=3',
      bio: 'Đam mê công nghệ và lập trình',
      relationshipStatus: 'SINGLE',
      canSendInvitation: true,
    ),
    MemberResponse(
      userId: 4,
      fullName: 'Pham Thi D',
      avatarUrl: 'https://i.pravatar.cc/150?img=4',
      bio: 'Yêu thích thể thao và hoạt động ngoài trời',
      relationshipStatus: 'IN_RELATIONSHIP',
      canSendInvitation: false,
    ),
    MemberResponse(
      userId: 5,
      fullName: 'Hoang Van E',
      avatarUrl: 'https://i.pravatar.cc/150?img=5',
      bio: 'Thích nấu ăn và khám phá ẩm thực mới',
      relationshipStatus: 'SINGLE',
      canSendInvitation: true,
    ),
    MemberResponse(
      userId: 6,
      fullName: 'Do Thi F',
      avatarUrl: 'https://i.pravatar.cc/150?img=6',
      bio: 'Yêu thích nghệ thuật và thiết kế',
      relationshipStatus: 'IN_RELATIONSHIP',
      canSendInvitation: false,
    ),
  ];

  List<MemberResponse> receivedInvitations = [
    MemberResponse(
      userId: 7,
      fullName: 'Nguyen Van G',
      avatarUrl: 'https://i.pravatar.cc/150?img=7',
      bio: 'Thích du lịch và khám phá văn hóa mới',
      relationshipStatus: 'SINGLE',
      canSendInvitation: false,
    ),
    MemberResponse(
      userId: 8,
      fullName: 'Tran Thi H',
      avatarUrl: 'https://i.pravatar.cc/150?img=8',
      bio: 'Yêu thích âm nhạc và nghệ thuật',
      relationshipStatus: 'IN_RELATIONSHIP',
      canSendInvitation: false,
    ),
  ];
}
