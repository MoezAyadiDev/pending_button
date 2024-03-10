import 'package:example/util/models.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final UserModel user;
  const HomeScreen({
    super.key,
    required this.user,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home page'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            width: 400,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        child: Icon(Icons.person),
                      ),
                      const SizedBox(width: 40),
                      Text('Welcom ${user.login}'),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Icon(Icons.email_outlined),
                      const SizedBox(width: 40),
                      Text(user.email),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Icon(Icons.phone),
                      const SizedBox(width: 40),
                      Text(user.phone),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
