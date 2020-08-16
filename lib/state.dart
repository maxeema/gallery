
import 'package:flutter/widgets.dart';

import 'misc/categories.dart' as cat;
import 'misc/prefs.dart' as prefs;

class AppState {

  final category = ValueNotifier<cat.Category>(null);

  AppState() {
    category.addListener(() {
      if (category.value != null)
        prefs.saveCategory(category.value);
    });
    //
    final _onLoadCategory = (String name) {
      category.value = name == null ? cat.Category.NEW : name.toCategory();
    };
    prefs.loadCategory().then(_onLoadCategory, onError: (error)=> _onLoadCategory(null));
  }

}