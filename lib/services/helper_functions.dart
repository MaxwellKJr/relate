import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {
  // the keys for navigation
  static String userLoggedInKey = "LOGGEDINKEY";
  static String userNameKey = "USERNAMEKEY";
  static String userEmailKey = "USEREMAILKEY";

  // saving the data to showgroups

  static Future<bool> saveUserLoggedInStatus(bool isUserLoggedIn) async {
    SharedPreferences showgroups = await SharedPreferences.getInstance();
    return await showgroups.setBool(userLoggedInKey, isUserLoggedIn);
  }

  static Future<bool> saveUserNameshowgroups(String userName) async {
    SharedPreferences showgroups = await SharedPreferences.getInstance();
    return await showgroups.setString(userNameKey, userName);
  }

  static Future<bool> saveUserEmailshowgroups(String userEmail) async {
    SharedPreferences showgroups = await SharedPreferences.getInstance();
    return await showgroups.setString(userEmailKey, userEmail);
  }

  // getting the data from showgroups

  static Future<bool?> getUserLoggedInStatus() async {
    SharedPreferences showgroups = await SharedPreferences.getInstance();
    return showgroups.getBool(userLoggedInKey);
  }

  static Future<String?> getUserEmailFromshowgroups() async {
    SharedPreferences showgroups = await SharedPreferences.getInstance();
    return showgroups.getString(userEmailKey);
  }

  static Future<String?> getUserNameFromshowgroups() async {
    SharedPreferences showgroups = await SharedPreferences.getInstance();
    return showgroups.getString(userNameKey);
  }
}
