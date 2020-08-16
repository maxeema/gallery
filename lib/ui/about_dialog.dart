
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:maxeem_gallery/localizations/localization.dart';
import 'package:maxeem_gallery/misc/conf.dart' as conf;
import 'package:maxeem_gallery/misc/util.dart' as util;
import 'package:package_info/package_info.dart';

showAbout(BuildContext context) async {

  final localizations = AppLocalizations.of(context);
  final platform = Theme.of(context).platform;

  //
  String appName;
  String appVersion;

  PackageInfo packageInfo;
  try {
    packageInfo = await PackageInfo.fromPlatform();
    appName = packageInfo.appName;
    appVersion = packageInfo.version;
  } catch (e) {
    appName = localizations.appTitle;
    appVersion = kIsWeb ? "Web" : () {
      var name = platform.toString();
      name = name.substring(platform.toString().lastIndexOf(".")+1);
      return name.substring(0, 1).toUpperCase() + name.substring(1);
    }();
  }

  showAboutDialog(context: context,
    applicationIcon: FlutterLogo(size: 48, colors: Colors.indigo,),
    applicationName: appName,
    applicationVersion: appVersion,
    applicationLegalese: conf.appLegalese,
    children: [
      SizedBox(height: 8,),
      RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
              style: Theme.of(context).textTheme.bodyText2,
              children: util.spanzize(
                  localizations.appGitHub, 'GitHub',
                  (nonMatched) => TextSpan(text: nonMatched),
                  (matched) => TextSpan(
                    text: matched,
                    style: TextStyle(color: Theme.of(context).accentColor),
                    recognizer: TapGestureRecognizer()..onTap = () => util.launchUrl(conf.appGitHubPage)
                  )
              ),
          )
      ),
      Container(
          margin: EdgeInsets.symmetric(vertical: 8),
          alignment: Alignment.center,
          child: OutlineButton(
            textTheme: ButtonTextTheme.primary,
            child: Text(localizations.seeOnPlay),
            onPressed: () {
              util.launchUrl(conf.appPlayStoreUrl.replaceAll("%package%", packageInfo.packageName));
            },
          )
      ),
      RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: Theme.of(context).textTheme.bodyText2,
            children: util.spanzize(
                localizations.appCredits, 'Unsplash',
                    (nonMatched) => TextSpan(text: nonMatched),
                    (matched) => TextSpan(
                    text: matched,
                    style: TextStyle(color: Theme.of(context).accentColor),
                    recognizer: TapGestureRecognizer()..onTap = () => util.launchUrl('https://unsplash.com')
                )
            ),
          )
      ),
    ]
  );
}
