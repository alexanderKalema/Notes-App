import 'package:flutter/material.dart';
import 'package:nibret_kifel/utils/dialogs/generic_dialog.dart';

Future<void> showErrorDialog(
  BuildContext context,
  String text,
) {
  return showGenericDialog<void>(
    icon: Icons.error,
    context: context,
    title:"An Error Occured",
    content: text,
    optionsBuilder: () => {
      'Ok': null,
      'Cancel':null
    },
  );
}
