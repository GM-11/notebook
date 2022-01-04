import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static SharedPreferences _sharedPreferences;

  static Future init() async {
    return _sharedPreferences = await SharedPreferences.getInstance();
  }

  // subjects

  static setSubject(String s) async {
    await _sharedPreferences.setString("subjectSaved", s);
  }

  static String getSubject() {
    return _sharedPreferences.getString("subjectSaved");
  }

  static removeSubject() {
    return _sharedPreferences.remove("subjectSaved");
  }

  //MODES ARE :- both , list , clock
  static setMode(String m) async {
    return _sharedPreferences.setString("ttMode", m);
  }

  static getMode() {
    return _sharedPreferences.getString('ttMode');
  }

  // TIME TABLE MODES ARE : - daily , weekly , weekdays
  static setTT(s) {
    return _sharedPreferences.setString("TTmode", s);
  }

  static getTT() {
    return _sharedPreferences.getString("TTMode");
  }

  // NUMBER OF STUDY MODES

  static setStudyModeIndex(int i) {
    return _sharedPreferences.setInt('index', i);
  }

  static getStudyModeIndex() {
    return _sharedPreferences.getInt('index');
  }

  // clear prefs
  static Future clearEverything() async => await _sharedPreferences.clear();
}
