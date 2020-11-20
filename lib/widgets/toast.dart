import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

ToastFuture buildShowToast(BuildContext context,String toastMesg) {
  return showToast(
    toastMesg,
    duration: Duration(seconds: 2),
    backgroundColor: Colors.black38,
    context: context,
    position: StyledToastPosition.bottom,
  );
}
Future<bool> buildShowDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text('Are you sure?'),
      content: Text('Do you want to remove the item from the cart?'),
      actions: [
        FlatButton(
          child: Text('Yes'),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
        FlatButton(
          child: Text('No'),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
      ],
    ),
  );
}
