import 'package:flutter/material.dart';
import 'package:modak/modak.dart';

class CollectionChangeNotifier with ChangeNotifier {
  Collections _collections = Collections([]);
  Collections get collections => _collections;

  void setCollections(Collections collections) {
    _collections = collections;
  }
}
