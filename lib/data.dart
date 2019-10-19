
import 'dart:ui';

import 'package:flutter/material.dart';

class Foto {

  final String
      id,
      author,
      description,
      color, // in format #00ff00
      url;   // raw

  final Size size;


  Foto.from(Map<String, dynamic> img, Map<String, dynamic> user, Map<String, dynamic> urls) :
    id = img['id'],
    color = img['color'],
    author = user['name'],
    description = img['description'],
    size = Size((img['width'] as num).toDouble(), (img['height'] as num).toDouble()),
    url = urls['raw'];

  String prepareUrlFor(Size size, Window window) {
    final prepared = '$url&w=${size.width}&dpr=${window.devicePixelRatio}';
    print('foto prepared url: $prepared');
    return prepared;
  }

//  static double extractWidth(String url) => double.tryParse(Uri.parse(url).queryParameters['w']) ?? -1.0;

}