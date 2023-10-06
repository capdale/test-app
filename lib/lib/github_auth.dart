import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

const githubURL = "https://github.com";

class GithubOAuth2Widget extends StatefulWidget {
  final String loginURL;
  final String callbackURL;
  final void Function(String)? onCallback;
  GithubOAuth2Widget({
    Key? key,
    required this.loginURL,
    required this.callbackURL,
    required this.onCallback,
  }) : super(key: key);

  @override
  State<GithubOAuth2Widget> createState() => _GithubOAuth2WidgetState();
}

class _GithubOAuth2WidgetState extends State<GithubOAuth2Widget> {
  String callbackURL = "";
  @override
  Widget build(BuildContext context) {
    debugPrint(callbackURL);
    if (callbackURL == "") {
      final controller = WebViewController()
        ..setNavigationDelegate(NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith(widget.loginURL)) {
              return NavigationDecision.navigate;
            } else if (request.url.startsWith(githubURL)) {
              return NavigationDecision.navigate;
            } else if (request.url.startsWith(callbackURL)) {
              setState(() {
                callbackURL = request.url;
              });
              if (widget.onCallback != null) widget.onCallback!(request.url);
              Navigator.pop(context, request.url);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.prevent;
          },
        ))
        ..loadRequest(Uri.parse(widget.loginURL));
      return Scaffold(
          body: WebViewWidget(
        controller: controller,
      ));
    }
    return Container();
  }
}
