import 'package:flutter/foundation.dart' hide Category;
import 'package:flutter/material.dart';
import 'package:gallery/localizations/localization.dart';
import 'package:gallery/misc/categories.dart';
import 'package:gallery/misc/injection.dart';
import 'package:gallery/state.dart';
import 'package:gallery/ui/about_dialog.dart' as about;

import 'widgets/categories_list_widget.dart';
import 'widgets/gallery_widget.dart';

class GallerySlidedDrawerScreen extends StatefulWidget {
  const GallerySlidedDrawerScreen({Key key}) : super(key: key);

  @override
  State createState() => _GallerySlidedDrawerScreenState();
}

class _GallerySlidedDrawerScreenState extends State<GallerySlidedDrawerScreen> with LocalizableState, Injectable {
  AppState get appState => inject();

  LabeledGlobalKey<ScaffoldState> scaffoldKey;

  ScaffoldState get scaffoldState => scaffoldKey?.currentState;

  @override
  initState() {
    super.initState();
    appState.category.addListener(_closeDrawer);
  }

  @override
  dispose() {
    appState.category.removeListener(_closeDrawer);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey ??= LabeledGlobalKey<ScaffoldState>("gallery_scaffold"),
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).backgroundColor,
      drawer: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: 800),
        child: Drawer(
            key: Key("gallery_drawer"),
            child: CategoriesListWidget(onSelectAbout: () {
              _closeDrawer();
              about.showAbout(scaffoldState.context);
            })),
      ),
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
          if (!scaffoldState.isDrawerOpen)
            scaffoldState.openDrawer();
          else
            _closeDrawer();
        },
      ),
    );
  }

  _closeDrawer() {
    if (scaffoldState.isDrawerOpen) Navigator.pop(scaffoldState.context);
  }
}
