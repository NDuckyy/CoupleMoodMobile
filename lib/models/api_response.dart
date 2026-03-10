class ApiResponse<T> {
  String message;
  int code;
  T? data;

  ApiResponse({
    required this.message,
    required this.code,
    this.data,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json, T Function(dynamic json) fromJsonT) {
    return ApiResponse(
      message: json['message']?.toString() ?? '',
      code: json['code'] as int,
      data: json['data'] != null ? fromJsonT(json['data']) : null,  
    );
  }
}