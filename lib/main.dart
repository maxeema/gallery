
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'gallery_screen.dart';
import 'localization.dart';

///
/// App entry point
///

main() => runApp(App());

class App extends StatelessWidget {

  @override
  Widget build(BuildContext context) =>
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GalleryScreen(),
      //localization
      onGenerateTitle: (BuildContext context) => AppLocalizations.of(context).title,
      localizationsDelegates: [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [ Locale('en'),],
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Colors.blue.shade700,
        backgroundColor: Colors.blue.shade300,
        accentColor: Colors.blue,
      ),
    );

}
