class InvitationResponse {
  final int invitationId;
  final int senderMemberId;
  final String senderName;
  final String? senderAvatarUrl;

  final int receiverMemberId;
  final String receiverName;
  final String? receiverAvatarUrl;

  final String? inviteCodeUsed;
  final String status;
  final String message;

  final DateTime sentAt;
  final DateTime? respondedAt;

  InvitationResponse({
    required this.invitationId,
    required this.senderMemberId,
    required this.senderName,
    this.senderAvatarUrl,
    required this.receiverMemberId,
    required this.receiverName,
    this.receiverAvatarUrl,
    this.inviteCodeUsed,
    required this.status,
    required this.message,
    required this.sentAt,
    this.respondedAt,
  });

  factory InvitationResponse.fromJson(Map<String, dynamic> json) {
    return InvitationResponse(
      invitationId: json['invitationId'],
      senderMemberId: json['senderMemberId'],
      senderName: json['senderName'],
      senderAvatarUrl: json['senderAvatarUrl'],
      receiverMemberId: json['receiverMemberId'],
      receiverName: json['receiverName'],
      receiverAvatarUrl: json['receiverAvatarUrl'],
      inviteCodeUsed: json['inviteCodeUsed'],
      status: json['status'],
      message: json['message'],
      sentAt: DateTime.parse(json['sentAt']),
      respondedAt: json['respondedAt'] != null
          ? DateTime.parse(json['respondedAt'])
          : null,
    );
  }
}
