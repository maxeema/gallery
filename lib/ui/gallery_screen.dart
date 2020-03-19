
import 'package:flutter/material.dart';
import 'package:maxeem_gallery/localizations/localization.dart';
import 'package:maxeem_gallery/misc/categories.dart';
import 'package:maxeem_gallery/misc/prefs.dart' as prefs;
import 'package:maxeem_gallery/ui/about_dialog.dart' as about;

import 'widgets/drawer_content_widget.dart';
import 'widgets/gallery_widget.dart';

class GalleryScreen extends StatefulWidget {

  @override
  _GalleryScreenState createState() => _GalleryScreenState();

}

class _GalleryScreenState extends State<GalleryScreen> with LocalizableState {

  Category category;

  bool get isInitializing => category == null;

  @override
  void initState() {
    super.initState();
    prefs.loadCategory().then(_onLoadConfig, onError: (error)=> _onLoadConfig(null));
  }

  _onLoadConfig(String name) {
    setState(() {
      this.category = name == null ? Category.NEW : nameToCategory(name);
    });
  }

  _selectCategory(Category cat) async {
    _closeDrawer();

    prefs.saveCategory(cat);

    if (cat != category) {
      setState(() {
        category = cat;
      });
    }
  }

  _showAbout() {
    _closeDrawer();
    about.showAbout(_scaffoldCtx);
  }

  @override
  Widget build(BuildContext context) {
    if (isInitializing)
      return Container(color: Theme.of(context).backgroundColor);
    return _createBody();
  }

  BuildContext _scaffoldCtx;

  _createBody() {
    return Scaffold(
      key: Key("gallery_scaffold"),
      backgroundColor: Theme.of(context).backgroundColor,
      drawer: Drawer(
        key: Key("gallery_drawer"),
        child: DrawerContentWidget(category, _selectCategory, _showAbout)
      ),
      body: Builder(
        builder: (BuildContext ctx) {
          _scaffoldCtx = ctx;
          return GalleryWidget(category, key: ValueKey(category));
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        key: Key("gallery_menu_btn"),
        child: Icon(Icons.dehaze),
        onPressed: () {
          final s = Scaffold.of(_scaffoldCtx);
          if (!s.isDrawerOpen)
            Scaffold.of(_scaffoldCtx).openDrawer();
          else _closeDrawer();
        },
      ),
    );
  }

  _closeDrawer() {
    if (Scaffold.of(_scaffoldCtx).isDrawerOpen)
      Navigator.pop(_scaffoldCtx);
  }

}
