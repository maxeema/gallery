// Imports the Flutter Driver API.
import 'dart:math';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:maxeem_gallery/misc/ext.dart';
import 'package:test/test.dart';

void main() {
  group('App', () {
    FlutterDriver driver;

    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
        driver?.close();
    });

    final scaffoldFinder = find.byValueKey('gallery_scaffold');
    final gridFinder = find.byValueKey('gallery_grid');
    final drawerFinder = find.byValueKey('gallery_drawer');
    final menuBtnFinder = find.byValueKey('gallery_menu_btn');
    final aboutItemFinder = find.byValueKey('about');
    final girlsItemFinder = find.byValueKey('category-girls');

    test('wait for loading', () async {
      await driver.waitFor(scaffoldFinder);
      await driver.waitFor(gridFinder);
      await Future.delayed(3.sec);
    });
    test('invoke refresh', () async {
      await driver.scroll(gridFinder, 0, 400, Duration(milliseconds: 300));
      await Future.delayed(3.sec);
    });
//    test('show About', () async {
//      await driver.tap(menuBtnFinder);
//      await driver.waitFor(drawerFinder);
//      await Future.delayed(1.sec);
//      await driver.waitFor(aboutItemFinder);
//      await driver.tap(aboutItemFinder);
//      await Future.delayed(2.sec);
//      await driver.tap(find.text("CLOSE"));
//      await Future.delayed(1.sec);
//    });
    test('switch to Girls', () async {
      await driver.tap(menuBtnFinder);
      await driver.waitFor(drawerFinder);
      await Future.delayed(1.sec);
      await driver.waitFor(girlsItemFinder);
      await driver.tap(girlsItemFinder);
      await Future.delayed(2.sec);
      await driver.waitFor(gridFinder);
      await Future.delayed(1.sec);
    });
    test('scroll list up and down', () async {
      await driver.scroll(gridFinder, 0, -2000, Duration(milliseconds: 300));
      await Future.delayed(1.sec);
      await driver.scroll(gridFinder, 0, 2000, Duration(milliseconds: 300));
      await Future.delayed(1.sec);
    });
    //
    final photoFinder = find.byValueKey("photo${Random().nextInt(10)}");
    test('open image fullscreen', () async {
      await driver.waitFor(photoFinder);
      await driver.scrollUntilVisible(gridFinder, photoFinder);
      await Future.delayed(1.sec);
      await driver.tap(photoFinder);
      await driver.waitFor(find.byValueKey("photo_scaffold"));
      await Future.delayed(3.sec);
      await driver.tap(find.byValueKey("back_btn"));
      await driver.waitFor(photoFinder);
      await Future.delayed(3.sec);
    });
  });
}
