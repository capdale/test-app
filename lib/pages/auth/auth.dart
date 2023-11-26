import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_app/lib/github_auth.dart';
import 'package:modak/modak.dart';
import 'package:test_app/provider/setting_provider.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void testCallback(Token token) async {
      print(token.uuid);
    }

    final setting = context.read<SettingsChangeNotifier>().settings;
    return Material(
      child: GithubOAuth2Widget(
        loginURL: "http://${setting.host}:8080/auth/github/login?type=json",
        callbackURL: "http://${setting.host}:8080/auth/github/callback",
        onCallback: testCallback,
        httpClient: HttpClient(),
      ),
    );
  }
}
