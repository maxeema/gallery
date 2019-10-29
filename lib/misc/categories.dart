
import '../localizations/localization.dart';

enum Category {
  NEW,
  RANDOM,
  GIRLS,
  CARS,
}

categoryToName(Category category) {
  switch(category) {
    case Category.NEW:    return 'new';
    case Category.RANDOM: return 'random';
    case Category.GIRLS:  return 'girls';
    case Category.CARS:   return 'cars';
  }
}

nameToCategory(String name) {
  switch(name) {
    case 'new':    return Category.NEW;
    case 'girls':  return Category.GIRLS;
    case 'random': return Category.RANDOM;
    case 'cars':   return Category.CARS;
    default :      return Category.values[0];
  }
}

categoryToLocalizedName(Category category, AppLocalizations localizations) {
  switch(category) {
    case Category.RANDOM: return localizations.random;
    case Category.NEW:    return localizations.neu;
    case Category.GIRLS:  return localizations.girls;
    case Category.CARS:   return localizations.cars;
  }
}

categoryToSearch(Category category) {
  switch(category) {
    case Category.RANDOM: return null;
    case Category.GIRLS:  return 'woman women';
    case Category.CARS:   return 'cars auto';
    default:
      throw ArgumentError();
  }
}