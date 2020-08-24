
import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gallery/domain/photo.dart';
import 'package:gallery/localizations/localization.dart';
import 'package:gallery/misc/categories.dart';
import 'package:gallery/misc/util.dart';
import 'package:gallery/misc/ext.dart';
import 'package:gallery/models/model.dart';
import 'package:gallery/models/photos_model.dart';
import 'package:transparent_image/transparent_image.dart';

import '../details_screen.dart';
import '../photo_screen.dart';
import '../ui.dart';

class GalleryWidget extends StatefulWidget {

  final Category category;

  GalleryWidget(this.category, {Key key}) : super(key: key);

  @override
  _GalleryWidgetState createState() {
    final model = modelByCategory(category);
    switch (category) {
      case Category.NEW:
        return _GalleryWidgetPagedRefreshState(model);
      default:
        return _GalleryWidgetPagedState(model);
    }
  }

}

abstract class _GalleryWidgetState<M extends PhotosModel> extends State<GalleryWidget> with LocalizableState {

  _GalleryWidgetState(this.model);

  M model;

  ScrollController scrollController;

  int itemBuilderAutoLoadMoreIdx;

  bool loadByUser = false;

  bool get isError        => model.status.value == ModelStatus.error;
  bool get isLoading      => model.status.value == ModelStatus.loading;
  bool get canLoadMore    => model.hasMore;

  Set<Photo> photos;
  FailureInfo failure;

  Future<void> Function() refresh;

  @override
  initState() {
    super.initState();
//    print('${this.hashCode}, GalleryWidgetState.initState');
    model.init();
    model.status.observe(observeStatus);
    model.successEvent.observe(observeSuccess);
    model.failureEvent.observe(observeFailureEvent);
  }
  @override
  dispose() {
//    print('${this.hashCode}, GalleryWidgetState.dispose on GalleryWidget ${widget.hashCode}');
    model.status.unObserve(observeStatus);
    model.successEvent.unObserve(observeSuccess);
    model.failureEvent.unObserve(observeFailureEvent);
    model.dispose();
    scrollController?.dispose();
    super.dispose();
  }
//  @override
//  didUpdateWidget(GalleryWidget oldWidget) {
//    print('${this.hashCode}, GalleryWidgetState.didUpdateWidget on GalleryWidget ${widget.hashCode}');
//    super.didUpdateWidget(oldWidget);
//  }

  setStateSafe(action()) {
    try { // possible place for an error when call setState() during build()
      action();
      setState((){});
    } catch (e) { }
  }

  invalidateState() => setState((){});

  observeStatus(ModelStatus status) {
//    print('statusObserve, $status');
    setStateSafe((){
      if (status == ModelStatus.success)
        failure = null;
    });
  }

  observeSuccess(SuccessInfo info) {
//    print('observeSuccess, ${info.photos.length}');
    setStateSafe(() {
      photos = info.photos;
      loadByUser = false;
      scrollOnSuccess(info.action);
    });
  }

  bool observeFailureEvent(FailureInfo failure) {
//    print('observeFailureEvent, loadByUser: $loadByUser, error: ${failure.locKey} ${failure.notLocalized ?? ''}');
    if (model.isEmpty) {
      setStateSafe(() {
        this.failure = failure;
      });
      return true;
    }
    if (failure.action == ModelAction.list && loadByUser) {
      actionSnackbar(context, failure.toLocalizedMessage(l), l.retry, () {
        loadByUser = true;
        model.listPhotos();
      });
      return true;
    }
    return false;
  }

  _details(Photo photo) {
    showDialog(context: context, builder: (BuildContext context) {
      return SimpleDialog(
          contentPadding: EdgeInsets.all(0),
          children: <Widget>[
            DetailsScreen(photo),
          ]
      );
    });
  }

