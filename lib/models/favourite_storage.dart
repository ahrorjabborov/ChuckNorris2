import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Favourites extends ChangeNotifier {

  final Map<String, String> _favouriteItems = {};
  final _prefs = SharedPreferences.getInstance();

  Favourites() {
    loadData();
  }

  void loadData() async {
    SharedPreferences prefs = await _prefs;
    Iterable<String> keys =
        prefs.getKeys().where((key) => key.startsWith('favKey_'));

    for (String key in keys) {
      _favouriteItems[key] = prefs.getString(key) ?? '';
    }
  }

  int length() {
    return _favouriteItems.length;
  }

  bool isNotEmpty() {
    return _favouriteItems.isNotEmpty;
  }

  Iterable<String> get keys =>
      _favouriteItems.keys.map((key) => key.substring(7));

  String? get(String itemID) {
    return _favouriteItems['favKey_$itemID'];
  }

  void add(String itemID, String item) async {
    _favouriteItems['favKey_$itemID'] = item;

    SharedPreferences prefs = await _prefs;
    prefs.setString('favKey_$itemID', item);

    notifyListeners();
  }

  void remove(String itemID) async {
    _favouriteItems.remove('favKey_$itemID');

    SharedPreferences prefs = await _prefs;
    prefs.remove('favKey_$itemID');

    notifyListeners();
  }

  bool containsKey(String itemID) {
    return _favouriteItems.containsKey('favKey_$itemID');
  }
}
