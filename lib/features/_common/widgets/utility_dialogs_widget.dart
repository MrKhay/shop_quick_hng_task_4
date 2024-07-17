import 'package:flutter/material.dart';
import '../../features.dart';

/// returns true when accepted and false when not
Future<bool?> showConfirmationDialog(
  BuildContext context, {
  required String titleText,
  Color? actionBtnColor,
  Color? actionTxtColor,
}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) => AlertDialog(
      backgroundColor: context.colorScheme.inverseSurface,
      content: Text(titleText,
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: context.colorScheme.onInverseSurface,
          )),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: Text(
            kNo,
            style: context.textTheme.bodyLarge?.copyWith(
              color: context.colorScheme.onInverseSurface,
            ),
          ),
        ),
        MaterialButton(
          color: actionBtnColor ?? context.colorScheme.error,
          shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(kGap_4)),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: Text(
            kYes,
            style: context.textTheme.bodyLarge?.copyWith(
              color: actionTxtColor ?? context.colorScheme.onError,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
  );
}
