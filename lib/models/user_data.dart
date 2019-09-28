import 'package:flutter/foundation.dart';

class UserData extends ChangeNotifier {
  bool _gridView = true;
  bool get gridView => _gridView;

  List<String> _history = [];
  List<String> get history => _history;

  void toogleView() {
    _gridView = !_gridView;
    notifyListeners();
  }

  void addHistory(String value) {
    if (!_history.contains(value)) {
      _history.insert(0, value);
      // notifyListeners();
    }
  }
}
