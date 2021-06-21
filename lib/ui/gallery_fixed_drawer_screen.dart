import 'package:flutter/foundation.dart' hide Category;
import 'package:flutter/material.dart';
import 'package:gallery/localizations/localization.dart';
import 'package:gallery/misc/categories.dart';
import 'package:gallery/misc/injection.dart';
import 'package:gallery/state.dart';
import 'package:gallery/ui/about_dialog.dart' as about;

import 'widgets/categories_list_widget.dart';
import 'widgets/gallery_widget.dart';

const _categoriesWidth = 260.0;

class GalleryFixedMenuScreen extends StatefulWidget {
  const GalleryFixedMenuScreen({Key key}) : super(key: key);

  @override
  State createState() => _GalleryFixedMenuScreenState();
}

class _GalleryFixedMenuScreenState extends State<GalleryFixedMenuScreen> with LocalizableState, Injectable {
  AppState get appState => inject();

  LabeledGlobalKey<ScaffoldState> scaffoldKey;

  ScaffoldState get scaffoldState => scaffoldKey?.currentState;

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
          return Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints.tightFor(width: _categoriesWidth),
                child: CategoriesListWidget(onSelectAbout: () {
                  about.showAbout(scaffoldState.context);
                }),
              ),
              Expanded(child: GalleryWidget(category, key: ValueKey(category))),
            ],
          );
        },
      ),
    );
  }
}
