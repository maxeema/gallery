
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

const fontCaveat        = 'Caveat';
const fontJuliusSansOne = 'JuliusSansOne';
const fontMaterialIcons = 'MaterialIcons';

snackbar(BuildContext ctx, String msg) {
  Scaffold.of(ctx)
    ..removeCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(msg),
        duration: Duration(seconds: 3),
        behavior: SnackBarBehavior.fixed
      )
    );
}

actionSnackbar(BuildContext ctx, String msg, String actionLabel, action()) {
  Scaffold.of(ctx)
    ..removeCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(msg),
        duration: Duration(seconds: 3),
        behavior: SnackBarBehavior.fixed,
        action: SnackBarAction(label: actionLabel, onPressed: () {
          Scaffold.of(ctx).removeCurrentSnackBar();
          action();
        }
      )
    )
  );
}

toast(BuildContext ctx, String msg) {
  final theme = Theme.of(ctx);
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIos: 1,
      backgroundColor: Colors.white.withAlpha(0xdd),
      textColor: Colors.black87,
      fontSize: theme.accentTextTheme.body1.fontSize
  );
}
