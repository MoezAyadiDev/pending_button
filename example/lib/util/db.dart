class FakeDatabase {
  const FakeDatabase();
  static final _users = [
    {
      'login': 'flutter',
      'password': '1234',
      'email': 'flutter@dart.com',
      'phone': '00123456789'
    },
    {
      'login': 'dart',
      'password': '1234',
      'email': 'dart@dart.com',
      'phone': '00987654321'
    }
  ];
  Future<Map<String, dynamic>> signin(Map<String, dynamic> data) async {
    return Future.delayed(const Duration(seconds: 2)).then(
      (value) {
        try {
          final index = _users.indexWhere(
            (element) =>
                ((element['login'] == data['login']) ||
                    (element['email'] == data['email'])) &&
                (element['password'] == data['password']),
          );

          if (index != -1) {
            Map<String, dynamic> localUser = _users[index];
            localUser.removeWhere((key, value) => key == 'password');
            return {'status': true, 'user': localUser};
          }
          return {
            'status': false,
            'error': 'Wrong conbination login and password'
          };
        } catch (er) {
          return {
            'status': false,
            'error': er.toString(),
          };
        }
      },
    );
  }

  Future<Map<String, dynamic>> resetPassword(Map<String, dynamic> data) async {
    return Future.delayed(const Duration(seconds: 2)).then(
      (value) {
        try {
          final index = _users.indexWhere((element) {
            return (element['login'] == data['login']) ||
                (element['email'] == data['email']);
          });

          if (index != -1) {
            return {'status': true, 'password': _users[index]['password']};
          }
          return {'status': false, 'error': 'User not found'};
        } catch (er) {
          return {
            'status': false,
            'error': er.toString(),
          };
        }
      },
    );
  }
}
