
import '../localizations/localization.dart';

enum Category {
  NEW,
  RANDOM,
  FITNESS,
  GIRLS,
  TRAVEL,
  CARS,
  ISLANDS,
}
const _map = {
  Category.NEW:     'new',
  Category.RANDOM:  'random',
  Category.FITNESS: 'fitness',
  Category.GIRLS:   'girls',
  Category.TRAVEL:  'travel',
  Category.CARS:    'cars',
  Category.ISLANDS: 'island',
};
extension CategoryExt on Category {
  String get name => _map[this];
  ///
  String toLocalizedName(AppLocalizations localizations) {
    switch(this) {
      case Category.RANDOM:  return localizations.random;
      case Category.NEW:     return localizations.neu;
      case Category.GIRLS:   return localizations.girls;
      case Category.FITNESS: return localizations.fitness;
      case Category.CARS:    return localizations.cars;
      case Category.TRAVEL:  return localizations.travel;
      case Category.ISLANDS: return localizations.islands;
    }
  }
  String toSearch() {
    switch(this) {
      case Category.RANDOM: return null;
      case Category.GIRLS:  return 'woman women';
      case Category.FITNESS:   return 'fitness gym bodybuilding';
      case Category.CARS:   return 'cars auto';
      case Category.TRAVEL:   return 'travel discover journey';
      case Category.ISLANDS:   return 'beach island bounty coast islands';
    }
  }
}
extension StringCategoryExt on String {
  Category toCategory() => _map.entries.firstWhere((entry) => entry.value == this).key;
}
