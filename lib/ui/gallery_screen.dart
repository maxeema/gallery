
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:maxeem_gallery/localizations/localization.dart';
import 'package:maxeem_gallery/misc/categories.dart';
import 'package:maxeem_gallery/misc/conf.dart';
import 'package:maxeem_gallery/misc/prefs.dart' as prefs;
import 'package:maxeem_gallery/ui/about_dialog.dart' as about;
import 'package:maxeem_gallery/ui/ui.dart';

import 'gallery_widget.dart';

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
      backgroundColor: Theme.of(context).backgroundColor,
      drawer: _createDrawer(),
      body: Builder(
        builder: (BuildContext ctx) {
          _scaffoldCtx = ctx;
          return GalleryWidget(category, key: ValueKey(category));
        },
      ),
    );
  }

  _createDrawer() {
    final theme = Theme.of(context);
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          // header
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.indigo,
            ),
            child: Row(
              children: <Widget>[
                FlutterLogo(
                  size: 64,
                  colors: Colors.indigo,
                ),
                SizedBox(width: 16,),
                Expanded(
                  child: RichText(
                    overflow: TextOverflow.fade,
                    text: TextSpan(
                      style: TextStyle(
                        fontFamily: fontJuliusSansOne,
                        color: Colors.white,
                        fontSize: 24,
                      ),
                      children: [
                        TextSpan(text: AppLocalizations.maxeem,
                          style: TextStyle(
                            fontWeight: FontWeight.bold
                          )
                        ),
                        TextSpan(
                          text: '\n'
                        ),
                        TextSpan(
                          text: l.drawerTitle,
                        )
                      ]
                    ),
                  ),
                ),
              ],
            ),
          ),
          ...Category.values.map((cat)
              => ListTile(
                  title: Text(
                      categoryToLocalizedName(cat, l),
                      style: TextStyle(
                        fontWeight: cat == category ? FontWeight.w700 : FontWeight.normal,
                        color: cat == category ? appAccentColor : Colors.black
                      ),
                    ),
                    selected: cat == category,
                    leading: SizedBox(width: 64),
                    onTap: ()=> _selectCategory(cat)
              )
          ),
          // about
          SizedBox(height: 8,),
          Divider(height: 2,),
          SizedBox(height: 8,),
          ListTile(
            onTap: _showAbout,
            title: Text(
              l.about,
              style: theme.textTheme.caption.apply(
                color: Colors.grey.shade600,
              ),
            ),
            leading: SizedBox(width: 64,),
          ),
          SizedBox(height: 8,),
        ],
      ),
    );
  }

  _closeDrawer() {
    if (Scaffold.of(_scaffoldCtx).isDrawerOpen)
      Navigator.pop(_scaffoldCtx);
  }

}
