import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:maxeem_gallery/domain/photo.dart';
import 'package:maxeem_gallery/misc/util.dart';
import 'package:transparent_image/transparent_image.dart';

class PhotoScreen extends StatelessWidget {

  final Photo photo;
  final String url;

  const PhotoScreen({@required this.photo, @required this.url});

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    var width = media.size.width;
    var size = Size(width, photo.size.height / (photo.size.width / width));
    var scrollAxis = Axis.vertical;
//    print('initial size: $size');
    if (size.height < media.size.height) {
      final height = media.size.height;
      width = photo.size.width / (photo.size.height / height);
      size = Size(width, height);
      scrollAxis = Axis.horizontal;
//      print('updated size: $size');
    }
    final fullSizedUrl = preparePhotoUrl(photo.url, size, window);
//    print('$fullSizedUrl \n for $size');
    return Scaffold(
      backgroundColor: Color(int.tryParse('FF${photo.color.substring(1)}', radix: 16) ?? Colors.transparent),
      body: Hero(
        tag: photo.id,
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
                image: fullSizedUrl,
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
