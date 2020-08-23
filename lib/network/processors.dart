
part of gallery.net;

abstract class QueryProcessor<Q extends Query> {
  final Q query;

  QueryProcessor(this.query);

  String get path;
  Map<String, String> get queryParams;

  dynamic process(String body, int statusCode, String header(String name));

  @override
  String toString() => '$path: $queryParams';
}

abstract class PhotosProcessor<Q extends Query> extends QueryProcessor<Q> {

  PhotosProcessor(Q query) : super(query);

  @override
  PhotosProcessedResult process(String body, int statusCode, String header(String name)) {
//    print('process body on status $statusCode...');

    dynamic jsonResponse;
    try {
      jsonResponse = json.decode(body);
    } on FormatException catch (e, s) {
      print('$e \n$s');
      print('response body on error: $body');
      throw ApiError(LocKeys.unknownResponse);
    }

    if (jsonResponse is Map && jsonResponse.containsKey('errors'))
      throw RemoteError(jsonResponse['errors'][0]);

    if (statusCode != HttpStatus.ok)
      throw ApiError(LocKeys.notOk);

    return _parse(jsonResponse, header);
  }

  _parse(dynamic json, String header(String name)) {
    if (json == null)
      throw ApiError(LocKeys.noData);

    if (json is List) {

      return PhotosProcessedResult(json, json.isNotEmpty);
    }

    throw ApiError(LocKeys.dataUnsupported);
  }

}

abstract class PagedPhotosProcessor<Q extends PagedQuery> extends PhotosProcessor<Q> {

  PagedPhotosProcessor(Q query) : super(query);

  @override
  Map<String, String> get queryParams => {
    'page': query.page.toString(),
    'per_page': query.perPage.toString(),
  };

}

class NewPhotosProcessor<Q extends NewPhotoQuery> extends PagedPhotosProcessor<Q> {

  NewPhotosProcessor(Q query) : super(query);

  @override
  String get path => 'photos';

}

class RandomPhotosProcessor extends PhotosProcessor<RandomQuery> {

  RandomPhotosProcessor(RandomQuery query) : super(query);

  @override
  String get path => 'photos/random';

  @override
  Map<String, String> get queryParams => {
    'count': query.count.toString(),
    if (isNotEmpty(query.query))
      'query': query.query,
  };

}

class SearchPhotosProcessor extends PhotosProcessor<SearchPhotoQuery> {

  SearchPhotosProcessor(SearchPhotoQuery query) : super(query);

  @override
  String get path => 'search/photos';

  @override
  Map<String, String> get queryParams => {
    'page': query.page.toString(),
    'per_page': query.perPage.toString(),
    'query': query.search,
  };

  @override
  _parse(dynamic json, String header(String name)) {
    if (json is Map) {
      final data = json['results'];
      final totalPages = json['total_pages'];

      if (data == null || data is! List)
        throw ApiError(LocKeys.noData);

      final list = data as List;

      return PhotosProcessedResult(data, list.isNotEmpty && query.page < totalPages);
    }

    throw ApiError(LocKeys.dataUnsupported);
  }

}

class ProcessedResult { }

class PhotosProcessedResult {
  final List data;
  final bool hasMore;

  PhotosProcessedResult(this.data, this.hasMore);
}
