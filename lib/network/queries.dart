
part of gallery.net;

abstract class Query { }

class PagedQuery implements Query {
  final int page;
  final int perPage;

  PagedQuery(this.page, this.perPage);
}

class NewPhotoQuery extends PagedQuery {
  NewPhotoQuery(int page, int perPage) : super(page, perPage);
}

class RandomQuery implements Query {
  final int count;
  final String query;

  RandomQuery(this.count, [this.query]);
}

class SearchPhotoQuery extends PagedQuery {
  final String search;

  SearchPhotoQuery(this.search, int page, int perPage) : super(page, perPage);
}

