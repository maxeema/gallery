
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maxeem_gallery/localizations/localization.dart';
import 'package:maxeem_gallery/misc/categories.dart';
import 'package:maxeem_gallery/misc/conf.dart';
import 'package:maxeem_gallery/ui/ui.dart';

class DrawerContentWidget extends StatelessWidget {

  final Category category;

  final Function(Category) _onSelectCategory;
  final Function _onShowAbout;

  DrawerContentWidget(this.category, [this._onSelectCategory, this._onShowAbout]);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context);
    return ListView(
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
        ...Category.values.map((Category cat) => ListTile(
            key: Key("category-${categoryToName(cat)}"),
            title: Text(
              categoryToLocalizedName(cat, l),
              style: TextStyle(
                  fontWeight: cat == category ? FontWeight.w700 : FontWeight.normal,
                  color: cat == category ? appAccentColor : Colors.black
              ),
            ),
            selected: cat == category,
            leading: SizedBox(width: 64),
            onTap: ()=> _onSelectCategory?.call(cat)
          )
        ),
        // about
        SizedBox(height: 8,),
        Divider(height: 2,),
        SizedBox(height: 8,),
        ListTile(
          key: Key("about"),
          onTap: ()=> _onShowAbout?.call(),
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
    );
  }
}