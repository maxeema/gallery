
extension IntExt on int {
  Duration get ms => Duration(milliseconds: this);
  Duration get sec => Duration(seconds: this);
}

extension StringExt on String {
  String leaveMandatoryUrl() {
    String url = this;
    final uri = Uri.parse(url);
    url = uri.hasScheme ? uri.toString().substring(uri.scheme.length + 3) : uri.toString();
    if (url.startsWith('www.'))
      url = url.substring(4);
    if (url.endsWith('/'))
      url = url.substring(0, url.length-1);
    return url;
  }
}
