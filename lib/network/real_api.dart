part of gallery.net;

///
/// Real Network
///

class NetworkImpl implements Network {

  final String _apiBaseUrl;
  final Set<String> _apiTokens;

  NetworkImpl(this._apiBaseUrl, this._apiTokens);

  @override
  dispose() { }
  
  _acquireHttpClient() async { }

  @override
  Future<NetworkResult>
  fetchNew(NewPhotoQuery query)
      => _process(NewPhotosProcessor(query), _apiTokens.toSet());

  @override
  Future<NetworkResult> search(SearchPhotoQuery query)
      => _process(SearchPhotosProcessor(query), _apiTokens.toSet());

  @override
  Future<NetworkResult> getRandom(RandomQuery query)
      => _process(RandomPhotosProcessor(query), _apiTokens.toSet());

  Future<NetworkResult>
  _process(PhotosProcessor processor, Set<String> tokens) async {
    final uri = Uri.https(_apiBaseUrl,
                          processor.path,
                          processor.queryParams..['client_id'] = tokens.first);
    print('\n\n[real network] get photos, uri: $uri');
    NetworkResult result;
    try {
      _acquireHttpClient();
      final processedResult = await _processImpl(uri, processor);
      result = NetworkResult(processor.query, Success(processedResult.data), null, hasMore: processedResult.hasMore);
    } on ApiError catch (err) {
      print("handle api err: '${err.locKey}'");
      result = NetworkResult(processor.query, null, Failure(err));
    } on RemoteError catch (err) {
      print("handle remote err: '${err.notLocalized}'");
      result = NetworkResult(processor.query, null, Failure(err));
    } catch (e, s) {
      print('catch exception: $e, $s');
      result = NetworkResult(processor.query, null, Failure(e));
    }

    if (result.failure != null) {
      tokens.remove(tokens.first);
//      print('process error, check available tokens, ${tokens.length}');
      if (tokens.isNotEmpty)
        return _process(processor, tokens);
    }

    return result;
  }

  Future<PhotosProcessedResult>
  _processImpl(Uri uri, PhotosProcessor processor) async {

    final response = await http.get(uri.toString());

    print('\nresponse statusCode: ${response.statusCode}'
          '\nheaders: ${response.headers}');

    if (response.headers['x-ratelimit-remaining'] == '0')
      throw ApiError(LocKeys.rateLimit);

    final body = response.body;

    if (body?.trim()?.isEmpty ?? true)
      throw ApiError(LocKeys.unreachable);

    return processor.process(body, response.statusCode, (name)=> response.headers[name]);
  }

}
