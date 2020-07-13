import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:maxeem_gallery/domain/photo.dart';
import 'package:maxeem_gallery/misc/util.dart';
import 'package:photo_view/photo_view.dart';

class PhotoScreen extends StatelessWidget {

  final Photo photo;
  final String url;

  const PhotoScreen({@required this.photo, @required this.url});

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    var width = media.size.width;
    var size = Size(width, photo.size.height / (photo.size.width / width));
//    var scrollAxis = Axis.vertical;
////    print('initial size: $size');
//    if (size.height < media.size.height) {
//      final height = media.size.height;
//      width = photo.size.width / (photo.size.height / height);
//      size = Size(width, height);
//      scrollAxis = Axis.horizontal;
////      print('updated size: $size');
//    }
    final fullSizedUrl = preparePhotoUrl(window, size, photo.url);
//    print('$fullSizedUrl \n for $size');
    final bgColor = Color(int.tryParse('FF${photo.color.substring(1)}', radix: 16) ?? Colors.transparent);
    return Scaffold(
      key: Key("photo_scaffold"),
      backgroundColor: bgColor,
      //used for UI tests
      floatingActionButton: Opacity(
        opacity: 0,
        child: SizedBox(
          width: 5, height: 5,
          child: InkWell(
            key: Key("back_btn"),
            onTap: () => Navigator.pop(context),
          ),
        )
      ),
      body: Hero(
        tag: photo.id,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Image.network(
              url,
              fit: BoxFit.cover,
              width: size.width,
              height: size.height,
            ),
            PhotoView(
              imageProvider: NetworkImage(fullSizedUrl),
              backgroundDecoration: BoxDecoration(color: bgColor),
              loadingBuilder: (context, progress) => Center(
                child: Container(
                  width: 20.0,
                  height: 20.0,
                  child: CircularProgressIndicator(
                    strokeWidth: 1.5,
                    value: progress == null
                        ? null
                        : progress.cumulativeBytesLoaded /
                        progress.expectedTotalBytes,
                  ),
                ),
              ),
              enableRotation: true,
              gaplessPlayback: false,
              initialScale: PhotoViewComputedScale.covered,
              minScale: PhotoViewComputedScale.contained * 1,
              maxScale: PhotoViewComputedScale.covered * 2.5,
            ),
//              FadeInImage.memoryNetwork(
//                image: fullSizedUrl,
//                placeholder: kTransparentImage,
//                fit: BoxFit.cover,
//                width: size.width,
//                height: size.height,
//              ),
          ],
        )
      ),
    );
  }

}
