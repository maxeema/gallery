
part of 'localization.dart';

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {

  static final supportedLangs = { 'en' };
  static final supportedLocales = supportedLangs.map((lang) => Locale(lang));

  @override
  bool isSupported(Locale locale) => supportedLangs.contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) {
    return Future.sync(()=> AppLocalizations(locale));
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}

mixin Localizable  {

  AppLocalizations get l;

}

mixin LocalizableState<T extends StatefulWidget> on State<T> implements Localizable  {

  AppLocalizations get l => AppLocalizations.of(context);

  BuildContext get context;

}