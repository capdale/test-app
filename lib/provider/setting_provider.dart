import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_app/view_models/settings.dart';

class SettingsChangeNotifier with ChangeNotifier {
  final Settings settings = Settings(host: "localhost");
}
