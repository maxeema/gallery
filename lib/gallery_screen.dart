
import 'dart:collection';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:unsplash_gallery/ui.dart';

import 'conf.dart' as conf;
import 'data.dart';
import 'foto_screen.dart';
import 'injection.dart';
import 'net/api.dart' as net;

class GalleryScreen extends Scaffold {

  @override
  _GalleryScreenState createState() => _GalleryScreenState();

}

const _autoLoadDataThresholdRowFromEnd = 3;

class _GalleryScreenState extends ScaffoldState with Injectable {

  ScrollController scrollController;

  net.Api api;
  net.ApiStatus status;
  net.ApiResult result;

  int page = 2;
  var data = LinkedHashSet<Foto>();
  int itemBuilderAutoLoadMoreIdx;
  var fabAnimationKey = ValueKey(true);

  bool showNoMoreEvent = false,
       isRefreshing    = false,
       loadByUser      = false,
       hasNoMore       = false;

  bool get isError   => status == net.ApiStatus.error;
  bool get isLoading => status == net.ApiStatus.loading;
  bool get canRefresh => data.isNotEmpty && !isRefreshing;

  BuildContext scaffoldCtx;

//  BuildContext get ctx => context;
  _getFresh() async {
    print('\ncall _getFresh, refreshing: $isRefreshing');
    if (isRefreshing)
      return;

    setStateSafe(() {
      isRefreshing = true;
    });

    final result = await api.getPhotos(1);

    setStateSafe((){
      isRefreshing = false;
    });

    if (result.status == net.ApiStatus.error) {
      snackbar(scaffoldCtx, result.toBad.msg);
      return;
    }

    final dataSizeBeforeRefresh = data.length;

    if (!data.containsAll(result.toWell.response.data))
      setState(() {
        data = LinkedHashSet.of(result.toWell.response.data)..addAll(data);
      });

    final dataSizeAfterRefresh = data.length;

    print('\non success, before refresh '
        '\n data now size: $dataSizeBeforeRefresh'
        '\n data response size: ${result.toWell.response.data.length}'
        '\n data new size: $dataSizeAfterRefresh'
    );

    final addedDataAmount = dataSizeBeforeRefresh - dataSizeAfterRefresh;

    if (addedDataAmount == 0)
      snackbar(scaffoldCtx, 'You see the latest photos');

  }

  _getData({more=false, byUser=false}) async {
    print('\ncall _getData, more: $more, isLoading: $isLoading, hasNoMore: $hasNoMore status: $status');
    if (byUser)
      loadByUser = true;

    if (isLoading || hasNoMore)
      return;

    setStateSafe(() {
      status = net.ApiStatus.loading;
    });

    _getDataImpl(more);
  }

