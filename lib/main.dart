
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'localizations/localization.dart';
import 'misc/conf.dart' as conf;
import 'misc/injection.dart';
import 'network/api.dart' as net;
import 'repository/photos_repository.dart';
import 'repository/photos_repository_impl.dart';
import 'state.dart';
import 'ui/gallery_screen.dart';

main() {
  // register dependencies
  injector.single<net.Network>(() => net.NetworkImpl(conf.apiBaseUrl, conf.apiTokens));
  injector.single<PhotosRepository>(() => PhotosRepositoryImpl());
  injector.single<AppState>(() => AppState());
  // and go
  runApp(App());
}

class App extends HookWidget {

  @override
  Widget build(BuildContext context) {
//    useEffect(() {
//      UiOverlayStyle.darkStatusBarIcons.apply();
//      return null;
//    }, ["onetime"]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GalleryScreen(),
      //
      onGenerateTitle: (BuildContext context) => AppLocalizations.of(context).appTitle,
      //
      localizationsDelegates: [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: AppLocalizationsDelegate.supportedLocales,
      //
      theme: ThemeData(
        backgroundColor: Colors.white,
        primarySwatch: conf.appColor,
        accentColor: conf.appAccentColor,
      ),
    );
  }

}
