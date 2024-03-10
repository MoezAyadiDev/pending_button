import 'package:example/util/db.dart';
import 'package:example/util/models.dart';

class AuthController {
  String _login;
  String _password;
  final FakeDatabase _db = const FakeDatabase();
  AuthController()
      : _login = '',
        _password = '';

  loginChanged(String value) {
    _login = value;
  }

  passwordChanged(String value) {
    _password = value;
  }

  bool checkValidity() => _login.isNotEmpty && _password.length >= 4;
  bool checkResetPasswordValidity() => _login.isNotEmpty;

  Future<UserModel> singnIn() async {
    final response = await _db.signin({'login': _login, 'password': _password});
    return UserModel.fromJson(response);
  }

  Future<String> forgetPassword() async {
    final response = await _db.resetPassword({'login': _login});
    if (response['status']) {
      return response['password'];
    }
    throw AuthFailure.userNotFound(response['error']);
  }

  signUp() {}

  Future<UserModel> signinFacebook() async {
    final response = await _db.signin({'login': 'flutter', 'password': '1234'});
    return UserModel.fromJson(response);
  }

  Future<UserModel> signinApple() async {
    final response = await _db.signin({'login': 'dart', 'password': '1234'});
    return UserModel.fromJson(response);
  }
}
