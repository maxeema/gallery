
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum UiOverlayStyle {
  lightStatusBarIcons, // for screens with light status bar icons and dark bg
  darkStatusBarIcons, // for screens with dark status bar icons and light bg
  darkStatusBarIconsWithTransparentBar,
}

extension UiOverlayStyleExt on UiOverlayStyle {
  apply() {
    switch(this) {
      case UiOverlayStyle.lightStatusBarIcons:
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
        break;
      case UiOverlayStyle.darkStatusBarIcons:
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
        break;
      case UiOverlayStyle.darkStatusBarIconsWithTransparentBar:
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
          statusBarColor: Colors.transparent,
        ));
        break;
    }
  }
}