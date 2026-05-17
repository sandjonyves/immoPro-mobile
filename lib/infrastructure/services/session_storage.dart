import 'package:shared_preferences/shared_preferences.dart';

class SessionStorage {
  static const _keyUserId = 'immopro_user_id';

  Future<void> sauverUserId(String id) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(_keyUserId, id);
  }

  Future<String?> lireUserId() async {
    final p = await SharedPreferences.getInstance();
    return p.getString(_keyUserId);
  }

  Future<void> effacer() async {
    final p = await SharedPreferences.getInstance();
    await p.remove(_keyUserId);
  }
}
