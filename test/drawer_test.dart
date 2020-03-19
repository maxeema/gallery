
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maxeem_gallery/localizations/localization.dart';
import 'package:maxeem_gallery/misc/categories.dart';
import 'package:maxeem_gallery/ui/widgets/drawer_content_widget.dart';

final categoryEvents = StreamController<Category>();
final aboutEvent = StreamController<String>();

// $ flutter test test/drawer_test.dart
void main() {
  app() => MaterialApp(
    home: Scaffold(
      drawer: Drawer(child: DrawerContentWidget(Category.GIRLS,
          categoryEvents.add, ()=> aboutEvent..add("well done")..close()
      ))
    ),
    localizationsDelegates: [
      AppLocalizationsDelegate(),
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
    ],
    supportedLocales: AppLocalizationsDelegate.supportedLocales,
  );
  //
  testWidgets('check categories', (WidgetTester tester) async {
    await tester.pumpWidget(app());
    await tester.pump();
    final ScaffoldState scaffold = tester.firstState(find.byType(Scaffold));
    final l = AppLocalizations.of(scaffold.context);
    //ensure we don't have anything on closed Drawer
    final newFinder = find.text(categoryToLocalizedName(Category.NEW, l));
    expect(newFinder, findsNothing);
    //let's open Drawer
    scaffold.openDrawer();
    // wait for drawer animation ends
    await tester.pumpAndSettle();
    //
    for (var cat in Category.values) {
      final finder = find.text(categoryToLocalizedName(cat, l));
      expect(finder, findsOneWidget);
      await tester.tap(find.text(categoryToLocalizedName(cat, l)));
    }
    categoryEvents.close();
    assert(await categoryEvents.stream.length == Category.values.length);
  });
  testWidgets('check about', (WidgetTester tester) async {
    await tester.pumpWidget(app());
    await tester.pump();
    //ensure we don't have anything on closed Drawer
    final aboutFinder = find.text("About");
    expect(aboutFinder, findsNothing);
    ScaffoldState ss = tester.firstState(find.byType(Scaffold));
    //let's open Drawer
    ss.openDrawer();
    // wait for drawer animation ends
    await tester.pumpAndSettle();
    //
    expect(aboutFinder, findsOneWidget);
    //
    await tester.tap(aboutFinder);
    await aboutEvent.stream.first;
  });
}
