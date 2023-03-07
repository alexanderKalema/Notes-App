import 'package:flutter/material.dart';
import 'package:Notes_App/utils/dialogs/generic_dialog.dart';

Future<bool> showLogOutDialog(BuildContext context, Color color, String title,
    String bcontent, String fcontent, String lcontent) {
  return showGenericDialog<bool>(
    icon: Icons.logout_rounded,
    context: context,
    title: title,
    color: color,
    fcont: fcontent,
    content: bcontent,
    optionsBuilder: () => {
      lcontent: false,
      fcontent: true,
    },
  ).then(
    (value) => value ?? false,
  );
}
