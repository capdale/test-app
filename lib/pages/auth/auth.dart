import 'package:flutter/material.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:test_app/lib/github_auth.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextButton(
        child: Text("github"),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GithubOAuth2Widget(
                loginURL: "http://10.0.2.2:8080/auth/github/login",
                callbackURL: "http://localhost:8080/auth/github/callback",
                onCallback: null,
              ),
            ),
          );
        },
      ),
    );
  }
}
