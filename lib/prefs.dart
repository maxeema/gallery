
import 'package:shared_preferences/shared_preferences.dart';

import 'categories.dart';

const _keyCategory = "category";

Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

Future<String> loadCategory () async
    => (await prefs).getString(_keyCategory);

Future<void> saveCategory(Category category) async
    => (await prefs).setString(_keyCategory, categoryToName(category));
