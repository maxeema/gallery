
import 'package:shared_preferences/shared_preferences.dart';

const _keyCategory = "category";

get prefs => SharedPreferences.getInstance();

Future<String> loadCategory () async
    => (await prefs).getString(_keyCategory);

Future<void> saveCategory(String category) async
    => (await prefs).setString(_keyCategory, category);
