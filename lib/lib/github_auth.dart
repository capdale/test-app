import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:modak/modak.dart';
import 'package:test_app/view_models/settings.dart';
import 'package:webview_flutter/webview_flutter.dart';

const githubURL = "https://github.com";

enum AuthStep { getLoginURL, oauth, callback, success, fail }

class GithubOAuthPage extends StatelessWidget {
  final GithubOAuthSettings githubConfig;
  final void Function(Token)? onCallback;
  const GithubOAuthPage(
      {Key? key, required this.githubConfig, required this.onCallback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: GithubOAuth2Widget(
          loginURL: githubConfig.loginURL,
          callbackURL: githubConfig.callbackURL,
          onCallback: onCallback,
          httpClient: HttpClient()),
    );
  }
}

class GithubOAuth2Widget extends StatefulWidget {
  final String loginURL;
  final String url = "";

  final String callbackURL;
  final void Function(Token)? onCallback;
  final HttpClient httpClient;
  const GithubOAuth2Widget(
      {Key? key,
      required this.loginURL,
      required this.callbackURL,
      required this.onCallback,
      required this.httpClient})
      : super(key: key);

  @override
  State<GithubOAuth2Widget> createState() => _GithubOAuth2WidgetState();
}

class _GithubOAuth2WidgetState extends State<GithubOAuth2Widget> {
  AuthStep authStep = AuthStep.getLoginURL;
  String oauthURL = "";
  String callbackURL = "";
  List<Cookie> cookies = [];
  HttpClient httpClient = HttpClient();
  Token? token;
  @override
  Widget build(BuildContext context) {
    if (authStep == AuthStep.getLoginURL) {
      httpClient
          .getUrl(Uri.parse(widget.loginURL))
          .then((req) => req.close())
          .then((res) {
        setState(() {
          cookies = res.cookies;
        });
        return res.transform(utf8.decoder).join();
      }).then((bodyString) {
        try {
          var url = jsonDecode(bodyString)["url"];
          setState(() {
            oauthURL = url;
            authStep = AuthStep.oauth;
          });
        } catch (e) {
          setState(() {
            authStep = AuthStep.fail;
          });
        }
      }).catchError((e) {
        setState(() {
          authStep = AuthStep.fail;
        });
      });
      return Center(
        child: LoadingAnimationWidget.staggeredDotsWave(
            color: const Color.fromARGB(255, 118, 41, 250), size: 128),
      );
    } else if (authStep == AuthStep.oauth) {
      final controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(NavigationDelegate(
          onWebResourceError: (WebResourceError error) {
            setState(() {
              authStep = AuthStep.fail;
            });
          },
          onNavigationRequest: (NavigationRequest request) async {
            if (request.url.startsWith(githubURL)) {
              return NavigationDecision.navigate;
            } else if (request.url.startsWith(widget.callbackURL)) {
              setState(() {
                callbackURL = request.url;
                authStep = AuthStep.callback;
              });
              return NavigationDecision.prevent;
            }
            setState(() {
              authStep = AuthStep.callback;
            });
            return NavigationDecision.prevent;
          },
        ))
        ..loadRequest(Uri.parse(oauthURL));
      return WebViewWidget(
        controller: controller,
      );
    } else if (authStep == AuthStep.callback) {
      // uri change when use localhost
      var uri = Uri.parse(callbackURL);
      if (uri.host == "localhost") {
        uri = uri.replace(host: "10.0.2.2");
      }
      httpClient
          .getUrl(uri)
          .then((req) {
            req.cookies.addAll(cookies);
            return req.close();
          })
          .then((res) => res.transform(utf8.decoder).join())
          .then((bodyString) {
            try {
              String tokenString = jsonDecode(bodyString)["token"];
              var parsedToken = Token.parseFromString(tokenString);
              if (widget.onCallback != null) widget.onCallback!(parsedToken);
              setState(() {
                token = parsedToken;
                authStep = AuthStep.success;
              });
            } catch (e) {
              setState(() {
                authStep = AuthStep.fail;
              });
            }
          })
          .catchError((e) {
            setState(() {
              authStep = AuthStep.fail;
            });
          });
    } else if (authStep == AuthStep.success) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline_rounded,
              size: 64,
              color: Color.fromARGB(255, 29, 226, 101),
            ),
            Text(
              "Auth success!",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    } else if (authStep == AuthStep.fail) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.warning_amber_rounded,
              size: 64,
              color: Color.fromARGB(255, 226, 29, 58),
            ),
            Text(
              "Fail to Auth",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }
    return Container();
  }
}
