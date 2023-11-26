import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:modak/modak.dart';
import 'package:provider/provider.dart';
import 'package:test_app/lib/github_auth.dart';
import 'package:test_app/provider/setting_provider.dart';
import 'package:test_app/provider/modak_provider.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "Login via",
            style: TextStyle(fontSize: 18),
          ),
          Consumer<SettingsChangeNotifier>(
              builder: (context, settingNoti, _) => FilledButton(
                    onPressed: () async {
                      final setModak =
                          context.read<ModakChangeNotifier>().setModak;
                      void getToken(Token? token) {
                        if (token != null) {
                          setModak(token,
                              endpoint: Endpoint(
                                  host: textController.text, port: 8080));
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              '/main', (route) => false);
                        }
                      }

                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => GithubOAuthPage(
                                    githubConfig: settingNoti
                                        .settings.githubOAuthSettings,
                                    onCallback: getToken,
                                  )));
                    },
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all(
                            const EdgeInsets.fromLTRB(8, 2, 8, 2)),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4)))),
                    child: const Text("Github"),
                  )),
          Container(
            child: TextField(
              controller: textController,
            ),
          )
        ],
      ),
    );
  }
}
