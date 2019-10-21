
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:package_info/package_info.dart';

import 'package:unsplash_gallery/util.dart';
import 'package:unsplash_gallery/conf.dart' as conf;

showAbout(BuildContext context) =>
    PackageInfo.fromPlatform().then((PackageInfo info) {
      showAboutDialog(context: context,
          applicationIcon: SvgPicture.asset( conf.appIcon, width: 48 ),
          applicationName: info.appName,
          applicationVersion: info.version,
          applicationLegalese: conf.appLegalese,
          children: [
            RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    style: Theme.of(context).textTheme.body1,
                    children: [
                      TextSpan(text:'\nApp '),
                      TextSpan(
                          text:'GitHub',
                          style: TextStyle(color: Theme.of(context).accentColor),
                          recognizer: TapGestureRecognizer()..onTap =
                              () => launchUrl(conf.appGitHubPage)
                      ),
                      TextSpan(text:' page')
                    ]
                )
            ),
            Container(
                margin: EdgeInsets.only(top:16),
                alignment: Alignment.center,
                child: OutlineButton(
                  textTheme: ButtonTextTheme.primary,
                  child: Text('See on Google Play',),
                  onPressed: () {
                    launchUrl('https://play.google.com/store/apps/details?id=${info.packageName}');
                  },
                )
            )
          ]
      );
    });