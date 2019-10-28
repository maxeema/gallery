
import 'package:flutter/widgets.dart';

mixin StateExtensions<T extends StatefulWidget> on State<T> {

  ms(int millis) => Duration(milliseconds: millis);

}