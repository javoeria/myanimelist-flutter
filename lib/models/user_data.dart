import 'package:flutter/foundation.dart';

class UserData extends ChangeNotifier {
  bool _gridView = true;

  bool get gridView => _gridView;

  void toogleView() {
    _gridView = !_gridView;
    notifyListeners();
  }
}
