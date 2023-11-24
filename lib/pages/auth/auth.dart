import 'package:flutter/material.dart';
import 'package:test_app/lib/github_auth.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextButton(
        child: const Text("github"),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Scaffold(
                body: GithubOAuth2Widget(
                  loginURL: "http://10.0.2.2:8080/auth/github/login",
                  callbackURL: "http://localhost:8080/auth/github/callback",
                  onCallback: null,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
