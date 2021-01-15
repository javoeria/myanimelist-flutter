import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserData extends ChangeNotifier {
  UserData(this.prefs) {
    _gridView = prefs.getBool('gridView') ?? true;
    _kidsGenre = prefs.getBool('kidsGenre') ?? false;
    _r18Genre = prefs.getBool('r18Genre') ?? false;
    _history = prefs.getStringList('history') ?? [];
  }

  final SharedPreferences prefs;

  bool _gridView;
  bool get gridView => _gridView;

  bool _kidsGenre;
  bool get kidsGenre => _kidsGenre;

  bool _r18Genre;
  bool get r18Genre => _r18Genre;

  List<String> _history;
  List<String> get history => _history;

  void toggleView() {
    _gridView = !_gridView;
    prefs.setBool('gridView', _gridView);
    notifyListeners();
  }

  void toggleKids() {
    _kidsGenre = !_kidsGenre;
    prefs.setBool('kidsGenre', _kidsGenre);
    notifyListeners();
  }

  void toggleR18() {
    _r18Genre = !_r18Genre;
    prefs.setBool('r18Genre', _r18Genre);
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

  void removeHistory(String value) {
    _history.remove(value);
    prefs.setStringList('history', _history);
    notifyListeners();
  }

  void removeHistoryAll() {
    _history.clear();
    prefs.setStringList('history', _history);
    notifyListeners();
  }
}
