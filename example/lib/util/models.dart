class UserModel {
  final String login;
  final String email;
  final String phone;

  const UserModel(
      {required this.login, required this.email, required this.phone});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    if (json['status']) {
      Map<String, dynamic> user = json['user'];
      return UserModel(
        login: user['login'],
        email: user['email'],
        phone: user['phone'],
      );
    } else {
      throw AuthFailure.sigininFailure(json['error']);
    }
  }
}

sealed class Failures implements Exception {
  final String message;
  const Failures({this.message = ''});
}

class AuthFailure extends Failures {
  const AuthFailure({super.message});

  factory AuthFailure.sigininFailure(String message) =>
      AuthFailure(message: message);
  factory AuthFailure.userNotFound(String message) =>
      AuthFailure(message: message);
}
