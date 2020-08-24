
import 'package:flutter/material.dart';
import 'package:gallery/localizations/localization.dart';
import 'package:gallery/misc/categories.dart';
import 'package:gallery/misc/injection.dart';
import 'package:gallery/state.dart';
import 'package:gallery/ui/about_dialog.dart' as about;

import 'widgets/drawer_content_widget.dart';
import 'widgets/gallery_widget.dart';

const _landModeThreshold = 900.0;
const _categoriesWidthInLand = 260.0;

class GalleryScreen extends StatefulWidget {

  @override
  _GalleryScreenState createState() => _GalleryScreenState();

}

class _GalleryScreenState extends State<GalleryScreen> with LocalizableState, Injectable {

  AppState get appState => inject();

  LabeledGlobalKey<ScaffoldState> scaffoldKey;
  ScaffoldState get scaffoldState => scaffoldKey?.currentState;

  @override initState() {
    super.initState();
    appState.category.addListener(_closeDrawer);
  }
  @override dispose() {
    appState.category.removeListener(_closeDrawer);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLandWithCategories =
        MediaQuery.of(context).size.width > _landModeThreshold;
    return Scaffold(
      key: scaffoldKey ??= LabeledGlobalKey<ScaffoldState>("gallery_scaffold"),
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).backgroundColor,
      drawer: isLandWithCategories ? null : Drawer(
        key: Key("gallery_drawer"),
        child: DrawerContentWidget(onSelectAbout: () {
          _closeDrawer();
          about.showAbout(scaffoldState.context);
        })
      ),
      body: ValueListenableBuilder<Category>(
        valueListenable: appState.category,
        builder: (ctx, category, child) {
          if (category == null)
              return Container(color: Theme.of(context).backgroundColor);
          if (isLandWithCategories) {
            return Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints.tightFor(width: _categoriesWidthInLand),
                  child: DrawerContentWidget(onSelectAbout: () {
                    _closeDrawer();
                    about.showAbout(scaffoldState.context);
                  }),
                ),
                Expanded(
                  child: GalleryWidget(category, key: ValueKey(category))
                ),
              ],
            );
          } else {
            return GalleryWidget(category, key: ValueKey(category));
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: isLandWithCategories ? null : FloatingActionButton(
        key: Key("gallery_menu_btn"),
        child: Icon(Icons.dehaze),
        onPressed: () {
          if (!scaffoldState.isDrawerOpen)
            scaffoldState.openDrawer();
          else _closeDrawer();
        },
      ),
    );
  }

  _closeDrawer() {
    if (scaffoldState.isDrawerOpen)
      Navigator.pop(scaffoldState.context);
  }

}
