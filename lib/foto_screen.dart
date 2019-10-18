import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

import 'data.dart';

class FotoScreen extends StatelessWidget {

  final Foto foto;
  final String url;

  const FotoScreen({@required this.foto, @required this.url});

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    var width = media.size.width;
    var size = Size(width, foto.size.height / (foto.size.width / width));
    var scrollAxis = Axis.vertical;
//    print('initial size: $size');
    if (size.height < media.size.height) {
      final height = media.size.height;
      width = foto.size.width / (foto.size.height / height);
      size = Size(width, height);
      scrollAxis = Axis.horizontal;
//      print('updated size: $size');
    }
    print("size $size");
    return Scaffold(
      backgroundColor: Color(int.tryParse('FF${foto.color.substring(1)}', radix: 16) ?? Colors.transparent),
      body: Hero(
        tag: foto.id,
        child: SingleChildScrollView(
          scrollDirection: scrollAxis,
          controller: ScrollController(
            initialScrollOffset: scrollAxis == Axis.vertical ? (size.height-media.size.height) / 2 : (size.width-media.size.width) / 2,
          ),
          child: Stack(
            children: <Widget>[
              Image.network(
                url,
                fit: BoxFit.cover,
                width: size.width,
                height: size.height,
              ),
              FadeInImage.memoryNetwork(
                image: foto.prepareUrlFor(size, window),
                placeholder: kTransparentImage,
                fit: BoxFit.cover,
                width: size.width,
                height: size.height,
              ),
            ],
          )
        )
      ),
    );
  }

}
