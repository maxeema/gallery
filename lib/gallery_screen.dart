
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:transparent_image/transparent_image.dart';

import 'data.dart';
import 'foto_screen.dart';
import 'network.dart';

class GalleryScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _GalleryScreenState();

}

class _GalleryScreenState extends State<GalleryScreen> {

  Api api;

  NetApiStatus status;
  NetApiResult result;

  int page = 1;

  _getData() async {
//    print('_GalleryScreenState._getData, $status');
    setState(() {
      status = NetApiStatus.loading;
    });
    result = await api.getPhotos(page);
    setState(() {
      status = result.status;
    });
  }
  _updateData() {
//    print('_GalleryScreenState.updateData, $status');
    if (status == NetApiStatus.loading)
      return;
    setState(() {
      status = NetApiStatus.loading;
    });
    _getData();
  }

  _open(Foto foto, String url) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FotoScreen(foto: foto, url: url),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
//    print('_GalleryScreenState.initState, $status, $result');
    if (api == null) {
      api = Api();
      status = NetApiStatus.loading;
      _getData();
    }
  }

  _createLoadingWidget() => Center(child: CircularProgressIndicator());
  
  _createErrorWidget() => GestureDetector(
    onTap: _updateData,
    child: Container(
      color: Colors.blue.shade200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top:16),
            child: Text(
              result.toBad.msg,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.body1,
            )
          ),
          Padding(
            padding: EdgeInsets.only(top:16),
            child: RaisedButton(
              onPressed: _getData,
              child: Text(
                'Retry'
              ),
            ),
          )
        ],
      ),
      alignment: AlignmentDirectional.center,
      padding: EdgeInsets.all(16),
    ),
  );

  _createFotoTile(Foto foto, Size size) {
    String url;
    return Container(
      color: Color(int.tryParse('FF${foto.color.substring(1)}', radix: 16) ?? Colors.transparent),
      width: size.width,
      height: size.height,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Hero(
            tag: foto.id,
            child: FadeInImage.memoryNetwork(
              image: url = foto.prepareUrlFor(size, window),
              fit: BoxFit.cover,
              placeholder: kTransparentImage,
            ),
          ),
          Align(
            alignment: AlignmentDirectional.bottomStart,
            child: Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(0x99)
              ),
              child: Text(
                foto.author ?? '',
                style: Theme.of(context).textTheme.caption.apply(
                  color: Colors.white.withAlpha(0xbb),
                  fontFamily: 'NanumPenScript'
                ),
              ),
            )
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _open(foto, url),
              child: () {
                final description = foto.description ?? foto.altDescription;
                return description == null ? null : Tooltip(message: description ?? '',);
              }(),
            )
          )
        ]
      )
    );
  }

  _createGalleryListWidget() {
    final fotos = result.toWell.response.data.toList();
    final media = MediaQuery.of(context);
    return ListView.builder(
      itemCount: fotos.length,
      itemBuilder: (context, index) {
        final foto = fotos[index];
        final width = media.size.width;
        final size = Size(width, foto.size.height / (foto.size.width / width));
        return SizedBox(
          child: _createFotoTile(foto, size),
          width: size.width,
          height: size.height,
        );
      },
    );
  }
  _createGalleryStaggeredWidget() {
    final fotos = result.toWell.response.data.toList();
    final media = MediaQuery.of(context);
    final columns = MediaQuery.of(context).orientation == Orientation.portrait ? 2 : 3;
    final spacing = 4.0;
    return StaggeredGridView.countBuilder(
      padding: EdgeInsets.all(spacing),
      itemCount: fotos.length,
      crossAxisCount: columns,
      mainAxisSpacing: spacing,
      crossAxisSpacing: spacing,
      itemBuilder: (context, index) {
        final foto = fotos[index];
        final width = (media.size.width - spacing*(columns+1)) / columns;
        final size = Size(width, foto.size.height / (foto.size.width / width));
        return _createFotoTile(foto, size);
      },
      staggeredTileBuilder: (index) => new StaggeredTile.fit(1),
    );
  }


  @override
  Widget build(BuildContext context) {
//    print('_GalleryScreenState.build, $status, $result');
//    print('window: ${window.physicalSize.width/window.devicePixelRatio} x ${window.physicalSize.height/window.devicePixelRatio}');
//    print('widget: ${MediaQuery.of(context)}');
    return Scaffold(
      body: (){
        switch (status) {
          case NetApiStatus.loading:
            return _createLoadingWidget();
          case NetApiStatus.error:
            return _createErrorWidget();
          default:
            return _createGalleryStaggeredWidget();
//            return _createGalleryListWidget();
        }
      }(),
    );
  }

}