
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;

import 'ui.dart';

bool isEmpty(String s)    => s?.trim()?.isEmpty    ?? true;
bool isNotEmpty(String s) => s?.trim()?.isNotEmpty ?? false;

assetsSvgIcon(String name) => "assets/icons/${name.replaceAll(' ', '_').toLowerCase()}.svg";

twitterUrlByUser(String user) => 'https://twitter.com/$user';
instragramUrlByUser(String user) => 'https://www.instagram.com/$user';

launchUrl(String url) {
  print(url);
  launcher.launch(url);
}
launchTwitter(String user)   => launchUrl(twitterUrlByUser(user));
launchInstagram(String user) => launchUrl(instragramUrlByUser(user));

String beautifyUrl(String url) {
  final uri = Uri.parse(url);
  url = uri.hasScheme ? uri.toString().substring(uri.scheme.length + 3) : uri.toString();
  if (url.startsWith('www.'))
    url = url.substring(4);
  if (url.endsWith('/'))
    url = url.substring(0, url.length-1);
  return url;
}

copyToClipboard(String text, {BuildContext ctx, String toastMsg}) {
  Clipboard.setData(ClipboardData(text: text));
  print('Copied to clipboard: $text');
  if (toastMsg != null && ctx != null)
    toast(ctx, toastMsg);
}

