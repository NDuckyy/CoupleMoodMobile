class UserSearchResult {
  final int userId;  // Changed from memberId to userId
  final String fullName;
  final String? avatarUrl;
  final String? bio;
  final String relationshipStatus;
  final bool canSendInvitation;

  UserSearchResult({
    required this.userId,
    required this.fullName,
    this.avatarUrl,
    this.bio,
    required this.relationshipStatus,
    required this.canSendInvitation,
  });

  factory UserSearchResult.fromJson(Map<String, dynamic> json) {
    return UserSearchResult(
      userId: json['userId'] as int,  // Changed from memberId
      fullName: json['fullName'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      bio: json['bio'] as String?,
      relationshipStatus: json['relationshipStatus'] as String,
      canSendInvitation: json['canSendInvitation'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,  // Changed from memberId
      'fullName': fullName,
      'avatarUrl': avatarUrl,
      'bio': bio,
      'relationshipStatus': relationshipStatus,
      'canSendInvitation': canSendInvitation,
    };
  }
}

class UserSearchResponse {
  final bool success;
  final List<UserSearchResult> data;
  final SearchPagination pagination;

  UserSearchResponse({
    required this.success,
    required this.data,
    required this.pagination,
  });

  factory UserSearchResponse.fromJson(Map<String, dynamic> json) {
    return UserSearchResponse(
      success: json['success'] as bool,
      data: (json['data'] as List<dynamic>)
          .map((item) => UserSearchResult.fromJson(item as Map<String, dynamic>))
          .toList(),
      pagination: SearchPagination.fromJson(json['pagination'] as Map<String, dynamic>),
    );
  }
}

class SearchPagination {
  final int page;
  final int pageSize;
  final int total;

  SearchPagination({
    required this.page,
    required this.pageSize,
    required this.total,
  });

  factory SearchPagination.fromJson(Map<String, dynamic> json) {
    return SearchPagination(
      page: json['page'] as int,
      pageSize: json['pageSize'] as int,
      total: json['total'] as int,
    );
  }

  bool get hasMore => page * pageSize < total;
}
