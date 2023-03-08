import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static Future<List<String>> getRecent() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    List<String> recents = [];
    if (pref.containsKey('saved')) {
      recents = pref.getStringList('saved') ?? [];
      return recents;
    } else {
      return recents;
    }
  }

  static Future saveRecent(String path) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    List<String> recents = pref.getStringList('saved') ?? [];
    if (recents.contains(path)) {
    } else {
      recents.add(path);
    }
    await pref.setStringList('saved', recents);
    //print(recents.length);
  }
}
