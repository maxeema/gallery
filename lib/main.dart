import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'localizations/localization.dart';
import 'misc/conf.dart' as conf;
import 'misc/injection.dart';
import 'network/api.dart' as net;
import 'repository/photos_repository.dart';
import 'repository/photos_repository_impl.dart';
import 'state.dart';
import 'ui/gallery_bottom_sheet_screen.dart';
import 'ui/gallery_slided_drawer_screen.dart';

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
    useEffect(() {
      SystemChrome.setEnabledSystemUIOverlays([]);
      return null;
    }, ["onetime"]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final mq = MediaQuery.of(context);
          // print('mq size: ${mq.size}');
          if (mq.size.height > 900 && mq.size.width > 900) {
            // iPad
            return GalleryBottomSheetScreen();
          }
          return GallerySlidedDrawerScreen();
        },
      ),
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
