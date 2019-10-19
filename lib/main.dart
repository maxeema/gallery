
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'gallery_screen.dart';
import 'injection.dart';
import 'localization.dart';
import 'network.dart' as net;

///
/// App entry point
///
main() {
  // register dependencies
  injector.registerSingle<net.Api>(() => net.FakeApi('aa'));
  // and go
  runApp(App());
}

class App extends StatelessWidget {

  @override
  Widget build(BuildContext context) =>
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          body: GalleryScreen()
      ),
      //
      onGenerateTitle: (BuildContext context) =>
        AppLocalizations.of(context).title,
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
