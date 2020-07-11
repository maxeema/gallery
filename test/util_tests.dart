import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:maxeem_gallery/misc/util.dart' as util;
import 'package:mockito/mockito.dart';

class MockWindow extends Mock implements Window {}

const _avatar_base_url = "https://images.unsplash.com/placeholder-avatars/extra-large.jpg";
const _photo_base_url = "https://xxx.com/get/photo?id=1";

void main() {
  var win = MockWindow();
  //
  testPhotoUrls(win);
  testAvatarUrls(win);
  //
  testStringEmptiness();
}

testPhotoUrls(Window win) {
  test("Photo urls", () {
    when(win.devicePixelRatio).thenReturn(2.5);
    expect(util.preparePhotoUrl(win, Size(600, 1200), _photo_base_url), "$_photo_base_url&w=600.0&dpr=2.5") ;
    //
    when(win.devicePixelRatio).thenReturn(1.0);
    expect(util.preparePhotoUrl(win, Size.fromWidth(800), _photo_base_url), "$_photo_base_url&w=800.0&dpr=1.0") ;
  });
}

testAvatarUrls(Window win) {
  test("Avatar urls", () {
    when(win.devicePixelRatio).thenReturn(1.5);
    expect(util.prepareAvatarUrl(win, 50,
        "$_avatar_base_url?h=111&dpr=0&w=111&ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&cs=tinysrgb&fit=crop"),
        "$_avatar_base_url?h=50&dpr=1.5&w=50&ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&cs=tinysrgb&fit=crop");
    //
    when(win.devicePixelRatio).thenReturn(2.0);
    expect(util.prepareAvatarUrl(win, 100,
        "$_avatar_base_url?h=111&w=111&ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&cs=tinysrgb&fit=crop"),
        "$_avatar_base_url?h=100&w=100&ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&cs=tinysrgb&fit=crop&dpr=2.0");
  });
}

testStringEmptiness() {
  test("ensure String empty", () {
    expect(util.isEmpty(" "), true);
    expect(util.isEmpty(""), true);
    expect(util.isEmpty(null), true);
    expect(util.isEmpty("   "), true);
    expect(util.isEmpty(" asf "), false);
    expect(util.isEmpty("."), false);
  });
  test("ensure String not empty", () {
    expect(util.isNotEmpty("a"), true);
    expect(util.isNotEmpty(" c "), true);
    expect(util.isNotEmpty(" abA"), true);
    expect(util.isNotEmpty(""), false);
    expect(util.isNotEmpty("  "), false);
    expect(util.isNotEmpty(null), false);
  });
}
