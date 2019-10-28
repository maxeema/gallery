
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:maxeem_gallery/misc/conf.dart' as conf;
import 'package:maxeem_gallery/localizations/localization.dart';
import 'package:maxeem_gallery/misc/util.dart';
import 'package:package_info/package_info.dart';

showAbout(BuildContext context) {

  final localizations = AppLocalizations.of(context);

  PackageInfo.fromPlatform().then((PackageInfo info) {
    showAboutDialog(context: context,
        applicationIcon: FlutterLogo(
          size: 48, colors: Colors.indigo,
        ),
        applicationName: info.appName,
        applicationVersion: info.version,
        applicationLegalese: conf.appLegalese,
        children: [
          SizedBox(height: 8,),
          RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                  style: Theme.of(context).textTheme.body1,
                  children: _spanzize(
                      localizations.appGitHub, 'GitHub',
                      (nonMatched) => TextSpan(text: nonMatched),
                      (matched) => TextSpan(
                        text: matched,
                        style: TextStyle(color: Theme.of(context).accentColor),
                        recognizer: TapGestureRecognizer()..onTap = () => launchUrl(conf.appGitHubPage)
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
                  launchUrl('https://play.google.com/store/apps/details?id=${info.packageName}');
                },
              )
          ),
          RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: Theme.of(context).textTheme.body1,
                children: _spanzize(
                    localizations.appCredits, 'Unsplash',
                        (nonMatched) => TextSpan(text: nonMatched),
                        (matched) => TextSpan(
                        text: matched,
                        style: TextStyle(color: Theme.of(context).accentColor),
                        recognizer: TapGestureRecognizer()..onTap = () => launchUrl('https://unsplash.com')
                    )
                ),
              )
          ),
        ]
    );
  });
}

List<TextSpan>
_spanzize(String text, String pattern,
                      TextSpan nonMatchBuild(nonMatched),
                      TextSpan matchBuild(matched)) {

  final idx = text.indexOf(pattern);
  final String before = idx > 0 ? text.substring(0, idx) : null;
  final String after = idx + pattern.length < text.length  ? text.substring(idx + pattern.length) : null;

  return <TextSpan>[
    if (before?.isNotEmpty ?? false)
      nonMatchBuild(before),
    matchBuild(pattern),
    if (after?.isNotEmpty ?? false)
      nonMatchBuild(after),
  ];

}
