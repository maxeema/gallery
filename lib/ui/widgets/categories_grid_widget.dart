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

class CategoriesGridWidget extends StatelessWidget with Injectable {
  AppState get appState => inject();

  Category get category => appState.category.value;

  final Function onSelectAbout;

  const CategoriesGridWidget({@required this.onSelectAbout});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context);
    return Container(
      height: 500,
      color: Colors.grey.shade100,
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
                ConstrainedBox(constraints: BoxConstraints.tightFor(width: 200), child: Container()),
                Spacer(),
                CircleAvatar(
                  backgroundImage: AssetImage("assets/icon.png"),
                  maxRadius: 44,
                ),
                SizedBox(
                  width: 16,
                ),
                RichText(
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.fade,
                  text: TextSpan(children: [
                    TextSpan(
                        text: l.drawerTitle.replaceAll('\n', ' '),
                        style: theme.textTheme.headline4
                            .copyWith(fontFamily: fontJuliusSansOne, color: Colors.black, fontWeight: FontWeight.w500)),
                  ]),
                ),
                Spacer(),
                ConstrainedBox(constraints: BoxConstraints.tightFor(width: 200), child: about(l, theme))
              ],
            ),
          ),
          Divider(
            height: 0.5,
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: Category.values
                      .sublist(0, 4)
                      .map((Category cat) => Expanded(
                            child: Material(
                              color: Colors.grey.shade100,
                              child: ListTile(
                                  key: Key("category-${cat.name}"),
                                  title: Container(
                                    alignment: Alignment.center,
                                    height: 100,
                                    child: Text(
                                      cat.toLocalizedName(l),
                                      softWrap: false,
                                      textAlign: TextAlign.center,
                                      style: theme.textTheme.headline5.copyWith(
                                          fontWeight: cat == category ? FontWeight.w700 : FontWeight.normal,
                                          color: cat == category ? appAccentColor : Colors.black),
                                    ),
                                  ),
                                  selected: cat == category,
                                  onTap: () {
                                    appState.category.value = cat;
                                  }),
                            ),
                          ))
                      .toList(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(),
                    ...Category.values
                        .sublist(4)
                        .map((Category cat) => Expanded(
                              child: Material(
                                color: Colors.grey.shade100,
                                child: ListTile(
                                    key: Key("category-${cat.name}"),
                                    title: Container(
                                      alignment: Alignment.center,
                                      height: 100,
                                      child: Text(
                                        cat.toLocalizedName(l),
                                        softWrap: false,
                                        textAlign: TextAlign.center,
                                        style: theme.textTheme.headline5.copyWith(
                                            fontWeight: cat == category ? FontWeight.w700 : FontWeight.normal,
                                            color: cat == category ? appAccentColor : Colors.black),
                                      ),
                                    ),
                                    selected: cat == category,
                                    onTap: () {
                                      appState.category.value = cat;
                                    }),
                              ),
                            ))
                        .toList(),
                    Container(),
                  ],
                )
              ],
            ),
          ),
          Divider(
            height: 1,
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Text(
              appLegalese,
              style: theme.textTheme.headline6.copyWith(
                  // fontSize: 18,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  about(l, ThemeData theme) => Material(
        color: Colors.transparent,
        child: ListTile(
          key: Key("about"),
          onTap: () => onSelectAbout?.call(),
          title: Center(
            child: Text(
              l.about,
              textAlign: TextAlign.center,
              style: theme.textTheme.headline5.apply(
                color: Colors.grey.shade500,
              ),
            ),
          ),
        ),
      );
}
