
///
/// Real Network
///
part of unsplash_gallery.net;

const _api_base_url = 'api.unsplash.com';
const _api_tokens = [
  '896d4f52c589547b2134bd75ed48742db637fa51810b49b607e37e46ab2c0043',
  'ab3411e4ac868c2646c0ed488dfd919ef612b04c264f3374c97fff98ed253dc9',
  'cf49c08b444ff4cb9e4d126b7e9f7513ba1ee58de7906e4360afc1a33d1bf4c0',
];

const _max_fotos_per_page = 30; // api restricted the param from 10 up to 30
const _path_photos = 'photos';
const _errors_key = "errors";

class RealApi implements Api {

  RealApi([dynamic]); //injector constructor

  HttpClient _httpClient;

  @override
  Future<ApiResult>
  getPhotos(int page) async => _getPhotosImpl(_api_tokens.toSet(), page, _max_fotos_per_page);

  @override
  dispose() => _httpClient?.close();
  
  _acquireHttpClient() => _httpClient = HttpClient();

  Future<ApiResult>
  _getPhotosImpl(Set<String> tokens, int page, int perPage) async {
    ApiResult result;
    try {
      final uri = Uri.https(_api_base_url, _path_photos, {
        'client_id': tokens.first,
        'page': page.toString(),
        'per_page': perPage.toString(),
      });
      print('getPhotos, uri: $uri, tokens: ${tokens.length} $tokens');

      _acquireHttpClient();
      final response = await _process(Query(uri, page, perPage));
      print(' respone: $response');
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

    print('result: $result');

    if (result.status == ApiStatus.error) {
      tokens.remove(tokens.first);
      print(' process error, check available tokens, ${tokens.length} $tokens');
      if (tokens.isNotEmpty)
        return _getPhotosImpl(tokens, page, perPage);
    }

    return result;
  }

  Future<Response>
  _process(Query query) async {
    assert (_httpClient != null);

    final request = await _httpClient.getUrl(query.uri);
    print('\n_process, request: $request');

    print('_process, request.headers: ${request.headers}');

    final response = await request.close();
    print('\nresponse statusCode: ${response.statusCode}');

    print('response headers: ${response.headers}');

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

    if (jsonResponse is Map && jsonResponse.containsKey(_errors_key))
      throw jsonResponse[_errors_key][0];

    if (response.statusCode == HttpStatus.ok) {
      final data = jsonResponse as List<dynamic>;

      if (data?.isEmpty ?? true)
        throw 'Emtpy response';

      print('map response');
      return Response(query,
          data.map((item) => Foto.from(item, item['user'], item['urls'])),
          rateLimit: int.tryParse(response.headers.value('x-ratelimit-limit')) ?? -1,
          rateLimitRemaining: int.tryParse(response.headers.value('x-ratelimit-remaining')) ?? -1
      );
    }

    throw 'Bad response';
  }

}
