class RegisterRequest {
  final String fullName;
  final String email;
  final String phoneNumber;
  final String dateOfBirth;
  final String gender;
  final String password;
  final String confirmPassword;

  RegisterRequest({
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.dateOfBirth,
    required this.gender,
    required this.password,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() => {
    "email": email,
    "password": password,
    "confirmPassword": confirmPassword,
    "fullName": fullName,
    "phoneNumber": phoneNumber,
    "dateOfBirth": dateOfBirth,
    "gender": gender,
  };
}
