class Context {
  final String? userContext;
  final String? searchHistories;

  Context({this.userContext, this.searchHistories});

  factory Context.fromJson(Map<String, dynamic> json) {
    return Context(
      userContext: json['userContext'] as String?,
      searchHistories: json['searchHistories'] as String?,
    );
  }
}