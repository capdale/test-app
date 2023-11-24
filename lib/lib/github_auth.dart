import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

const githubURL = "https://github.com";

enum HttpState {
  success,
  fail,
  start,
}

class AuthState {
  HttpState state = HttpState.start;
  String url = "";
  AuthState(this.url, this.state);
}

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
  AuthState authState = AuthState("", HttpState.start);
  String callbackURL = "";
  @override
  Widget build(BuildContext context) {
    debugPrint(callbackURL);
    if (authState.state == HttpState.start) {
      final controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(NavigationDelegate(
          onWebResourceError: (WebResourceError error) {
            setState(() {
              authState.state = HttpState.fail;
            });
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith(widget.loginURL)) {
              return NavigationDecision.navigate;
            } else if (request.url.startsWith(githubURL)) {
              return NavigationDecision.navigate;
            } else if (request.url.startsWith(widget.callbackURL)) {
              setState(() {
                authState.url = request.url;
                authState.state = HttpState.success;
              });
              if (widget.onCallback != null) widget.onCallback!(request.url);
              Navigator.pop(context, request.url);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.prevent;
          },
        ))
        ..loadRequest(Uri.parse(widget.loginURL));
      return WebViewWidget(
        controller: controller,
      );
    } else if (authState.state == HttpState.fail) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.warning_amber_rounded,
              size: 80,
              color: Color.fromARGB(255, 226, 29, 58),
            ),
            Text(
              "Fail, No Resource",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    } else if (authState.state == HttpState.success) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline_rounded,
              size: 80,
              color: Color.fromARGB(255, 29, 226, 101),
            ),
            Text(
              "Success, move to previous page",
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
