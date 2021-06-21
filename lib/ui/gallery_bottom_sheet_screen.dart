import 'package:flutter/foundation.dart' hide Category;
import 'package:flutter/material.dart';
import 'package:gallery/localizations/localization.dart';
import 'package:gallery/misc/categories.dart';
import 'package:gallery/misc/injection.dart';
import 'package:gallery/state.dart';
import 'package:gallery/ui/about_dialog.dart' as about;
import 'package:gallery/ui/widgets/categories_grid_widget.dart';

import 'widgets/gallery_widget.dart';

class GalleryBottomSheetScreen extends StatefulWidget {
  const GalleryBottomSheetScreen({Key key}) : super(key: key);

  @override
  State createState() => _GalleryBottomSheetScreenState();
}

class _GalleryBottomSheetScreenState extends State<GalleryBottomSheetScreen> with LocalizableState, Injectable {
  AppState get appState => inject();

  LabeledGlobalKey<ScaffoldState> scaffoldKey;

  ScaffoldState get scaffoldState => scaffoldKey?.currentState;

  Future modalFuture;

  @override
  initState() {
    super.initState();
    appState.category.addListener(_dismissBottomSheet);
  }

  // @override
  // dispose() {
  //   appState.category.removeListener(_closeDrawer);
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey ??= LabeledGlobalKey<ScaffoldState>("gallery_scaffold"),
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).backgroundColor,
      body: ValueListenableBuilder<Category>(
        valueListenable: appState.category,
        builder: (ctx, category, child) {
          if (category == null) return Container(color: Theme.of(context).backgroundColor);
          //
          return GalleryWidget(category, key: ValueKey(category));
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        key: Key("gallery_menu_btn"),
        child: Icon(Icons.dehaze),
        onPressed: () {
          if (!scaffoldState.isDrawerOpen) {
            modalFuture = showModalBottomSheet(
                context: context,
                enableDrag: true,
                builder: (context) => BottomSheet(
                      onClosing: () {
                        modalFuture = null;
                      },
                      builder: (context) {
                        return CategoriesGridWidget(onSelectAbout: () {
                          about.showAbout(scaffoldState.context);
                          _dismissBottomSheet();
                        });
                      },
                    ));
          }
        },
      ),
    );
  }

  void _dismissBottomSheet() {
    if (modalFuture != null) Navigator.pop(context);
  }
}
