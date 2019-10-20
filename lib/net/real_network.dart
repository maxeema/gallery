
///
/// Real Network
///
part of unsplash_gallery.net;

class RealApi implements Api {

  final String _apiBaseUrl;
  final Set<String> _apiTokens;
  final int _photosPerPage;

  RealApi(this._apiBaseUrl, this._apiTokens, this._photosPerPage);

  HttpClient _httpClient;

  @override
  Future<ApiResult>
  getPhotos(int page) async => _getPhotosImpl(page, _apiTokens.toSet());

  @override
  dispose() => _httpClient?.close();
  
  _acquireHttpClient() => _httpClient = HttpClient();

  Future<ApiResult>
  _getPhotosImpl(int page, Set<String> tokens) async {
    ApiResult result;
    try {
      final uri = Uri.https(_apiBaseUrl, 'photos', {
        'client_id': tokens.first,
        'page': page.toString(),
        'per_page': _photosPerPage.toString(),
      });
      print('\n\n[real network] get photos, uri: $uri, tokens size: ${tokens.length}');

      _acquireHttpClient();
      final response = await _process(Query(uri, page, _photosPerPage));
      result = ApiResult.well(response, false);
    } on String catch (e) {
      print('catch msg: $e');
      result = ApiResult.bad(e);
    } on Exception catch (e, s) {
      print('catch exception: $e');
      if (s != null)
        print(s);
      result = ApiResult.bad("An error occured.\n\n${e.toString()}", e);
    } catch (e, s) {
      print('catch error: $e');
      if (s != null)
        print(s);
      result = ApiResult.bad("Unknown error.\n\n${e.toString()}", e);
    }

    if (result.status == ApiStatus.error) {
      tokens.remove(tokens.first);
      print('process error, check available tokens, ${tokens.length}');
      if (tokens.isNotEmpty)
        return _getPhotosImpl(page, tokens);
    }

    return result;
  }

  Future<Response>
  _process(Query query) async {
    assert (_httpClient != null);

    final request = await _httpClient.getUrl(query.uri);
    print('\nrequest: $request'
          '\nheaders: ${request.headers}');

    final response = await request.close();

    print('\nresponse statusCode: ${response.statusCode}'
          '\nheaders: ${response.headers}');

    final responseBody = await response.transform(utf8.decoder).join();

    if (responseBody?.trim()?.isEmpty ?? true)
      throw 'Emtpy response';

    dynamic jsonResponse;
    try {
      jsonResponse = json.decode(responseBody);
    } catch (e, s) {
      if (s != null)
        print(s);
      throw responseBody;
    }

    if (jsonResponse is Map && jsonResponse.containsKey('errors'))
      throw jsonResponse['errors'][0];

    if (response.statusCode == HttpStatus.ok) {
      final data = jsonResponse as List<dynamic>;

      if (data?.isEmpty ?? true)
        throw 'Emtpy response';

      return Response(query,
          data.map((item) => Foto.from(item, item['user'], item['urls'])),
          rateLimit: int.tryParse(response.headers.value('x-ratelimit-limit')) ?? -1,
          rateLimitRemaining: int.tryParse(response.headers.value('x-ratelimit-remaining')) ?? -1
      );
    }

    throw 'Bad response';
  }

}
