
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maxeem_gallery/localizations/localization.dart';
import 'package:maxeem_gallery/misc/categories.dart';
import 'package:maxeem_gallery/ui/widgets/drawer_content_widget.dart';

onCategoryTap(cat) => print("category selected: $cat");
onAboutTap() => aboutEvent..add("well done")..close();

final aboutEvent = StreamController();

void main() {
  app() => MaterialApp(
    home: Scaffold(
      drawer: Drawer(child: DrawerContentWidget(Category.GIRLS, onCategoryTap, onAboutTap))
    ),
    localizationsDelegates: [
      AppLocalizationsDelegate(),
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
    ],
    supportedLocales: AppLocalizationsDelegate.supportedLocales,
  );
  //
  testWidgets('check Drawer categories', (WidgetTester tester) async {
    await tester.pumpWidget(app());
    await tester.pump();
    final ScaffoldState scaffold = tester.firstState(find.byType(Scaffold));
    final l = AppLocalizations.of(scaffold.context);
    //ensure we don't have anything on closed Drawer
    final missFinder = find.text(categoryToLocalizedName(Category.NEW, l));
    expect(missFinder, findsNothing);
    //ensure we see Categories on opened Drawer
    scaffold.openDrawer();
    // wait for drawer animation ends
    await tester.pumpAndSettle();
    //
    Category.values.forEach((cat) async {
      final finder = find.text(categoryToLocalizedName(cat, l));
      expect(finder, findsOneWidget);
    });
    //ensure we see About
  });
  testWidgets('check Drawer about', (WidgetTester tester) async {
    await tester.pumpWidget(app());
    await tester.pump();
    //ensure we don't have anything on closed Drawer
    final missFinder = find.text("About");
    expect(missFinder, findsNothing);
    //ensure we see Categories on opened Drawer
    ScaffoldState ss = tester.firstState(find.byType(Scaffold));
    ss.openDrawer();
    // wait for drawer animation ends
    await tester.pumpAndSettle();
    //
    final aboutFinder = find.text("About");
    expect(aboutFinder, findsOneWidget);
    //
    await tester.tap(aboutFinder);
    await aboutEvent.stream.first;
  });
}