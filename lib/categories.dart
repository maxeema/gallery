
import 'localization.dart';

enum Category {

  NEW,
  GIRLS,
  CARS,
  CATS,

}

categoryToName(Category category) {
  switch(category) {
    case Category.NEW:   return 'new';
    case Category.GIRLS: return 'girls';
    case Category.CARS:  return 'cars';
    case Category.CATS:  return 'cats';
  }
}

nameToCategory(String name) {
  switch(name) {
    case 'new':   return Category.NEW;
    case 'girls': return Category.GIRLS;
    case 'cars':  return Category.CARS;
    case 'cats':  return Category.CATS;
    default :     return Category.values[0];
  }
}

categoryToLocalizedName(Category category, AppLocalizations localizations) {
  switch(category) {
    case Category.NEW:   return localizations.neu;
    case Category.GIRLS: return localizations.girls;
    case Category.CARS:  return localizations.cars;
    case Category.CATS:  return localizations.cats;
  }
}