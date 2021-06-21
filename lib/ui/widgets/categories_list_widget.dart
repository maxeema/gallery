import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:gallery/localizations/localization.dart';
import 'package:gallery/misc/categories.dart';
import 'package:gallery/misc/conf.dart';
import 'package:gallery/state.dart';
import 'package:gallery/ui/ui.dart';

import '../../misc/injection.dart';

class CategoriesListWidget extends StatelessWidget with Injectable {
  AppState get appState => inject();

  Category get category => appState.category.value;

  final Function onSelectAbout;

  const CategoriesListWidget({@required this.onSelectAbout});

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context);
    return Container(
      color: Colors.grey.shade100,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          DrawerHeader(
            margin: EdgeInsets.zero,
            decoration: BoxDecoration(
//              color: Colors.transparent,
              color: Colors.grey.shade300,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Flexible(
                  flex: 4,
                  child: CircleAvatar(
                    backgroundImage: AssetImage("assets/icon.png"),
                    maxRadius: 44,
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
                          TextSpan(
                              text: l.drawerTitle, style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
                          // TextSpan(text: '\n'),
                          // TextSpan(
                          //   style: Theme.of(context).textTheme.bodyText2.copyWith(
                          //       color: Colors.black54
                          //   ),
                          //   children: util.spanzize(
                          //       "by Unsplash", 'Unsplash',
                          //           (nonMatched) => TextSpan(text: nonMatched),
                          //           (matched) => TextSpan(
                          //           text: matched,
                          //           style: TextStyle(
                          //               color: Colors.pinkAccent,
                          //               fontWeight: FontWeight.w500
                          //           ),
                          //           recognizer: TapGestureRecognizer()..onTap
                          //           = () => util.launchUrl('https://unsplash.com')
                          //       )
                          //   ),
                          // )
                        ]),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 0.5,
          ),
          Expanded(
            child: Center(
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                children: <Widget>[
                  ...Category.values.map((Category cat) => Material(
                        color: Colors.grey.shade100,
                        child: ListTile(
                            key: Key("category-${cat.name}"),
                            title: Text(
                              cat.toLocalizedName(l),
                              style: TextStyle(
                                  fontWeight: cat == category ? FontWeight.w700 : FontWeight.normal,
                                  color: cat == category ? appAccentColor : Colors.black),
                            ),
                            selected: cat == category,
                            leading: SizedBox(width: 64),
                            onTap: () {
                              appState.category.value = cat;
                            }),
                      )),
                  if (media.orientation == Orientation.landscape) about(l, theme),
                  SizedBox(
                    height: 8,
                  )
                ],
              ),
            ),
          ),
          if (media.orientation == Orientation.portrait) about(l, theme),
        ],
      ),
    );
  }

  about(l, theme) => Material(
        color: Colors.transparent,
        child: ListTile(
          key: Key("about"),
          onTap: () => onSelectAbout?.call(),
          title: Text(
            l.about,
            style: theme.textTheme.caption.apply(
              color: Colors.grey.shade600,
            ),
          ),
          leading: SizedBox(
            width: 64,
          ),
        ),
      );
}
