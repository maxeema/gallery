
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:maxeem_gallery/localizations/localization.dart';
import 'package:maxeem_gallery/misc/categories.dart';
import 'package:maxeem_gallery/misc/conf.dart';
import 'package:maxeem_gallery/state.dart';
import 'package:maxeem_gallery/ui/ui.dart';

import '../../misc/injection.dart';
import 'package:maxeem_gallery/misc/util.dart' as util;

class DrawerContentWidget extends StatelessWidget with Injectable {

  AppState get appState => inject();
  Category get category => appState.category.value;

  final Function onSelectAbout;

  DrawerContentWidget({this.onSelectAbout});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context);
    return Container(
      color: Colors.indigo.shade100,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          // header
          DrawerHeader(
            margin: EdgeInsets.zero,
            decoration: BoxDecoration(
              color: Colors.indigo,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Flexible(
                  flex: 4,
                  child: CircleAvatar(
                    backgroundImage: AssetImage("assets/Maxeem.png"),
                    maxRadius: 40,
                  ),
                ),
                SizedBox(
                  width: 16,
                ),
                Expanded(
                  flex: 4,
                  child: RichText(
                    textAlign: TextAlign.center,
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
                          TextSpan(text: '\n'),
                          TextSpan(
                            text: l.drawerTitle,
                          ),
                          TextSpan(text: '\n'),
                          TextSpan(
                            style: Theme.of(context).textTheme.bodyText2,
                            children: util.spanzize(
                                "by Unsplash", 'Unsplash',
                                    (nonMatched) => TextSpan(text: nonMatched),
                                    (matched) => TextSpan(
                                    text: matched,
                                    style: TextStyle(color: Colors.white),
                                    recognizer: TapGestureRecognizer()..onTap
                                        = () => util.launchUrl('https://unsplash.com')
                                )
                            ),
                          )
                        ]
                    ),
                  ),
                ),
              ],
            ),
          ),
          ...Category.values.map((Category cat) => Material(
            color: Colors.white,
            child: ListTile(
                key: Key("category-${cat.name}"),
                title: Text(
                  cat.toLocalizedName(l),
                  style: TextStyle(
                      fontWeight: cat == category ? FontWeight.w700 : FontWeight.normal,
                      color: cat == category ? appAccentColor : Colors.black
                  ),
                ),
                selected: cat == category,
                leading: SizedBox(width: 64),
                onTap: () {
                  appState.category.value = cat;
                }
              ),
          )
          ),
          // about
          Divider(height: 1,),
          Material(
            color: Colors.white,
            child: ListTile(
              key: Key("about"),
              onTap: ()=> onSelectAbout?.call(),
              title: Text(
                l.about,
                style: theme.textTheme.caption.apply(
                  color: Colors.grey.shade600,
                ),
              ),
              leading: SizedBox(width: 64,),
            ),
          ),
          SizedBox(height: 8,),
        ],
      ),
    );
  }
}