  _getDataImpl(bool more, [recursiveDataAddedAmount=0]) async {
//    print('\ncall _getDataImpl, more: $more, recursiveDataAddedAmount: $recursiveDataAddedAmount');

    result = await api.getPhotos(more ? page+1 : page);

    if (result.status == net.ApiStatus.success) {
      hasNoMore = result.toWell.noMore;
      showNoMoreEvent = hasNoMore;

      final dataSizeBeforeMerge = data.length;
//      print('\non success, before merging to '
//          '\n data now size: $dataSizeBeforeMerge'
//          '\n data response size: ${result.toWell.response.data.length}'
//      );

      data.addAll(result.toWell.response.data);

      final dataSizeAfterMerge = data.length;
      print('data new size: $dataSizeAfterMerge');

      if (more)
        page++;

      final addedDataAmount = dataSizeAfterMerge - dataSizeBeforeMerge;
      recursiveDataAddedAmount += addedDataAmount;
//      print('\n addedDataAmount $addedDataAmount'
//          '\n recursiveDataAddedAmount $recursiveDataAddedAmount');

      final media = MediaQuery.of(context);

      if (addedDataAmount > 0) {
        loadByUser = false;
        invalidateState();
        if (isAlmostAtTheEndOfTheScroll(media))
          scrollController?.animateTo(scrollController.offset + media.size.height*.75,
              duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
      }

      if (!result.toWell.noMore && recursiveDataAddedAmount < conf.photosPerUiOperation) {
        _getDataImpl(true, recursiveDataAddedAmount);
        return;
      }
    }

    setStateSafe((){
      status = result.status;
    });

    if (isError && data.isNotEmpty && loadByUser)
      actionSnackbar(scaffoldCtx, result.toBad.msg, 'Retry', () => _getData(more: true, byUser: true));

    loadByUser = false;
  }

  setStateSafe(action()) {
    try { // possible place for an error when call setState() during build()
      action();
      setState((){});
    } catch (e) { }
  }

  invalidateState() => setState((){});

  _open(Foto foto, String url) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FotoScreen(foto: foto, url: url),
      ),
    );
  }

  @override
  didUpdateWidget(GalleryScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
//    print('_GalleryScreenState.didUpdateWidget');
  }

  @override
  initState() {
    super.initState();
//    print('_GalleryScreenState.initState');
    api = inject();
    _getData();
  }

  @override
  dispose() {
//    print('_GalleryScreenState.dispose');
    api?.dispose();
    scrollController?.dispose();
    super.dispose();
  }

  bool isAlmostAtTheEndOfTheScroll(MediaQueryData media) => scrollController != null
      && (scrollController.position.maxScrollExtent - scrollController.position.pixels) <= media.size.height / 3;

  onScroll() {
    print("scrollController, isAlmostAtTheEndOfTheScroll: ${isAlmostAtTheEndOfTheScroll(MediaQuery.of(context))},"
        " scroll off: ${scrollController.offset}, scroll pos ext: ${scrollController.position.maxScrollExtent}");
    if (scrollController.position.pixels != scrollController.position.maxScrollExtent)
      return;

    if (showNoMoreEvent) {
      print("\nscrollController, showNoMoreEvent, unregister scroll listener");
      showNoMoreEvent = false;
      scrollController.removeListener(onScroll);
      snackbar(scaffoldCtx, 'You have reached the end.');
      return;
    }

    if (!hasNoMore)
      _getData(more: true, byUser: true);
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
    final url = foto.prepareUrlFor(size, window);
    print(url);
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
              image: url,
              fit: BoxFit.cover,
              placeholder: kTransparentImage,
            ),
          ),
          if (foto?.author?.trim()?.isNotEmpty ?? false) Align(
            alignment: AlignmentDirectional.bottomStart,
            child: Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(0x99)
              ),
              child: Text(
                foto.author,
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
                  final description = foto.description?.trim();
                  return description == null ? null : Tooltip(message: description);
                }(),
              )
          ),
        ]
      )
    );
  }

  _createGalleryStaggeredWidget() {
    final media = MediaQuery.of(context);
    final columns = max(2, media.size.width ~/ 200);
    final spacing = 4.0;
    final loadMoreIdx = data.length - _autoLoadDataThresholdRowFromEnd*columns;
    return StaggeredGridView.countBuilder(
      controller: scrollController ??= ScrollController()..addListener(onScroll),
      padding: EdgeInsets.all(spacing),
      itemCount: data.length + (hasNoMore ? 0 : 1),
      crossAxisCount: columns,
      mainAxisSpacing: spacing,
      crossAxisSpacing: spacing,
      itemBuilder: (context, index) {
        if (index == loadMoreIdx && !hasNoMore && loadMoreIdx != itemBuilderAutoLoadMoreIdx) {
          itemBuilderAutoLoadMoreIdx = loadMoreIdx;
//          print('item builder: auto load more data on idx: $index of ${data.length},'
//              ' columns: $columns, rows: ${data.length / columns}');
          _getData(more: true);
        }
        if (index == data.length && !hasNoMore) {
          return SizedBox(
            width: double.infinity,
            height: media.size.height / 4,
              child: Align(
                alignment: Alignment.center,
                child: isLoading
                  ? CircularProgressIndicator()
                  : InkResponse(
                      radius: 70,
                      onTap: () => _getData(more: true, byUser: true),
                      child: OutlineButton(child:Text('Get more', textAlign: TextAlign.center,), onPressed: null,)
                    ),
            ),
          );
        }
        final foto = data.elementAt(index);
        final width = (media.size.width - spacing*(columns+1)) / columns;
        final size = Size(width, foto.size.height / (foto.size.width / width));
        return _createFotoTile(foto, size);
      },
      staggeredTileBuilder: (index) => new StaggeredTile.fit(1),
    );
  }

  _createShuffleFab() {
    return FloatingActionButton(
      onPressed: () {
        fabAnimationKey = ValueKey(!fabAnimationKey.value);
        shuffleData();
      },
      tooltip: "Shuffle all",
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 500),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return RotationTransition(child: child, turns: animation,);
        },
        child: Icon(
          Icons.shuffle,
          key: fabAnimationKey,
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
//    print('_GalleryScreenState.build, data size: ${data.length}, $status, $result');
//    print('window: ${window.physicalSize.width/window.devicePixelRatio} x ${window.physicalSize.height/window.devicePixelRatio}');
    return Scaffold(
      floatingActionButton: data.isNotEmpty ? _createShuffleFab() : null,
      body: Builder(
        builder: (BuildContext context) {
          scaffoldCtx = context;
          if (isLoading && data.isEmpty)
            return _createLoadingWidget();
          if (isError && data.isEmpty)
            return _createErrorWidget();
          //
          return RefreshIndicator(
            onRefresh: ()=> _getFresh(),
            child: Stack(
            children: <Widget>[
              _createGalleryStaggeredWidget(),
            ],
            )
          );
        },
      ),
    );
  }

  shuffleData() => setState(() { data = LinkedHashSet.of(data.toList()..shuffle(Random())); });

}
