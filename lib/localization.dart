import 'dart:ui';

import 'package:flutter/material.dart';

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {

  @override
  bool isSupported(Locale locale) => {'en'}.contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) {
    return Future.sync(()=> AppLocalizations(locale));
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}

class AppLocalizations {

  AppLocalizations(this.locale);

  final Locale locale;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'title': 'Maxeem gallery app',
      'drawer_title': 'Maxeem\ngallery app',
      //
      'neu':   'New',
      'girls': 'Girls',
      'cats':  'Cats',
      'cars':  'Cars',
      //
      'share': 'Share',
    },
  };

  Map<String, String> get _localized => _localizedValues[locale.languageCode];

  String get title => _localized['title'];
  String get drawerTitle => _localized['drawer_title'];
  //
  String get neu   => _localized['neu'];
  String get girls => _localized['girls'];
  String get cats  => _localized['cats'];
  String get cars  => _localized['cars'];
  //
  String get share  => _localized['share'];

}
