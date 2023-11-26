final GithubOAuthSettings defaultSetting = GithubOAuthSettings(
    loginURL: "http://220.149.124.116:8080/auth/github/login?type=json",
    callbackURL: "http://220.149.124.116:8080/auth/github/callback");

class Settings {
  final String host;
  late final GithubOAuthSettings githubOAuthSettings;
  Settings({required this.host, GithubOAuthSettings? githubOAuthSettings}) {
    this.githubOAuthSettings = githubOAuthSettings ?? defaultSetting;
  }
}

class GithubOAuthSettings {
  final String loginURL;
  final String callbackURL;
  GithubOAuthSettings({required this.loginURL, required this.callbackURL});
}
