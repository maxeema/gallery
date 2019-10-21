
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'conf.dart' as conf;
import 'gallery_screen.dart';
import 'injection.dart';
import 'localization.dart';
import 'net/api.dart' as net;

///
/// App entry point
///

main() {
  // register dependencies
//  injector.registerSingle<net.Api>(() => net.FakeApi(delay: 1000, photosPerPage: 30, errorPossibility: 10));
  injector.registerSingle<net.Api>(() => net.RealApi(conf.apiBaseUrl, conf.apiTokens, conf.apiPhotosPerPage));
  // and go
  runApp(App());
}

class App extends StatelessWidget {

  @override
  Widget build(BuildContext context) =>
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GalleryScreen(),
      //
      onGenerateTitle: (BuildContext context) => AppLocalizations.of(context).title,
      //
      localizationsDelegates: [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [ Locale('en'),],
      //
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
    );

}
