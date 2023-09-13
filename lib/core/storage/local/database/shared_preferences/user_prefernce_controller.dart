import 'package:avatar_course2_5_shop/core/extension/extensions.dart';
import 'package:avatar_course2_5_shop/core/model/custom_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferenceController {
  static final _instance = UserPreferenceController._internal();
  late SharedPreferences _sharedPreferences;

  UserPreferenceController._internal();

  factory UserPreferenceController() {
    return _instance;
  }

  Future<void> initPreferences() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  clear() {
    _sharedPreferences.clear();
  }

  Future<void> saveUserInfo({
    required CustomUser user,
    required String email,
    required String password,
  }) async {
    _sharedPreferences.setString('id', user.id);
    _sharedPreferences.setString('email', email);
    _sharedPreferences.setString('password', password);
    _sharedPreferences.setString('username', user.username);
  }

  CustomUser get userInfo {
    CustomUser user = CustomUser();
    user.id = _sharedPreferences.getString('id').onNull();
    user.email = _sharedPreferences.getString('email').onNull();
    user.password = _sharedPreferences.getString('password').onNull();
    user.username = _sharedPreferences.getString('username').onNull();

    return user;
  }
}