  _open(Photo photo, String url) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PhotoScreen(photo: photo, url: url),
      ),
    );
  }

  scrollOnSuccess(ModelAction action) {
    if (action == ModelAction.list) {
//      scrollPage();
    } else if (action == ModelAction.refresh) {
      scrollToBegin();
    }
  }

  scrollToBegin() => animateScrollTo(0);

  scrollPage() {
    final media = MediaQuery.of(context);
    if (isAlmostAtTheEndOfTheScroll(media))
      animateScrollTo(scrollController.offset + media.size.height*.75);
  }

  animateScrollTo(double offset) {
    scrollController?.animateTo(offset, duration: 500.ms, curve: Curves.easeInOut);
  }

  bool isAlmostAtTheEndOfTheScroll(media) => scrollController != null
      && (scrollController.position.maxScrollExtent - scrollController.position.pixels) <= media.size.height / 3;

  onScroll() {
//    print("scrollController, isAlmostAtTheEndOfTheScroll: ${isAlmostAtTheEndOfTheScroll(MediaQuery.of(context))},"
//        " scroll off: ${scrollController.offset}, scroll pos ext: ${scrollController.position.maxScrollExtent}");
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent)
      _onScrolledToTheEnd();
  }

  _onScrolledToTheEnd() {
    if (canLoadMore)
      model.listPhotos();
    loadByUser = true;
  }

  _createLoadingWidget() => Center(child: CircularProgressIndicator());

  _createErrorWidget() =>
    Container(
      color: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
              padding: EdgeInsets.only(top:16),
              child: Text(
                failure.toLocalizedMessage(l),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.body1,
              )
          ),
          Padding(
            padding: EdgeInsets.only(top:16),
            child: OutlineButton(
              onPressed: model.listPhotos,
              borderSide: BorderSide(
                color: Colors.indigo,
              ),
              child: Text(
                l.refresh,
                style: TextStyle(
                  color: Colors.indigo
                ),
              ),
            ),
          )
        ],
      ),
      alignment: AlignmentDirectional.center,
      padding: EdgeInsets.all(16),
    );

  _createPhotoTile(Photo photo, int index, Size size) {
    final url = preparePhotoUrl(window, size, photo.url);
//    print(url);
    return Container(
      color: Color(int.tryParse('FF${photo.color.substring(1)}', radix: 16) ?? Colors.transparent),
      width: size.width,
      height: size.height,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Hero(
            tag: photo.id,
            child: FadeInImage.memoryNetwork(
              image: url,
              fit: BoxFit.cover,
              placeholder: kTransparentImage,
            ),
          ),
          if (isNotEmpty(photo.author.name)) Align(
              alignment: AlignmentDirectional.bottomStart,
              child: Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                    color: Colors.black.withAlpha(0x99)
                ),
                child: Text(
                  photo.author.name,
                  style: Theme.of(context).textTheme.caption.apply(
                    color: Colors.white.withAlpha(0xbb),
                    fontFamily: fontCaveat,
                  ),
                ),
              )
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              key: Key("photo$index"),
              onTap: () => _open(photo, url),
              onLongPress: () => _details(photo),
            )
          ),
        ]
      )
    );
  }

  _createGalleryStaggeredWidget() {
    final media = MediaQuery.of(context);
    final width = media.size.width;
    int columns;
    if (width < 360) {
      columns = 1;
    } else if (width < 800) {
      columns = max(2, width ~/ 200);
    } else {
      columns = max(3, width ~/ 270);
    }
    final spacing = 4.0;
    final loadMoreIdx = photos.length - (media.orientation == Orientation.landscape ? 2 : 3)*columns;
    return StaggeredGridView.countBuilder(
      key: Key("gallery_grid"),
      controller: scrollController ??= ScrollController()..addListener(onScroll),
      padding: EdgeInsets.all(spacing),
      itemCount: photos.length + (canLoadMore ? 1 : 0),
      crossAxisCount: columns,
      mainAxisSpacing: spacing,
      crossAxisSpacing: spacing,
      itemBuilder: (context, index) {
        if (index == loadMoreIdx && canLoadMore && loadMoreIdx != itemBuilderAutoLoadMoreIdx) {
          itemBuilderAutoLoadMoreIdx = loadMoreIdx;
//          print('item builder: auto load more data on idx: $index of ${data.length},'
//              ' columns: $columns, rows: ${data.length / columns}');
          model.listPhotos();
        }
        if (index == photos.length && canLoadMore) {
          return SizedBox(
            width: double.infinity,
            height: media.size.height / 4,
            child: Align(
              alignment: Alignment.center,
              child: isLoading
              ? CircularProgressIndicator()
              : InkResponse(
                  radius: 70,
                  onTap: () {
                    loadByUser = true;
                    model.listPhotos();
                  },
                  child: OutlineButton(
                    child: Text(
                      l.getMore,
                      textAlign: TextAlign.center,
                    ), onPressed: null,
                  )
              ),
            ),
          );
        }
        final photo = photos.elementAt(index);
        final width = (media.size.width - spacing*(columns+1)) / columns;
        final size = Size(width, photo.size.height / (photo.size.width / width));
        return _createPhotoTile(photo, index, size);
      },
      staggeredTileBuilder: (index) => new StaggeredTile.fit(1),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading && model.isEmpty)
      return _createLoadingWidget();
    if (isError && model.isEmpty)
      return _createErrorWidget();
    //
    if (refresh != null) {
      return RefreshIndicator(
          onRefresh: refresh,
          child: _createGalleryStaggeredWidget()
      );
    } else {
      return _createGalleryStaggeredWidget();
    }
  }

}

class _GalleryWidgetPagedState<M extends PagedPhotosModel> extends _GalleryWidgetState<M> {

  bool showNoMoreEvent = false;

  _GalleryWidgetPagedState(M model) : super(model);

  @override
  void initState() {
    super.initState();
    model.noMoreEvent.observe(observeNoMoreEvent);
  }

  @override
  void dispose() {
    model.noMoreEvent.unObserve(observeNoMoreEvent);
    super.dispose();
  }

  observeNoMoreEvent(bool value) {
    if (value ?? false) {
      showNoMoreEvent = true;
      model.consumeNoMoreEvent();
    }
  }

  @override
  _onScrolledToTheEnd() {
    if (showNoMoreEvent) {
      showNoMoreEvent = false;
      scrollController.removeListener(onScroll);
      snackbar(context, l.theEnd);
    } else {
      super._onScrolledToTheEnd();
    }
  }
}

class _GalleryWidgetPagedRefreshState<M extends NewPhotosModel> extends _GalleryWidgetPagedState<M> {

  _GalleryWidgetPagedRefreshState(M model) : super(model) {
    refresh = model.refreshPhotos;
  }

  @override
  void initState() {
    super.initState();
    model.noFreshEvent.observe(observeNoFreshEvent);
  }

  @override
  dispose() {
    model.noFreshEvent.unObserve(observeNoFreshEvent);
    super.dispose();
  }

  observeNoFreshEvent(bool value) {
    if (value ?? false) {
      snackbar(context, l.latest);
      model.consumeNoMoreEvent();
    }
  }

  @override
  observeFailureEvent(FailureInfo failure) {
    if (super.observeFailureEvent(failure))
      return true;
    if (failure.action == ModelAction.refresh) {
      actionSnackbar(context, failure.toLocalizedMessage(l), l.retry, () {
        loadByUser = true;
        refresh();
      });
    }
    return true;
  }

}
