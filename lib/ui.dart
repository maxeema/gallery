
import 'package:flutter/material.dart';

snackbar(BuildContext ctx, String msg) {
  Scaffold.of(ctx)
    ..removeCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(msg),
        duration: Duration(seconds: 3),
        behavior: SnackBarBehavior.floating
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
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(label: actionLabel, onPressed: () {
          Scaffold.of(ctx).removeCurrentSnackBar();
          action();
        }
      )
    )
  );
}
