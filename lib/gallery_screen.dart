
import 'dart:math';
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

  ScrollController scrollController;

  Api api;

  NetApiStatus status;
  NetApiResult result;

  final data = <Foto>[];
  int page = 1;

  bool get isLoading => status == NetApiStatus.loading;
  bool get isError   => status == NetApiStatus.error;

  _getData({more=false}) async {
    if (isLoading)
      return;

    Scaffold.of(context).removeCurrentSnackBar();

    print('_GalleryScreenState._getData, $status');
    setState(() {
      status = NetApiStatus.loading;
    });

    result = await api.getPhotos(more ? page+1 : page);

    setState((){
      status = result.status;
    });

    if (status == NetApiStatus.success) {
      data.addAll(result.toWell.response.data);
      if (more) {
        page++;
        print("scrollController, $scrollController \n, ${scrollController.offset}");
        final media = MediaQuery.of(context);
        scrollController.animateTo(
            scrollController.offset + media.size.height*.75,
            duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
      }
    }
    if (isError && data.isNotEmpty)
      Scaffold.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text(result.toBad.msg),
          duration: Duration(seconds: 6),
          behavior: SnackBarBehavior.floating,
          action: SnackBarAction(label:'Retry', onPressed: () {
            Scaffold.of(context).removeCurrentSnackBar();
            _getData(more:true);
          }),
        ));
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
  void didUpdateWidget(GalleryScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
//    print('_GalleryScreenState.didUpdateWidget');
  }

  @override
  void dispose() {
//    print('_GalleryScreenState.dispose');
    api.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
//    print('_GalleryScreenState.initState, $status, $result');
    if (api == null) {
      api = Api();
      _getData();
    }
    if (scrollController == null) {
      scrollController = ScrollController()..addListener(() {
//        print("scrollController, $scrollController \n, ${scrollController.offset}");
        if (scrollController.position.pixels == scrollController.position.maxScrollExtent)
          _getData(more:true);
      });
    }
  }

  _createLoadingWidget() => Center(child: CircularProgressIndicator());
  
  _createErrorWidget() => GestureDetector(
    onTap: _getData,
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

//  _createGalleryListWidget() {
//    final media = MediaQuery.of(context);
//    return ListView.builder(
//      itemCount: data.length,
//      itemBuilder: (context, index) {
//        final foto = data[index];
//        final width = media.size.width;
//        final size = Size(width, foto.size.height / (foto.size.width / width));
//        return SizedBox(
//          child: _createFotoTile(foto, size),
//          width: size.width,
//          height: size.height,
//        );
//      },
//    );
//  }
  _createGalleryStaggeredWidget() {
    final media = MediaQuery.of(context);
    final columns = max(2, media.size.width ~/ 200);
    print(' use columns $columns, ${media.size}');
    final spacing = 4.0;
    return StaggeredGridView.countBuilder(
      controller: scrollController,
      padding: EdgeInsets.all(spacing),
      itemCount: data.length + (data.isNotEmpty ? 1 : 0),
      crossAxisCount: columns,
      mainAxisSpacing: spacing,
      crossAxisSpacing: spacing,
      itemBuilder: (context, index) {
        if (index == data.length && data.isNotEmpty) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 64),
              alignment: Alignment.center,
              child: isLoading
                  ? CircularProgressIndicator()
                  : FlatButton(
                      child: Text('Show more'),
                      onPressed: () => _getData(more:true),
                    )
            );
        }
        final foto = data[index];
        final width = (media.size.width - spacing*(columns+1)) / columns;
        final size = Size(width, foto.size.height / (foto.size.width / width));
        return _createFotoTile(foto, size);
      },
      staggeredTileBuilder: (index) => new StaggeredTile.fit(1),
    );
  }

  @override
  Widget build(BuildContext context) {
//    print('_GalleryScreenState.build, data size: ${data.length}, $status, $result');
//    print('window: ${window.physicalSize.width/window.devicePixelRatio} x ${window.physicalSize.height/window.devicePixelRatio}');
//    print('widget: ${MediaQuery.of(context)}');
    return Scaffold(
      body: (){
        if (isLoading && data.isEmpty)
          return _createLoadingWidget();
        if (isError && data.isEmpty)
          return _createErrorWidget();
        return _createGalleryStaggeredWidget();
      }(),
    );
  }

}