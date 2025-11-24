import 'package:shared_preferences/shared_preferences.dart';

class UserInfo {
  // Menyimpan token
  Future<void> setToken(String value) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString("token", value);
  }

  // Mengambil token
  Future<String?> getToken() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString("token");
  }

  // Menyimpan User ID
  Future<void> setUserID(String value) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString("userID", value);
  }

  // Mengambil User ID
  Future<String?> getUserID() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString("userID");
  }

  // Menyimpan Email
  Future<void> setEmail(String value) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString("email", value);
  }

  // Mengambil Email
  Future<String?> getEmail() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString("email");
  }

  // Logout - Hapus semua data
  Future<void> logout() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.clear();
  }
}