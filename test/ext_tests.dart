import 'package:flutter_test/flutter_test.dart';
import 'package:maxeem_gallery/misc/ext.dart';
import 'package:maxeem_gallery/misc/util.dart';

void main() {
  group("on int", () {
    test('millis', () {
      expect(831.ms, Duration(milliseconds: 831));
      expect(500.ms.inMilliseconds, 500);
    });
    test('seconds', () {
      expect(5.sec, Duration(milliseconds: 5000));
      expect(5.sec, Duration(seconds: 5));
      expect(5.sec.inSeconds, 5);
      expect(5.sec.inMilliseconds, 5000);
    });
  });
  group("on String", () {
    test('leave mandatory url part', () {
      expect("https://www.yahoo.com/".leaveMandatoryUrl(), "yahoo.com");
      expect("http://ig.com/".leaveMandatoryUrl(), "ig.com");
      expect("test.com/2345".leaveMandatoryUrl(), "test.com/2345");
    });
    test('social links by user name', () {
      expect(twitterUrlByUser("maxeem"), "https://twitter.com/maxeem");
      expect(instragramUrlByUser("maxeem"), "https://www.instagram.com/maxeem");
    });
  });
}