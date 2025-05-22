import 'package:shared_preferences/shared_preferences.dart';


class Preferences {

  static late SharedPreferences _prefs;
  static String _email='';
  static String _password='';
 

  static Future init() async{
    _prefs= await SharedPreferences.getInstance();
  }

  static String get email {
    return _prefs.getString('email') ?? _email;
  }

static set email(String value) {
  _email=value;
  _prefs.setString('email', value);
}


  static String get password {
    return _prefs.getString('password') ?? _password;
  }

static set password(String value) {
  _password=value;
  _prefs.setString('password', value);
}




}