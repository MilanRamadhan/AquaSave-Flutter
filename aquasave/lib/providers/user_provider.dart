import 'package:flutter/material.dart';
import 'package:aquasave/models/user_model.dart';
import 'package:aquasave/utils/shared_pref.dart';

class UserProvider with ChangeNotifier {
  UserModel? _user;

  UserModel? get user => _user;

  void setUser(UserModel newUser) {
    _user = newUser;
    notifyListeners();
  }

  void clearUser() {
    _user = null;
    SharedPref.clearUser();
    notifyListeners();
  }

  Future<void> loadUser() async {
    _user = await SharedPref.getUser();
    print("User dari SharedPref di Provider: ${_user?.toJson()}"); // 👉 Debug log
    notifyListeners();
  }
}
