import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserData extends ChangeNotifier {
  UserData(this.prefs) {
    _gridView = prefs.getBool('gridView') ?? true;
    _history = prefs.getStringList('history') ?? [];
  }

  final SharedPreferences prefs;

  bool _gridView;
  bool get gridView => _gridView;

  List<String> _history;
  List<String> get history => _history;

  void toogleView() {
    _gridView = !_gridView;
    prefs.setBool('gridView', _gridView);
    notifyListeners();
  }

  void addHistory(String value) {
    if (_history.contains(value)) {
      _history.remove(value);
    }
    _history.insert(0, value);
    prefs.setStringList('history', _history);
    // notifyListeners();
  }
}
