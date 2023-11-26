import 'package:flutter/material.dart';
import 'package:modak/modak.dart';

class ModakChangeNotifier with ChangeNotifier {
  Modak? _modak;
  Modak? get modak => _modak;
  void setModak(Token token, {Endpoint? endpoint}) =>
      _modak = Modak(token: token, endpoint: endpoint);
  bool isModakExist() => _modak != null;
}
