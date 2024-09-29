import 'package:example/util/app_contexts.dart';
import 'package:example/util/auth_controller.dart';
import 'package:example/util/models.dart';
import 'package:example/widgets/home_screen.dart';
import 'package:example/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:pending_button/pending_button.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Week day picker Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 0, 92, 178),
          outline: Colors.grey[300]!,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const AuthPage(),
    );
  }
}

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    AuthController authController = AuthController();
    ValueNotifier<bool> checkValidity = ValueNotifier(false);
    bool checkFormValidity() {
      final isValidForm = authController.checkValidity();
      if (!isValidForm) {
        checkValidity.value = true;
      }
      return isValidForm;
    }

    bool checkResetPaswordValidity() {
      final isValidForm = authController.checkResetPasswordValidity();
      if (!isValidForm) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('The login is resuired'),
          ),
        );
      }
      return isValidForm;
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              const SizedBox(height: 30),
              Text(
                'Authentification',
                style: context.themeText.headlineLarge,
              ),
              const SizedBox(height: 30),
              Container(
                width: 400,
                padding: const EdgeInsets.fromLTRB(40, 40, 40, 20),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[200]!),
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    TextFormFieldWidget(
                      valueSetter: (login) {
                        authController.loginChanged(login);
                        checkValidity.value = false;
                      },
                      celType: CelType.text,
                      label: 'Login',
                      hint: 'User name or Email',
                      checkValidity: checkValidity,
                    ),
                    TextFormFieldWidget(
                      valueSetter: (password) {
                        authController.passwordChanged(password);
                        checkValidity.value = false;
                      },
                      celType: CelType.password,
                      label: 'Password',
                      hint: 'write your password',
                      checkValidity: checkValidity,
                    ),
                    const SizedBox(height: 15),
                    PendingButton(
                      asynFunction: authController.singnIn,
                      beforeFunction: checkFormValidity,
                      onError: _onError,
                      onSuccess: (user) => _onSuccess(context, user),
                      width: 320,
                      height: 40,
                      child: const Text('Connexion'),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        PendingButton.text(
                          asynFunction: () {},
                          child: const Text('Signup'),
                        ),
                        PendingButton.text(
                          asynFunction: authController.forgetPassword,
                          beforeFunction: checkResetPaswordValidity,
                          onError: _onError,
                          onSuccess: (result) =>
                              _onResetPasswordSuccess(context, result),
                          child: const Text('Forget password'),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        PendingButton.icon(
                          asynFunction: () {
                            return authController.signinFacebook();
                          },
                          onError: _onError,
                          onSuccess: (user) => _onSuccess(context, user),
                          child: Icon(
                            Icons.facebook,
                            size: 35,
                            color: Colors.blue[800]!,
                          ),
                        ),
                        PendingButton.icon(
                          asynFunction: () {
                            return authController.signinApple();
                          },
                          onError: _onError,
                          onSuccess: (user) => _onSuccess(context, user),
                          child: Icon(
                            Icons.apple,
                            size: 35,
                            color: Colors.grey[800]!,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const Text('Login: flutter password:1234'),
              const Text('Login: dart password:1234   ')
            ],
          ),
        ),
      ),
    );
  }

  _onError(Exception error) {
    String message = error.toString();
    if (error is Failures) {
      message = error.message;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  _onSuccess(BuildContext context, UserModel user) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen(user: user)),
    );
  }

  _onResetPasswordSuccess(BuildContext context, String password) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('The password is $password'),
      ),
    );
  }
}
