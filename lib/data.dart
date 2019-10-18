
import 'dart:ui';

import 'package:flutter/material.dart';

class Foto {

  final Map<String, dynamic> _img;
  final Map<String, dynamic> _user;
  final Map<String, dynamic> _urls;

  String get id => _img['id'];
  String get color => _img['color'];
  String get author => _user['name'];
  String get description => _img['description'];
  String get altDescription => _img['alt_description'];

  Size get size => Size((_img['width'] as int).toDouble(), (_img['height'] as int).toDouble());


  Foto.from(Map<String, dynamic> img, Map<String, dynamic> user, Map<String, dynamic> urls):
    _img = img,
    _user = user,
    _urls = urls;

  String prepareUrlFor(Size size, Window window) {
    final prepared = '${_urls['raw']}&w=${size.width}&dpr=${window.devicePixelRatio}';
    print('foto prepared url: $prepared');
    return prepared;
  }

//  static double extractWidth(String url) => double.tryParse(Uri.parse(url).queryParameters['w']) ?? -1.0;

}