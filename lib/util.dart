
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;

bool isEmpty(String s)    => s?.trim()?.isEmpty    ?? true;
bool isNotEmpty(String s) => s?.trim()?.isNotEmpty ?? false;

assetsSvgIcon(String name) => "assets/icons/${name.replaceAll(' ', '_').toLowerCase()}.svg";

twitterUrlByUser(String user) => 'https://twitter.com/$user';
instragramUrlByUser(String user) => 'https://www.instagram.com/$user';

launchUrl(String url)        => launcher.launch(url);
launchTwitter(String user)   => launchUrl(twitterUrlByUser(user));
launchInstagram(String user) => launchUrl(instragramUrlByUser(user));

String makeUrlBeautiful(String url) {
  final uri = Uri.parse(url);
  url = uri.hasScheme ? uri.toString().substring(uri.scheme.length + 3) : uri.toString();
  if (url.startsWith('www.'))
    url = url.substring(4);
  if (url.endsWith('/'))
    url = url.substring(0, url.length-1);
  return url;
}

copyToClipboard(String text) => Clipboard.setData(ClipboardData(text: text));

