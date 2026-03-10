class UserSearchResult {
  final int memberProfileId;
  final int userId; // Changed from memberId to userId
  final String fullName;
  final String? avatarUrl;
  final String? bio;
  final String relationshipStatus;
  final bool canSendInvitation;

  UserSearchResult({
    required this.memberProfileId,
    required this.userId,
    required this.fullName,
    this.avatarUrl,
    this.bio,
    required this.relationshipStatus,
    required this.canSendInvitation,
  });

  factory UserSearchResult.fromJson(Map<String, dynamic> json) {
    return UserSearchResult(
      memberProfileId: json['memberProfileId'] as int,
      userId: json['userId'] as int, // Changed from memberId
      fullName: json['fullName'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      bio: json['bio'] as String?,
      relationshipStatus: json['relationshipStatus'] as String,
      canSendInvitation: json['canSendInvitation'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'memberProfileId': memberProfileId,
      'userId': userId, // Changed from memberId
      'fullName': fullName,
      'avatarUrl': avatarUrl,
      'bio': bio,
      'relationshipStatus': relationshipStatus,
      'canSendInvitation': canSendInvitation,
    };
  }
}

class UserSearchResponse {
  final List<UserSearchResult> data;
  final SearchPagination pagination;

  UserSearchResponse({required this.data, required this.pagination});

  factory UserSearchResponse.fromJson(Map<String, dynamic> json) {
    final dataJson = json['data'] as Map<String, dynamic>;

    final users = (dataJson['data'] as List)
        .map((item) => UserSearchResult.fromJson(item))
        .toList();

    final pagination = SearchPagination.fromJson(dataJson['pagination']);

    return UserSearchResponse(data: users, pagination: pagination);
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
