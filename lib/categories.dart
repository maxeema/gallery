
enum Category {

  NEW,
  GIRLS,
  AUTO,
  CATS,

}

categoryToName(Category category) {
  switch(category) {
    case Category.NEW:   return 'new';
    case Category.GIRLS: return 'girls';
    case Category.AUTO:  return 'auto';
    case Category.CATS:  return 'cats';
  }
}

nameToCategory(String name) {
  switch(name) {
    case 'new':   return Category.NEW;
    case 'girls': return Category.GIRLS;
    case 'auto':  return Category.AUTO;
    case 'cats':  return Category.CATS;
    default :     return Category.values[0];
  }
}